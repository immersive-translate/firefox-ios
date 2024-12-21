
function GM_getValue(name, defaultVal) {
    let value =  dsBridge.call("localStorage.getItem", { key: name })
    value = value || defaultVal;
  try {
    return JSON.parse(value);
  } catch (error) {
    return value;
  }
}

function GM_setValue(name, value) {
  if (typeof value === "object") value = JSON.stringify(value);
  dsBridge.call("localStorage.setItem", { key: name, value: String(value) });
}

function GM_deleteValue(name) {
  dsBridge.call("localStorage.removeItem", { key: name });
}

function GM_listValues() {
  const length = dsBridge.call("localStorage.length");
  const keys = [];
  for (let i = 0; i < length; i++) {
    const value = dsBridge.call("localStorage.key", { index: i });
    keys.push(value);
  }
  return keys;
}

function GM_xmlhttpRequest(details) {
  const { url, method, ...options } = details;
  dsBridge.call(
    "httpClient.request",
    {
      url: url,
      method: method,
      params: JSON.stringify(options)
    },
    (response) => {
        // 假设原生端返回的响应是一个 JSON 对象，包含状态码和数据
        if (response) {
            const parsedResponse = JSON.parse(response);
            const options = {
                 status: parsedResponse.statusCode,
                 statusText: parsedResponse.statusText,
                 responseHeaders: parsedResponse.headers,
                 responseURL: parsedResponse.responseURL,
                 responseText: typeof parsedResponse.data=="object"? JSON.stringify(parsedResponse.data): parsedResponse.data
               };
            if (details.onload) {
                details.onload(options);
            }
        } else if (details.onerror) {
            // 没有响应，可能是网络错误或其他问题
            details.onerror('No response received');
        }
    }
  );
}

function GM_registerMenuCommand(name, func, accessKey) {
  console.log(`Menu command registered: ${name}`);
  // 实际上，你需要在页面上添加一个用户界面元素，如按钮，并将 func 绑定为其点击事件处理程序
}

function GM_addStyle(css) {
  const style = document.createElement("style");
  style.type = "text/css";
  style.innerHTML = css;
  document.head.appendChild(style);
}

function GM_openInTab(url, openInBackground) {
   dsBridge.call("window.open", { url});
}

function GM_openInTab(url, openInBackground) {
   dsBridge.call("window.open", { url});
}

function GM_getSelectedLanguage() {
  let value = dsBridge.call("business.getSelectedLanguage", {});
  try {
    return JSON.parse(value);
  } catch (error) {
      return {};
  }
}

function WJ_doSend(obj, cb) {
    const { type } = obj;
    if (type === 'setDefaultBrowser') {
        dsBridge.call("business.setDefaultBrowser", {});
        if (cb) {
            cb()
        }
    } else if (type === "isDefaultBrowser") {
        const value = dsBridge.call("business.isDefaultBrowser", {});
        if (cb) {
            cb({"isDefaultBrowser" : (value ? true : false)})
        }
    } else if (type === "shareContent") {
       dsBridge.call("business.shareContent", obj);
       if (cb) {
           cb()
       }
    }
}

window.WebViewJavascriptBridge = {
    doSend: WJ_doSend
};


window.GM = {
  getValue: GM_getValue,
  setValue: GM_setValue,
  deleteValue: GM_deleteValue,
  listValues: GM_listValues,
  xmlhttpRequest: GM_xmlhttpRequest,
  registerMenuCommand: GM_registerMenuCommand,
  addStyle: GM_addStyle,
  openInTab: GM_openInTab,
  getSelectedLanguage: GM_getSelectedLanguage
};

