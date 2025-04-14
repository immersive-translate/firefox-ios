// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import SwiftUI


//class ToolBarTipHostingController: UIHostingController<ToolBarTipViewModel> {
//    let viewModel: ToolBarTipViewModel
//
//}


extension UIView {
    func showToolBarPopover(
        title: String,
        btnTitle: String,
        onClose: (() -> Void)? = nil,
        sourceRect: CGRect? = nil,
        arrowDirections: UIPopoverArrowDirection = .any,
        completion: (() -> Void)? = nil
        
    ) {
        let viewModel = ToolBarTipViewModel(title: title, btnTitle: btnTitle)
        let hostingController = UIHostingController(rootView: ToolBarTipSwiftUI(viewModel: viewModel))
        
        viewModel.onClick = { [weak hostingController] in
            hostingController?.dismiss(animated: true, completion: {
                onClose?()
            })
        }
        let size = hostingController.sizeThatFits(in: CGSize(width: UIView.layoutFittingExpandedSize.width,
                                                            height: UIView.layoutFittingExpandedSize.height))
        hostingController.preferredContentSize = size
        showPopover(
            with: hostingController,
            sourceRect: sourceRect,
            arrowDirections: arrowDirections,
            completion: completion,
            onClose: onClose
        )
    }
}

class ToolBarTipViewModel: ObservableObject {
    let title: String
    let btnTitle: String
    var onClick: (() -> Void)?
    
    init(title: String, btnTitle: String) {
        self.title = title
        self.btnTitle = btnTitle
    }
}

struct ToolBarTipSwiftUI: View {
    var viewModel: ToolBarTipViewModel

    init(viewModel: ToolBarTipViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Text(viewModel.title)
                .font(Font.custom("Noto Sans SC", size: 14))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                .padding(.top, 19)  // 仅在顶部添加 20 点的内边距
                .padding(.leading, 17)  // 仅在左侧添加 10 点的内边距
                .padding(.bottom, 0)
                .padding(.trailing, 19)

            Button(action: {
                viewModel.onClick?()
            }) {
                Text(viewModel.btnTitle)
                    .padding(.top, 7)  // 仅在顶部添加 20 点的内边距
                    .padding(.leading, 19)  // 仅在左侧添加 10 点的内边距
                    .padding(.bottom, 8)
                    .padding(.trailing, 17)

                    .font(Font.custom("Noto Sans SC", size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)

            }

            .foregroundColor(.clear)

            .background(Color(red: 0.92, green: 0.3, blue: 0.54))

            .cornerRadius(8)
            .padding(.top, 18)  // 仅在顶部添加 20 点的内边距
            .padding(.leading, 30)  // 仅在左侧添加 10 点的内边距
            .padding(.bottom, 15)
            .padding(.trailing, 26)
        }
        .background(Color.white)
    }
}

#Preview {
    ToolBarTipSwiftUI(viewModel: .init(title: "点击这里\n打开翻译功能面板", btnTitle: "我知道了"))
}
