//
//  PostsModuleAssembly.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 03.11.2023.
//

import UIKit

final class PostsModuleAssembly {
    
    func assemble() -> UIViewController {
        let postManager = PostManager()
        
        let view = PostsViewController()
        let router = PostsRouter(view: view)
        let presenter = PostsPresenter(view: view,
                                       postManager: postManager,
                                       router: router)
        
        view.presenter = presenter
        
        return view
    }
    
}
