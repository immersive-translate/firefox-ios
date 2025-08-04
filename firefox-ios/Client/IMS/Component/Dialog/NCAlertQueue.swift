//
//  NCAlertQueue.swift
//  PhotonCity
//
//  Created by yuanchao on 2023/3/11.
//

import Foundation

// MARK: - 弹窗队列，用于弹窗顺序展示（第一个弹窗消息之后，下一个弹窗才展示），加入队列的弹窗都是通过自建window的方式展示

public class NCAlertQueue {
    /// 默认弹窗队列
    public static let `default` = NCAlertQueue()

    private lazy var alertViewList: [NCAlertView] = []

    private var currentAlertView: NCAlertView?

    /// 将弹窗加入队列
    /// - Parameter alertView: 将要将入队列的弹窗
    public func enqueue(_ alertView: NCAlertView) {
        alertViewList.append(alertView)
        alertView.dismissClosure = { [weak self] in
            self?.currentAlertView = nil
            self?.tryNext()
        }

        tryNext()
    }

    /// 从队列中移除指定的弹窗
    /// - Parameter alertView: 将要移除的弹窗
    public func remove(_ alertView: NCAlertView) {
        alertViewList.removeAll(where: { $0 == alertView })
    }

    func tryNext() {
        guard currentAlertView == nil, let alertView = alertViewList.first else {
            return
        }

        alertViewList.removeFirst()
        currentAlertView = alertView

        DispatchQueue.main.async {
            alertView.show()
        }
    }
}
