//
//  PostsRouter.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 03.11.2023.
//

import UIKit

protocol PostsRouterProtocol {
    
    func showPostDetail(id: Int)
    
}

final class PostsRouter: PostsRouterProtocol {
    
    // MARK: Private Properties
    
    private weak var view: ScreenTransitionable?
    
    // MARK: Init
    
    init(view: ScreenTransitionable) {
        self.view = view
    }

    // MARK: Public Methods
    
    func showPostDetail(id: Int) {
        // TODO: Refactor second screen to MVP+R module
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.postID = id
        
        view?.showScreen(postDetailViewController)
    }
    
}
