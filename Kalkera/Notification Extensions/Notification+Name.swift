//
//  Notification+Name.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-25.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let KLockButtonLocked = Notification.Name("KLockButtonLocked")
    static let KLockButtonLocking = Notification.Name("KLockButtonLocking")
    static let KLockButtonUnlocked = Notification.Name("KLockButtonUnlocked")
    static let KLockButtonUnlocking = Notification.Name("KLockButtonUnlocking")

    static let KImageEdited = Notification.Name("KImageEdited")
    static let KImageReset = Notification.Name("KImageReset")
}
