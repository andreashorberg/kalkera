//
//  KDevice.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-29.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import UIKit

public enum KDevice {
    case iPad326PPI
    case iPad264PPI
    case notIpad
}

public extension UIDevice {
    public var deviceType: KDevice {
        guard UIDevice.current.userInterfaceIdiom == .pad else { return .notIpad }
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        switch identifier {
        case "iPad4,4", "iPad4,5", "iPad4,6", "iPad4,7", "iPad4,8", "iPad4,9", "iPad5,1", "iPad5,2":
            return .iPad326PPI
        default:
            return .iPad264PPI
        }
    }
}
