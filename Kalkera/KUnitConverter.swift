//
//  KUnitConverter.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-29.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import UIKit

class KUnitConverter {
    let a6InchWidth: CGFloat = 4.1
    let a6InchHeight: CGFloat = 5.8

    var a6PixelWidth: CGFloat {
        switch UIDevice.current.deviceType {
        case .iPad326PPI:
            let pixelWidth: CGFloat = 326 * a6InchWidth
            return CGFloat(pixelWidth / 2)
        case .iPad264PPI:
            let pixelWidth: CGFloat = 264 * a6InchWidth
            return CGFloat(pixelWidth / 2)
        default:
            return UIScreen.main.bounds.width
        }
    }
    var a6PixelHeight: CGFloat {
        switch UIDevice.current.deviceType {
        case .iPad326PPI:
            let pixelHeight = 326 * a6InchHeight
            return CGFloat(pixelHeight / 2)
        case .iPad264PPI:
            let pixelHeight = 264 * a6InchHeight
            return CGFloat(pixelHeight / 2)
        default:
            return UIScreen.main.bounds.width
        }
    }
}
