//
//  PostsPresenter.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 03.11.2023.
//

import Foundation

// TODO: Move protocols to Contract file?
protocol PostsViewInput: AnyObject {
    
    // TODO: Use state of the view instead?
    
    func showActivityIndicator()
    func hideActivityIndicator()
    func refreshTableView()
    func show(error: Error)
    
}

protocol PostsViewOutput {
    
    var posts: [Post] { get }
    
    func didPullToRefresh()
    func didTapSortByDateMenuOption()
    func didTapSortByLikesMenuOption()
    func didSelectPostAt(index: Int)
    
    func loadPosts() // should not access such methods directly
    func getPostsCount() -> Int    
}

final class PostsPresenter {
    
    // MARK: Public Properties
    
    weak var view: PostsViewInput?
    
    private(set) var posts: [Post] = []
    
    // MARK: Private Properties
    
    private let postManager: PostManagerProtocol
    private let router: PostsRouterProtocol
    
    // MARK: Init
    
    init(view: PostsViewInput,
         postManager: PostManagerProtocol,
         router: PostsRouterProtocol
    ) {
        self.view = view
        self.postManager = postManager
        self.router = router
    }
    
    // MARK: Public methods

    func loadPosts() {
        Task {
            do {
                // TODO: Why did I needed to add DispatchQueue.main.async?
                DispatchQueue.main.async {
                    self.view?.showActivityIndicator()
                }
                
                posts = try await postManager.fetchPosts()
                
                DispatchQueue.main.async {
                    self.view?.refreshTableView()
                    self.view?.hideActivityIndicator()
                }
            } catch {
                DispatchQueue.main.async {
                    self.view?.show(error: error as NSError)
                }
            }
        }   
    }
    
    func getPostsCount() -> Int {
        posts.count
    }
    
    // MARK: Private Methods
    
    private func sortPostsBy(_ sortOrder: SortOrder) {
        switch sortOrder {
        case .datePosted:
            posts.sort { $0.timestamp > $1.timestamp }
        case .likes:
            posts.sort { $0.likesCount > $1.likesCount }
        }
        
        view?.refreshTableView()
    }
    
    private func showDetailForPostAt(index: Int) {
        let postID = posts[index].id
        router.showPostDetail(id: postID)
    }
    
}

extension PostsPresenter: PostsViewOutput {
    
    func didPullToRefresh() {
        loadPosts()
    }
    
    func didTapSortByDateMenuOption() {
        sortPostsBy(.datePosted)
    }
    
    func didTapSortByLikesMenuOption() {
        sortPostsBy(.likes)
    }
    
    func didSelectPostAt(index: Int) {
        showDetailForPostAt(index: index)
    }
    
}
