// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import LTXiOSUtils

enum DebugToolMenu: CaseIterable {
    case networkEnv
    case deugLog
    var title: String {
        switch self {
        case .networkEnv:
            return "网络环境"
        case .deugLog:
            return "显示Debug日志"
        }
    }
}

class DebugToolViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 44
        tableView.backgroundColor = .clear
        return tableView
    }()

    private var arr: [DebugToolMenu] = DebugToolMenu.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DebugTool"
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
    }
}

extension DebugToolViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.removeCorner()
        if indexPath.row == 0, indexPath.row == arr.count - 1 {
            cell.setCorner(size: 10, roundingCorners: .allCorners)
        } else if indexPath.row == 0 {
            cell.setCorner(size: 10, roundingCorners: [.topLeft, .topRight])
        } else if indexPath.row == arr.count - 1 {
            cell.setCorner(size: 10, roundingCorners: [.bottomLeft, .bottomRight])
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "")
        cell.selectionStyle = .none
        let model = arr[indexPath.row]
        cell.textLabel?.text = model.title
        cell.accessoryType = .disclosureIndicator
        switch model {
        case .networkEnv:
            cell.detailTextLabel?.text = IMSAppManager.shared.currentEnv.name
        case .deugLog:
            cell.detailTextLabel?.text = "\(UserDefaultsConfig.debugLog)"
        }
        return cell
    }
}

extension DebugToolViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = arr[indexPath.row]
        switch model {
        case .networkEnv:
            if IMSAppManager.shared.currentEnv == .product {
                UserDefaultsConfig.networkEnvStr = IMSAppUrlConfig.IMSAppENV.dev.rawValue
            } else {
                UserDefaultsConfig.networkEnvStr = IMSAppUrlConfig.IMSAppENV.product.rawValue
            }
            tableView.reloadData()
        case .deugLog:
            UserDefaultsConfig.debugLog = !UserDefaultsConfig.debugLog
            tableView.reloadData()
        }
    }
}
