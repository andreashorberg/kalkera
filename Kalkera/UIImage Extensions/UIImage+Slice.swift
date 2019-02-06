//
//  UIImage+Slice.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-21.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import UIKit

extension UIImage {
    func slice(rows: Int, columns: Int) -> [UIImage]? {
        let width: CGFloat
        let height: CGFloat

        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = size.height
            height = size.width
        default:
            width = size.width
            height = size.height
        }

        let tileWidth = width / CGFloat(columns)
        let tileHeight = height / CGFloat(rows)

        var images: [UIImage] = []

        guard let cgImageOriginal = cgImage else {
            KCrashReporter.report(description: "Couldn't get cgImage", code: .unexpectedNil, throw: true)
            return nil
        }

        var adjustedHeight = tileHeight

        var y: CGFloat = 0.0
        for row in 0 ..< rows {
            if row == (rows - 1) {
                adjustedHeight = height - y
            }
            var adjustedWidth = tileWidth
            var x: CGFloat = 0.0
            for column in 0 ..< columns {
                if column == (columns - 1) {
                    adjustedWidth = width - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                guard let tileCgImage = cgImageOriginal.cropping(to: CGRect(origin: origin, size: size)) else {
                    KCrashReporter.report(description: "Couldn't crop cgImage", code: .unexpectedNil, throw: true)
                    return nil
                }
                images.append(UIImage(cgImage: tileCgImage, scale: scale, orientation: imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        guard images.count == rows*columns else {
            KCrashReporter.report(description: "Wrong number of rows: \(images.count), expected \(rows*columns)", code: .dataInconsistency, throw: true)
            return nil
        }
        return images
    }
}
