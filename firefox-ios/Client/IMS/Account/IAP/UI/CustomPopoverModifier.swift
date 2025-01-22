// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI

// 自定义 UIViewControllerRepresentable
struct IMSCustomPopoverModifier: ViewModifier {
    @Binding var isPresented: Bool
    let content: () -> any View
    
    func body(content: Content) -> some View {
        content
            .background(
                PopoverController(
                    isPresented: $isPresented,
                    content: self.content
                )
            )
    }
}

struct PopoverController: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let content: () -> any View
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            let hostingController = UIHostingController(rootView: AnyView(content()))
            hostingController.modalPresentationStyle = .popover
            hostingController.view.backgroundColor = .clear
            
            if let popover = hostingController.popoverPresentationController {
                popover.sourceView = uiViewController.view
                popover.delegate = context.coordinator
                // 自动计算大小
                let size = hostingController.sizeThatFits(in: CGSize(width: UIView.layoutFittingExpandedSize.width,
                                                                    height: UIView.layoutFittingExpandedSize.height))
                hostingController.preferredContentSize = size
                
                // 设置箭头位置
                popover.sourceRect = uiViewController.view.bounds
                popover.permittedArrowDirections = .any
            }
            
            uiViewController.present(hostingController, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        let parent: PopoverController
        
        init(parent: PopoverController) {
            self.parent = parent
        }
        
        // 强制使用 popover 样式
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
        
        // 处理 popover 消失
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }
    }
}

// 使用扩展简化调用
extension View {
    func customPopover<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            IMSCustomPopoverModifier(
                isPresented: isPresented,
                content: content
            )
        )
    }
}

