//
//  KCoordinator.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-12.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import UIKit

protocol KCoordinator: class {
    static var domain: String { get }
    static var bundleID: String { get }
    var childCoordinators: [KCoordinator] { get set }
    var rootViewController: UIViewController { get set }
    var userActivity: NSUserActivity? { get set }
    var navigationTitle: String? { get }
    init(viewController: UIViewController)
    func start(animated: Bool)
    func handle(_ activity: NSUserActivity, fromNavigation: Bool)
    func canHandle(_ activity: NSUserActivity) -> Bool
    func coordinator(for activity: NSUserActivity) -> KCoordinator?
}

enum KCoordinatorPresentationStyle {
    case modal
    case push
}

extension KCoordinator {
    func coordinator(for activity: NSUserActivity) -> KCoordinator? {
        guard canHandle(activity) else {
            return childCoordinators.compactMap({ $0.coordinator(for: activity) }).first
        }
        return self
    }
    
    public static var bundleID: String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    public static var domain: String {
        return bundleID + ".base"
    }
    
    var backTitle: String {
        return "BACK"//.localizedString
    }
    
    /// Override in implementation if this coordinator can handle any NSUserActivities
    func canHandle(_ activity: NSUserActivity) -> Bool {
        return false
    }
    
    func transition(to viewController: UIViewController, animated: Bool, with style: KCoordinatorPresentationStyle) {
        switch style {
        case .modal:
            present(viewController, animated: animated)
        case .push:
            pushViewController(viewController, animated: animated)
        }
    }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        addBackButton(to: viewController)
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: animated)
        } else if let navigationController = rootViewController.presentedViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: animated)
        } else if let navigationController = rootViewController.navigationController {
            navigationController.pushViewController(viewController, animated: animated)
        } else {
            let navigationController = UINavigationController()
            navigationController.pushViewController(viewController, animated: animated)
            rootViewController.present(navigationController, animated: animated, completion: nil)
        }
    }
    
    func addBackButton(to viewController: UIViewController) {
        let backItem = UIBarButtonItem()
        backItem.title = backTitle
        viewController.navigationItem.backBarButtonItem = backItem
    }
    
    func present(_ viewController: UIViewController, animated: Bool, completion: (()->())? = nil) {
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.topViewController?.present(viewController, animated: animated, completion: nil)
        } else if let navigationController = rootViewController.presentedViewController as? UINavigationController {
            navigationController.topViewController?.present(viewController, animated: animated, completion: nil)
        } else if let navigationController = rootViewController.navigationController {
            navigationController.topViewController?.present(viewController, animated: animated, completion: nil)
        } else {
            rootViewController.present(viewController, animated: animated, completion: nil)
        }
    }
    
    func dismissModal(animated: Bool, completion: (()->())? = nil) {
        if let navigationController = rootViewController as? UINavigationController {
            navigationController.topViewController?.dismiss(animated: true, completion: nil)
        } else if let navigationController = rootViewController.presentedViewController as? UINavigationController {
            navigationController.topViewController?.dismiss(animated: true, completion: nil)
        } else {
            rootViewController.dismiss(animated: true, completion: nil)
        }
    }
}
