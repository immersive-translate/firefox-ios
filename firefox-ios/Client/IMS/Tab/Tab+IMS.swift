// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import ObjectiveC.runtime

protocol LegacyTabIMSDelegate: AnyObject {

    func getBrowserVC() -> BrowserViewController?
}

class LegacyTabIMSDelegateWrapper {
    weak var imsTabDelegate: LegacyTabIMSDelegate?

    init(imsTabDelegate: LegacyTabIMSDelegate?) {
        self.imsTabDelegate = imsTabDelegate
    }
}

extension BrowserViewController: LegacyTabIMSDelegate {
    @_dynamicReplacement(
        for:tabManager(_:didAddTab:placeNextToParentTab:isRestoring:)
    )
    func ims_tabManager(
        _ tabManager: TabManager, didAddTab tab: Tab,
        placeNextToParentTab: Bool, isRestoring: Bool
    ) {
        self.tabManager(
            tabManager, didAddTab: tab,
            placeNextToParentTab: placeNextToParentTab, isRestoring: isRestoring
        )
        tab.imsTabDelegateWrapper = .init(imsTabDelegate: self)
    }

    func getBrowserVC() -> BrowserViewController? {
        return self
    }

}

extension Tab {

    struct IMSTabAssociatedKeys {
        static var imsTabDelegateKey: UInt8 = 0
    }

    var imsTabDelegateWrapper: LegacyTabIMSDelegateWrapper? {
        get {
            // 获取关联对象
            return objc_getAssociatedObject(
                self, &IMSTabAssociatedKeys.imsTabDelegateKey)
                as? LegacyTabIMSDelegateWrapper
        }
        set {
            // 设置关联对象
            objc_setAssociatedObject(
                self, &IMSTabAssociatedKeys.imsTabDelegateKey, newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    @_dynamicReplacement(for:createWebview(with:configuration:))
    func ims_createWebview(
        with restoreSessionData: Data? = nil,
        configuration: WKWebViewConfiguration
    ) {
        
        self.createWebview(
            with: restoreSessionData, configuration: configuration)
        guard let webView = self.webView else { return }
        webView.disableJavascriptDialogBlock(false)
        webView.addJavascriptObject(
            LocalStorageJSObject(), namespace: "localStorage")
        webView.addJavascriptObject(
            HttpClientJSObject(), namespace: "httpClient")

        let businessJSObject = BusinessJSObject { [self] params in
            var text = ""
            if let title = params["title"], !title.isEmpty {
                text = title
            }
            if let content = params["content"], !content.isEmpty {
                text = text + "\n" + content
            }
            let browserVC = self.imsTabDelegateWrapper?.imsTabDelegate?
                .getBrowserVC()
            browserVC?.navigationHandler?.showShareSheet(
                shareType: .site(url: URL(string: params["url"] ?? "")!),
                shareMessage: ShareMessage(message: text, subtitle: nil),
                sourceView: browserVC!.view!, sourceRect: nil,
                toastContainer: browserVC!.view!, popoverArrowDirection: .up)

        } configDefaultBrowserBlock: {
            DefaultApplicationHelper().open(
                URL(string: "fennec://deep-link?url=default-browser/tutorial")!)
        }
        webView.addJavascriptObject(businessJSObject, namespace: "business")
        let windowJSObejct = WindowJSObject { [self] url in
            let browserVC = self.imsTabDelegateWrapper?.imsTabDelegate?
                .getBrowserVC()
            browserVC?.openURLInNewTab(URL(string: url))
        }

        webView.addJavascriptObject(windowJSObejct, namespace: "window")

        webView.setDebugMode(false)

        NotificationCenter.default.addObserver(
            forName: .NeedRefreshImmersiveTranslateJsInject, object: nil,
            queue: .main
        ) { _ in
            UserScriptManager.shared.injectUserScriptsIntoWebView(
                self.webView, nightMode: self.nightMode,
                noImageMode: self.noImageMode)
        }
    }
}

extension TabWebView: WKUIDelegate {
    
    struct AssociatedKeys {
        static var alertHandler = "alertHandler"
        static var confirmHandler = "confirmHandler"
        static var promptHandler = "promptHandler"
        static var javascriptCloseWindowListener = "javascriptCloseWindowListener"
        static var dialogType = "dialogType"
        static var callId = "callId"
        static var jsDialogBlock = "jsDialogBlock"
        static var javaScriptNamespaceInterfaces = "javaScriptNamespaceInterfaces"
        static var handlerMap = "handlerMap"
        static var callInfoList = "callInfoList"
        static var dialogTextDic = "dialogTextDic"
        static var txtName = "txtName"
        static var lastCallTime = "lastCallTime"
        static var jsCache = "jsCache"
        static var isPending = "isPending"
        static var isDebug = "isDebug"
        static var DSUIDelegate = "DSUIDelegate"
    }
    
    @objc class InternalApis: NSObject {
        @objc var webview: TabWebView?
        
        @objc func hasNativeMethod(_ args: [String: Any]) -> Any? {
            return webview?.onMessage(args, type: DSB_API_HASNATIVEMETHOD)
        }
        
        @objc func closePage(_ args: [String: Any]) -> Any? {
            return webview?.onMessage(args, type: DSB_API_CLOSEPAGE)
        }
        
        @objc func returnValue(_ args: [String: Any]) -> Any? {
            return webview?.onMessage(args, type: DSB_API_RETURNVALUE)
        }
        
        @objc func dsinit(_ args: [String: Any]) -> Any? {
            return webview?.onMessage(args, type: DSB_API_DSINIT)
        }
        
        @objc func disableJavascriptDialogBlock(_ args: [String: Any]) -> Any? {
            return webview?.onMessage(args, type: DSB_API_DISABLESAFETYALERTBOX)
        }
    }
    
    private final class WeakWrapper {
        weak var value: AnyObject?
        
        init(_ value: AnyObject?) {
            self.value = value
        }
    }
    
    // MARK: - Private Properties
        private var alertHandler: (() -> Void)? {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.alertHandler) as? (() -> Void)
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.alertHandler, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var confirmHandler: ((Bool) -> Void)? {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.confirmHandler) as? ((Bool) -> Void)
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.confirmHandler, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var promptHandler: ((String?) -> Void)? {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.promptHandler) as? ((String?) -> Void)
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.promptHandler, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var javascriptCloseWindowListener: (() -> Void)? {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.javascriptCloseWindowListener) as? (() -> Void)
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.javascriptCloseWindowListener, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var dialogType: Int {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.dialogType) as? Int ?? 0
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.dialogType, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var callId: Int {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.callId) as? Int ?? 0
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.callId, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var jsDialogBlock: Bool {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.jsDialogBlock) as? Bool ?? true
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.jsDialogBlock, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
    private var javaScriptNamespaceInterfaces: [String: AnyObject] {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.javaScriptNamespaceInterfaces) as? [String: AnyObject] ?? [:]
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.javaScriptNamespaceInterfaces, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var handlerMap: [NSNumber: Any] {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.handlerMap) as? [NSNumber: Any] ?? [:]
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.handlerMap, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var callInfoList: [DSCallInfo]? {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.callInfoList) as? [DSCallInfo]
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.callInfoList, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var dialogTextDic: [String: String] {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.dialogTextDic) as? [String: String] ?? [:]
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.dialogTextDic, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var txtName: UITextField? {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.txtName) as? UITextField
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.txtName, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var lastCallTime: UInt64 {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.lastCallTime) as? UInt64 ?? 0
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.lastCallTime, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var jsCache: String {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.jsCache) as? String ?? ""
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.jsCache, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var isPending: Bool {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.isPending) as? Bool ?? false
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.isPending, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
        
        private var isDebug: Bool {
            get {
                return objc_getAssociatedObject(self, &AssociatedKeys.isDebug) as? Bool ?? false
            }
            set {
                objc_setAssociatedObject(self, &AssociatedKeys.isDebug, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    
    // MARK: - Public Properties
    weak var DSUIDelegate: WKUIDelegate? {
        get {
            let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.DSUIDelegate) as? WeakWrapper
            return wrapper?.value as? WKUIDelegate
        }
        set {
            let wrapper = WeakWrapper(newValue as AnyObject?)
            objc_setAssociatedObject(self, &AssociatedKeys.DSUIDelegate, wrapper, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - Initialization
    
    @_dynamicReplacement(for: configure(delegate:navigationDelegate:))
    func ims_configure(delegate: TabWebViewDelegate,
                   navigationDelegate: WKNavigationDelegate?) {
        self.setup()
        self.configure(delegate: delegate, navigationDelegate: navigationDelegate)
    }
    
    func setup() {
        
        dialogType = 0
        callId = 0
        jsDialogBlock = true
        callInfoList = []
        javaScriptNamespaceInterfaces = [:]
        handlerMap = [:]
        lastCallTime = 0
        jsCache = ""
        isPending = false
        isDebug = false
        dialogTextDic = [:]
        
        let script = WKUserScript(source: "window._dswk=true;",
                                injectionTime: .atDocumentStart,
                                forMainFrameOnly: true)
        configuration.userContentController.addUserScript(script)
        
        self.uiDelegate = self
        
        // Add internal Javascript Object
        let internalApis = InternalApis()
        internalApis.webview = self
        addJavascriptObject(internalApis, namespace: "_dsb")
        setJavascriptCloseWindowListener {[weak self] in
            guard let self = self else { return }
            self.DSUIDelegate?.webViewDidClose?(self)
        }
    }
    
    
    
    // MARK: - WKUIDelegate Methods
    func webView(_ webView: WKWebView,
                runJavaScriptTextInputPanelWithPrompt prompt: String,
                defaultText: String?,
                initiatedByFrame frame: WKFrameInfo,
                completionHandler: @escaping (String?) -> Void) {
        
        let prefix = "_dsbridge="
        if prompt.hasPrefix(prefix) {
            let method = String(prompt.dropFirst(prefix.count))
            var result: String?
            
            if isDebug {
                result = call(method: method, argStr: defaultText)
            } else {
                do {
                    result = call(method: method, argStr: defaultText)
                } catch {
                    print(error)
                }
            }
            completionHandler(result)
            
        } else {
            if !jsDialogBlock {
                completionHandler(nil)
            }
            
            if let delegate = DSUIDelegate,
               delegate.responds(to: #selector(webView(_:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:))) {
                delegate.webView?(webView,
                                runJavaScriptTextInputPanelWithPrompt: prompt,
                                defaultText: defaultText,
                                initiatedByFrame: frame,
                                completionHandler: completionHandler)
            } else {
                dialogType = 3
                if jsDialogBlock {
                    promptHandler = completionHandler
                }
                
                let alert = UIAlertController(title: prompt,
                                            message: "",
                                            preferredStyle: .alert)
                
                alert.addTextField { [weak self] textField in
                    self?.txtName = textField
                    textField.text = defaultText
                }
                
                let cancelAction = UIAlertAction(
                    title: dialogTextDic["promptCancelBtn"] ?? "取消",
                    style: .cancel) { [weak self] _ in
                    self?.promptHandler?("")
                }
                
                let okAction = UIAlertAction(
                    title: dialogTextDic["promptOkBtn"] ?? "确定",
                    style: .default) { [weak self] _ in
                    self?.promptHandler?(self?.txtName?.text)
                }
                
                alert.addAction(cancelAction)
                alert.addAction(okAction)
                
                if let topVC = UIApplication.shared.keyWindow?.rootViewController {
                    topVC.present(alert, animated: true)
                }
            }
        }
    }
    
    // MARK: - WKUIDelegate Methods (continued)
    func webView(_ webView: WKWebView,
                runJavaScriptAlertPanelWithMessage message: String,
                initiatedByFrame frame: WKFrameInfo,
                completionHandler: @escaping () -> Void) {
        
        if !jsDialogBlock {
            completionHandler()
        }
        
        if let delegate = DSUIDelegate,
           delegate.responds(to: #selector(webView(_:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:))) {
            delegate.webView?(webView,
                            runJavaScriptAlertPanelWithMessage: message,
                            initiatedByFrame: frame,
                            completionHandler: completionHandler)
        } else {
            dialogType = 1
            if jsDialogBlock {
                alertHandler = completionHandler
            }
            
            let alert = UIAlertController(
                title: dialogTextDic["alertTitle"] ?? "提示",
                message: message,
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(
                title: dialogTextDic["alertBtn"] ?? "确定",
                style: .default) { [weak self] _ in
                self?.alertHandler?()
            }
            
            alert.addAction(okAction)
            
            if let topVC = UIApplication.shared.keyWindow?.rootViewController {
                topVC.present(alert, animated: true)
            }
        }
    }
    
    func webView(_ webView: WKWebView,
                runJavaScriptConfirmPanelWithMessage message: String,
                initiatedByFrame frame: WKFrameInfo,
                completionHandler: @escaping (Bool) -> Void) {
        
        if !jsDialogBlock {
            completionHandler(true)
        }
        
        if let delegate = DSUIDelegate,
           delegate.responds(to: #selector(webView(_:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:))) {
            delegate.webView?(webView,
                            runJavaScriptConfirmPanelWithMessage: message,
                            initiatedByFrame: frame,
                            completionHandler: completionHandler)
        } else {
            dialogType = 2
            if jsDialogBlock {
                confirmHandler = completionHandler
            }
            
            let alert = UIAlertController(
                title: dialogTextDic["confirmTitle"] ?? "提示",
                message: message,
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(
                title: dialogTextDic["confirmCancelBtn"] ?? "取消",
                style: .cancel) { [weak self] _ in
                self?.confirmHandler?(false)
            }
            
            let okAction = UIAlertAction(
                title: dialogTextDic["confirmOkBtn"] ?? "确定",
                style: .default) { [weak self] _ in
                self?.confirmHandler?(true)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            if let topVC = UIApplication.shared.keyWindow?.rootViewController {
                topVC.present(alert, animated: true)
            }
        }
    }
    
    // MARK: - Public Methods
    func setJavascriptCloseWindowListener(_ callback: @escaping () -> Void) {
        javascriptCloseWindowListener = callback
    }
    
    func setDebugMode(_ debug: Bool) {
        isDebug = debug
    }
    
    func loadUrl(_ url: String) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        load(request)
    }
    
    func callHandler(_ methodName: String, arguments: [Any]? = nil) {
        callHandler(methodName, arguments: arguments, completionHandler: nil)
    }
    
    func callHandler(_ methodName: String, completionHandler: ((Any?) -> Void)?) {
        callHandler(methodName, arguments: nil, completionHandler: completionHandler)
    }
    
    func callHandler(_ methodName: String,
                    arguments: [Any]?,
                    completionHandler: ((Any?) -> Void)?) {
        let callInfo = DSCallInfo()
        callInfo.id = NSNumber(value: callId)
        callId += 1
        callInfo.args = arguments ?? []
        callInfo.method = methodName
        
        if let completionHandler = completionHandler,
           let id = callInfo.id {
            handlerMap[id] = completionHandler
        }
        
        if callInfoList != nil {
            callInfoList?.append(callInfo)
        } else {
            dispatchJavascriptCall(callInfo)
        }
    }
    
    // MARK: - Private Methods
    func evalJavascript(_ delay: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(delay)) { [weak self] in
            guard let self = self else { return }
            
            objc_sync_enter(self)
            defer { objc_sync_exit(self) }
            
            if !self.jsCache.isEmpty {
                self.evaluateJavaScript(self.jsCache, completionHandler: nil)
                self.isPending = false
                self.jsCache = ""
                self.lastCallTime = UInt64(Date().timeIntervalSince1970 * 1000)
            }
        }
    }
    
    func call(method: String, argStr: String?) -> String? {
        let nameStr = JSBUtil.parseNamespace(method.trimmingCharacters(in: .whitespaces)) as! [String]
        
        let javascriptInterfaceObject = javaScriptNamespaceInterfaces[nameStr[0]]
        let error = "Error! \n Method \(method) is not invoked, since there is not a implementation for it"
        var result: [String: Any] = ["code": -1, "data": ""]
        
        guard let javascriptInterfaceObject = javascriptInterfaceObject else {
            print("Js bridge called, but can't find a corresponded JavascriptObject, please check your code!")
            return JSBUtil.obj(toJsonString: result)
        }
        
        let method = nameStr[1]
        let methodOne = JSBUtil.method(byNameArg: 1, selName: method, class: type(of: javascriptInterfaceObject))
        let methodTwo = JSBUtil.method(byNameArg: 2, selName: method, class: type(of: javascriptInterfaceObject))
        
        guard let args = JSBUtil.jsonString(toObject: argStr ?? "") as? [String: Any] else {
            return JSBUtil.obj(toJsonString: result)
        }
        
        var arg = args["data"]
        if arg is NSNull {
            arg = nil
        }
        
        if let cb = args["_dscbstub"] as? String {
            // Handle async call
            if let selAsyn = methodTwo {
                let completionHandler: (Any?, Bool) -> Void = { [weak self] value, complete in
                    guard let self = self else { return }
                    
                    var del = ""
                    result["code"] = 0
                    if let value = value {
                        result["data"] = value
                    }
                    
                    let jsonValue = JSBUtil.obj(toJsonString: result) ?? ""
                    let escapedValue = jsonValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                    
                    if complete {
                        del = "delete window.\(cb)"
                    }
                    
                    let js = "try {\(cb)(JSON.parse(decodeURIComponent(\"\(escapedValue)\")).data);\(del); } catch(e){};"
                    
                    objc_sync_enter(self)
                    defer { objc_sync_exit(self) }
                    
                    let t = UInt64(Date().timeIntervalSince1970 * 1000)
                    self.jsCache += js
                    
                    if t - self.lastCallTime < 50 {
                        if !self.isPending {
                            self.evalJavascript(50)
                            self.isPending = true
                        }
                    } else {
                        self.evalJavascript(0)
                    }
                }
                
                let selector = NSSelectorFromString(selAsyn)
                let imp = javascriptInterfaceObject.method(for: selector)
                typealias Function = @convention(c) (Any, Selector, Any?, @escaping (Any?, Bool) -> Void) -> Void
                let function = unsafeBitCast(imp, to: Function.self)
                function(javascriptInterfaceObject, selector, arg, completionHandler)
                
            }
        } else if let sel = methodOne {
            // Handle sync call
            let selector = NSSelectorFromString(sel)
            let imp = javascriptInterfaceObject.method(for: selector)
            typealias Function = @convention(c) (Any, Selector, Any?) -> Any?
            let function = unsafeBitCast(imp, to: Function.self)
            if let ret = function(javascriptInterfaceObject, selector, arg) {
                result["code"] = 0
                result["data"] = ret
            }
        } else {
            if isDebug {
                let js = "window.alert(decodeURIComponent(\"\(error.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")\"));"
                evaluateJavaScript(js, completionHandler: nil)
            }
            print(error)
        }
        
        return JSBUtil.obj(toJsonString: result)
    }

    // MARK: - Additional Methods
    func addJavascriptObject(_ object: AnyObject, namespace: String?) {
        let ns = namespace ?? ""
        javaScriptNamespaceInterfaces[ns] = object
    }
    
    func removeJavascriptObject(_ namespace: String?) {
        let ns = namespace ?? ""
        javaScriptNamespaceInterfaces.removeValue(forKey: ns)
    }
    
    func customJavascriptDialogLabelTitles(_ dic: [String: String]?) {
        if let dic = dic {
            dialogTextDic = dic
        }
    }
    
    func onMessage(_ msg: [String: Any], type: Int) -> Any? {
        switch type {
        case DSB_API_HASNATIVEMETHOD:
            return hasNativeMethod(msg) ? 1 : 0
        case DSB_API_CLOSEPAGE:
            return closePage(msg)
        case DSB_API_RETURNVALUE:
            return returnValue(msg)
        case DSB_API_DSINIT:
            return dsinit(msg)
        case DSB_API_DISABLESAFETYALERTBOX:
            disableJavascriptDialogBlock(msg["disable"] as? Bool ?? false)
            return nil
        default:
            return nil
        }
    }
    
    func hasNativeMethod(_ args: [String: Any]) -> Bool {
        guard let name = args["name"] as? String,
              let type = args["type"] as? String else {
            return false
        }
        
        let nameStr = JSBUtil.parseNamespace(name.trimmingCharacters(in: .whitespaces)) as! [String]
        guard let javascriptInterfaceObject = javaScriptNamespaceInterfaces[nameStr[0]] else {
            return false
        }
        
        
        let syn = JSBUtil.method(byNameArg: 1, selName: nameStr[1], class: javascriptInterfaceObject.classForCoder) != nil
        let asyn = JSBUtil.method(byNameArg: 2, selName: nameStr[1], class: javascriptInterfaceObject.classForCoder) != nil
        
        return (type == "all" && (syn || asyn)) ||
               (type == "asyn" && asyn) ||
               (type == "syn" && syn)
        
    }
    
    func closePage(_ args: [String: Any]) -> Any? {
        javascriptCloseWindowListener?()
        return nil
    }
    
    func returnValue(_ args: [String: Any]) -> Any? {
        guard let id = args["id"] as? NSNumber,
              let handler = handlerMap[id] as? (String?) -> Void else {
            return nil
        }
        
        let data = args["data"] as? String
        
        if isDebug {
            handler(data)
        } else {
            do {
                handler(data)
            } catch {
                print(error)
            }
        }
        
        if args["complete"] as? Bool == true {
            handlerMap.removeValue(forKey: id)
        }
        
        return nil
    }
    
    func dsinit(_ args: [String: Any]) -> Any? {
        dispatchStartupQueue()
        return nil
    }
    
    func disableJavascriptDialogBlock(_ disable: Bool) {
        jsDialogBlock = !disable
    }
    
    func dispatchStartupQueue() {
        guard let list = callInfoList else { return }
        
        for callInfo in list {
            dispatchJavascriptCall(callInfo)
        }
        callInfoList = nil
    }
    
    func dispatchJavascriptCall(_ info: DSCallInfo) {
        let json = JSBUtil.obj(toJsonString: [
            "method": info.method,
            "callbackId": info.id,
            "data": JSBUtil.obj(toJsonString: info.args)
        ])
        
        evaluateJavaScript("window._handleMessageFromNative(\(json))",
                         completionHandler: nil)
    }
    
    func hasJavascriptMethod(_ handlerName: String,
                            methodExistCallback callback: @escaping (Bool) -> Void) {
        callHandler("_hasJavascriptMethod",
                   arguments: [handlerName]) { value in
            callback((value as? NSNumber)?.boolValue ?? false)
        }
    }

}

extension TabWebView {
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        return DSUIDelegate?.webView?(webView, createWebViewWith: configuration, for: navigationAction, windowFeatures: windowFeatures)
        
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        DSUIDelegate?.webViewDidClose?(webView)
    }
    
    func webView(
        _ webView: WKWebView,
        contextMenuConfigurationForElement elementInfo: WKContextMenuElementInfo,
        completionHandler: @escaping (UIContextMenuConfiguration?) -> Void
    ) {
        
        DSUIDelegate?.webView?(webView, contextMenuConfigurationForElement: elementInfo, completionHandler: completionHandler)
    }
    
    @available(iOS 15, *)
    func webView(_ webView: WKWebView,
                 requestMediaCapturePermissionFor origin: WKSecurityOrigin,
                 initiatedByFrame frame: WKFrameInfo,
                 type: WKMediaCaptureType,
                 decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        DSUIDelegate?.webView?(webView, requestMediaCapturePermissionFor: origin, initiatedByFrame: frame, type: type, decisionHandler: decisionHandler)
    }
}
