//
//  KCrashReporter.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2019-01-10.
//  Copyright © 2019 Andreas Hörberg. All rights reserved.
//

import Foundation
import Crashlytics

@objc enum KCrashReporterErrorCode: Int {
    case imageNotFound
    case viewControllerInstantiation
    case dataInconsistency
    case unexpectedNil
    case unsupportedActivity
    case errorHandled
}

class KCrashReporter: NSObject {

    static func report(description: String, code: KCrashReporterErrorCode, throw assertion: Bool = false) {
        if assertion { assertionFailure(description) }
        Crashlytics.sharedInstance().recordError(error(description: description, code: code))
    }

    private static func error(description: String, code: KCrashReporterErrorCode) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: description]
        return NSError(domain: "Crashlytics", code: code.rawValue, userInfo: userInfo)
    }
}
