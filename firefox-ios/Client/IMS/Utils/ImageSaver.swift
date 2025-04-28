// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import UIKit

class ImageSaver: NSObject {
    private var completion: ((Error?) -> Void)?

    func writeToPhotoAlbum(image: UIImage, completion: @escaping (Error?) -> Void) {
        self.completion = completion
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        completion?(error)
    }
}
