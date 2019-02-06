//
//  KAppCoordinator.swift
//  Kalkera
//
//  Created by Andreas Hörberg on 2018-12-12.
//  Copyright © 2018 Andreas Hörberg. All rights reserved.
//

import UIKit

class KAppCoordinator: KCoordinator {
    var childCoordinators: [KCoordinator]
    var rootViewController: UIViewController
    var userActivity: NSUserActivity?
    var navigationTitle: String?
    
    required init(viewController: UIViewController) {
        childCoordinators = []
        rootViewController = viewController
    }
    
    func start(animated: Bool) {
        guard let viewController = KPickImageViewController.instantiate() else { return }
        pushViewController(viewController, animated: animated)
    }
    
    func finishedPickingImage(_ sender: KPickImageViewController) {
        sender.dismiss(animated: true, completion: nil)
    }
    
    func handle(_ activity: NSUserActivity, fromNavigation: Bool) {
        
    }
}
