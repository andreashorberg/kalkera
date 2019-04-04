//
//  KPickImageViewModel.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-12.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import UIKit

class KPickImageViewModel: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var originalImage: UIImage?
    var imageChanged: ((UIImage) -> ())?
    var slicesChanged: (([KSlice]) -> ())?
    var previousBrightness: CGFloat = 1
    var isSliced: Bool = false
    var editedImage: UIImage?
    var notificationCenter = NotificationCenter.default

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            KCrashReporter.report(description: "Image picker finished but the image was nil", code: .unexpectedNil, throw: true)
            return
        }
        originalImage = image
        notificationCenter.post(name: .KImageReset, object: nil)
        imageChanged?(image)
    }

    func sliceImage() {
        guard let image = imageToEdit() else { return }
        guard let slices = image.slice(rows: 2, columns: 2) else { return }
        isSliced = true
        notificationCenter.post(name: .KImageEdited, object: nil)
        slicesChanged?(slices)
    }

    @discardableResult func convertToGrayScale() -> Bool {
        guard let image = imageToEdit() else { return false }
        if let noir = image.noir {
            notificationCenter.post(name: .KImageEdited, object: nil)
            editedImage = noir
            if isSliced {
                sliceImage()
            } else {
                imageChanged?(noir)
            }
            return true
        }
        return false
    }

    func convertImage(toGrayScale image: UIImage) {

    }

    func imageToEdit() -> UIImage? {
        guard let image = editedImage ?? originalImage else { return nil }
        return image
    }

    func resetImage() {
        isSliced = false
        notificationCenter.post(name: .KImageReset, object: nil)
        guard let originalImage = originalImage else { return }
        editedImage = nil
        imageChanged?(originalImage)
    }

    var margin: CGFloat {
        guard isSliced else { return 0 }
        let screenWidth = UIScreen.main.bounds.width
        let margin = (screenWidth - KUnitConverter().a6PixelWidth) / 2
        return margin
    }
}
