//
//  UIImage+Noir.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-21.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import UIKit

extension UIImage {
    var noir: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else {
            KCrashReporter.report(description: "Couldn't create CIPhotoEffectNoir", code: .unexpectedNil, throw: true)
            return nil
        }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        guard
            let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) else {
                KCrashReporter.report(description: "Couldn't create noir image", code: .unexpectedNil, throw: true)
                return nil
        }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
}
