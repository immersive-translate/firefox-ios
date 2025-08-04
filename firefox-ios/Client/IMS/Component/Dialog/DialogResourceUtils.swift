//
//  DialogResourceUtils.swift
//  PhotonCity
//
//  Created by yuanchao on 2022/8/23.
//

import Foundation

private class BundleFinder {}

struct DialogResourceUtils {
    static func getImage(named: String) -> UIImage? {
        return UIImage(named: named)
    }
}
