//
//  PostsViewController.swift
//  Assignment
//
//  Created by Sanket Sonje  on 25/05/24.
//

import Foundation
import UIKit

/// A view controller for configuring data and displaying table view.
class PostsViewController: UIViewController, UITableViewDelegate {

    // MARK: - Properties

    @IBOutlet weak var postsTableView: UITableView!
    private static let postsTableViewCellID = "tableView.cell.identifier"
    fileprivate var viewModel: PostViewModel

    private lazy var loadMoreSpinnerView: UIView = {
        let frame = CGRect(x: 0, y: 0, width: postsTableView.frame.size.width, height: 100)
        let footerView = UIView(frame: frame)
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }()

    // MARK: - Init

    required init?(coder: NSCoder) {
        viewModel = PostViewModel(urlSession: URLSession.shared)
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPosts()
    }

    // MARK: - Private Helpers

    private func loadPosts() {
        viewModel.getPosts { [weak self] in
            guard let self else {
                InAppLogger.sharedInstance.info("[PostsViewController] Self should be non nil")
                return
            }

            self.postsTableView.dataSource = self
            self.postsTableView.delegate = self
            self.postsTableView.reloadData()
        }
    }
}

// MARK: - Table View Delegates

extension PostsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.postsTableViewCellID, for: indexPath) as! PostTableViewCell
        let post = viewModel.cellForRow(at: indexPath)
        cell.configure(for: post)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let startDate = Date()
        let post = viewModel.cellForRow(at: indexPath)
        self.navigationController?.pushViewController(DetailedPostViewController(post: post), animated: true)
        let endDate = Date()
        let dateComponent = Calendar.current.dateComponents([.second, .minute, .hour], from: startDate, to: endDate)
        InAppLogger.sharedInstance.info("[PostsViewController] It took \(String(describing: dateComponent.hour)) hour, \(String(describing: dateComponent.minute)) minute, \(String(describing: dateComponent.second)) seconds time for computation.")
    }
}

// MARK: - Scroll View Delegates

extension PostsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetMaxY: Float = Float(scrollView.contentOffset.y + scrollView.bounds.size.height)
        let contentHeight: Float = Float(scrollView.contentSize.height)
        let shouldFetchData = contentOffsetMaxY > contentHeight - 130
        if shouldFetchData {
            if viewModel.shouldShowFooterView {
                self.postsTableView.tableFooterView = loadMoreSpinnerView
            }

            viewModel.getPosts {
                DispatchQueue.main.async {
                    self.postsTableView.tableFooterView = nil
                }
                self.postsTableView.reloadData()
            }
        }
    }
}
