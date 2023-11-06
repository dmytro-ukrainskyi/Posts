//
//  PostsViewController.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 31.08.2023.
//

import UIKit

final class PostsViewController: UIViewController, ScreenTransitionable {
    
    // MARK: Public Properties
    
    var presenter: PostsViewOutput?
    
    // MARK: Private Properties
    
    private let tableView = UITableView()
    
    // TODO: Should presenter handle expanding cells?
    private var expandedCellsIndices: IndexSet = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        presenter?.loadPosts()
    }
    
    // TODO: Should move handling user interactions completely to presenter?
    @objc
    func handleRefreshControl() {
        presenter?.didPullToRefresh()
        
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
}

// MARK: PostsViewProtocol

extension PostsViewController: PostsViewInput {
    
    func showActivityIndicator() {
        tableView.showActivityIndicator()

    }
    
    func hideActivityIndicator() {
        tableView.clearBackgroundView()
    }
    
    func refreshTableView() {
        tableView.reloadData()
    }
    
    func show(error: Error) {
        tableView.show(error: error as NSError)
    }
    
}

// MARK: - UI

extension PostsViewController {
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupNavigationBar()
        setupRefreshControl()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
        
        layoutTableView()
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.backgroundColor = .systemBackground
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(handleRefreshControl),
                                            for: .valueChanged)
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
            self.presenter?.didTapSortByDateMenuOption()
        }
        let sortByLikesAction = UIAction(title: "Likes") { _ in
            self.presenter?.didTapSortByLikesMenuOption()
        }
        
        // TODO: Who should be responsible for assigning menu to sort button?
        
        sortButton.menu = UIMenu(
            title: "Sort By",
            children: [sortByDateAction, sortByLikesAction]
        )
        
        navigationItem.rightBarButtonItem = sortButton
    }
    
}

// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return presenter?.getPostsCount() ?? 0
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
                
        guard let post = presenter?.posts[indexPath.row] else { return UITableViewCell() }
        
        let cellIsExpanded = expandedCellsIndices.contains(indexPath.row)
        
        postCell.configure(
            title: post.title,
            previewText: post.previewText,
            likesCount: "❤️ \(post.likesCount)",
            datePosted: post.datePosted.timeAgo()
        )
        
        /*
         Bad code.
         As cell's bounds are calculated wrong at cellForRowAt,
         it needs to know actual width to setup expand/collapse button.
         */
        let previewTextLabelWidth = tableView.bounds.width -
          (postCell.labelsLeadingConstraintConstant + postCell.labelsTrailingConstraintConstant)
        
        postCell.previewTextLabelExpectedWidth = previewTextLabelWidth
        
        postCell.setupUI(expanded: cellIsExpanded)
        
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
        
        presenter?.didSelectPostAt(index: indexPath.row)
    }
    
}
