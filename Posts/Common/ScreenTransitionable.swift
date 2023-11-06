//
//  ScreenTransitionable.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 03.11.2023.
//

// Copied this from this this example from trainee study materials
// https://github.com/HandsAppDevelopment/HandsAppMvp-Demo

import UIKit

protocol ScreenTransitionable: AnyObject {
    func showScreen(_ screen: UIViewController)
    func dismissView(animated: Bool, completion: (() -> Void)?)
    func presentScreen(_ screen: UIViewController, animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    func push(screen: UIViewController, animated: Bool)
}

extension ScreenTransitionable where Self: UIViewController {
    func showScreen(_ screen: UIViewController) {
        show(screen, sender: nil)
    }

    func dismissView(animated: Bool, completion: (() -> Void)?) {
        presentingViewController?.dismiss(animated: animated, completion: completion)
    }

    func presentScreen(_ screen: UIViewController, 
                       animated: Bool,
                       completion: (() -> Void)?
    ) {
        present(screen, animated: animated, completion: completion)
    }

    func pop(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }

    func popToRoot(animated _: Bool) {
        navigationController?.popToRootViewController(animated: true)
    }

    func push(screen: UIViewController, animated: Bool) {
        navigationController?.pushViewController(screen, animated: animated)
    }
}
