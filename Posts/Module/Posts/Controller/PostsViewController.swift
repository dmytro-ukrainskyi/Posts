//
//  PostsViewController.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 31.08.2023.
//

import UIKit

final class PostsViewController: UIViewController {
    
    // MARK: Private Properties
    
    private let postManager: PostManagerProtocol = PostManager()
    
    private var posts: [Post] = []
    
    private let tableView = UITableView()
    
    private var expandedCellsIndices: IndexSet = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadPosts()
    }
    
    // MARK: Private Methods
    
    private func loadPosts() {
        Task {
            do {
                tableView.clearBackgroundView()
                tableView.showActivityIndicator()

                posts = try await postManager.fetchPosts()
                
                tableView.reloadData()
                tableView.clearBackgroundView()
            } catch {
                tableView.clearBackgroundView()
                tableView.show(error: error as NSError)
            }
        }
    }
    
    fileprivate func sortPostsBy(_ sortOrder: SortOrder) {
        switch sortOrder {
        case .datePosted:
            posts.sort { $0.timestamp > $1.timestamp }
        case .likes:
            posts.sort { $0.likesCount > $1.likesCount }
        }
        
        tableView.reloadData()
    }
    
    @objc
    func handleRefreshControl() {
        loadPosts()
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
}

// MARK: - UI

extension PostsViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(handleRefreshControl),
                                            for: .valueChanged)
        
        layoutTableView()
    }
    
    private func layoutTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        title = UIConstants.navigationTitle
        
        let sortButton = UIBarButtonItem(
            image: UIImage(systemName: SystemImages.sort),
            style: .plain,
            target: nil,
            action: nil
        )
        
        let sortByDateAction = UIAction(title: "Date Posted") { _ in
            self.sortPostsBy(.datePosted)
        }
        let sortByLikesAction = UIAction(title: "Likes") { _ in
            self.sortPostsBy(.likes)
        }
        
        sortButton.menu = UIMenu(
            title: "Sort By",
            children: [sortByDateAction, sortByLikesAction]
        )
        
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        tableView.backgroundView = activityIndicator
    }
    
    private func hideActivityIndicator() {
        tableView.backgroundView = nil
    }
    
}

// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return posts.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let postCell = tableView.dequeueReusableCell(
            withIdentifier: PostCell.identifier,
            for: indexPath
        ) as? PostCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        let cellIsExpanded = expandedCellsIndices.contains(indexPath.row)
        
        postCell.titleLabel.text = post.title
        postCell.previewTextLabel.text = post.previewText
        postCell.likesCountLabel.text = "❤️ \(post.likesCount)"
        postCell.datePostedLabel.text = post.datePosted.timeAgo()
        
        postCell.setupUI(expanded: cellIsExpanded)
        
        /*
         Bad code.
         As cell's bounds are calculated wrong at cellForRowAt,
         it needs to know actual width to setup expand/collapse button.
         */
        let previewTextLabelWidth = tableView.bounds.width -
          (postCell.labelsLeadingConstraintConstant + postCell.labelsTrailingConstraintConstant)
        
        postCell.previewTextLabelExpectedWidth = previewTextLabelWidth
        postCell.addExpandCollapseButtonIfNeeded(cellIsExpanded: cellIsExpanded)
        
        postCell.onExpandCollapseButtonTapped = {
            if cellIsExpanded {
                self.expandedCellsIndices.remove(indexPath.row)
            } else {
                self.expandedCellsIndices.insert(indexPath.row)
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return postCell
    }
    
}

// MARK: - UITableViewDelegate

extension PostsViewController: UITableViewDelegate {    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let postDetailViewController = PostDetailViewController()
        postDetailViewController.postID = posts[indexPath.row].id
        
        navigationController?
            .pushViewController(postDetailViewController, animated: true)
    }
    
}
