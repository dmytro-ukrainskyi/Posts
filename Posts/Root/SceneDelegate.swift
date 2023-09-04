//
//  SceneDelegate.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 31.08.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let postsViewController = PostsViewController()
        let navigationController = UINavigationController(
            rootViewController: postsViewController)
                
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
}
