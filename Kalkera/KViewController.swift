//
//  KViewController.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-12.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import UIKit

protocol KStoryboarded: class {
    static func instantiate() -> Self?
    static var storyboard: UIStoryboard { get }
}

extension KStoryboarded {
    static func instantiate() -> Self? {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        guard let viewController = Self.storyboard.instantiateViewController(withIdentifier: className) as? Self else {
            KCrashReporter.report(description: "Couldn't find viewcontroller \(className) in storyboard \(storyboard)",
                code: .viewControllerInstantiation,
                throw: true)
            return nil
        }
        return viewController
    }
}


class KViewController: UIViewController, KStoryboarded {
    class var storyboard: UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }
}
