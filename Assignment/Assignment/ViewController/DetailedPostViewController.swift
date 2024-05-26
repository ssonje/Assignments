//
//  DetailedPostViewController.swift
//  Assignment
//
//  Created by Sanket Sonje  on 25/05/24.
//

import Foundation
import UIKit

class DetailedPostViewController: UIViewController {

    // MARK: - UI Properties

    private lazy var detailedPostView: UIView = {
        let view = DetailedPostView(post: post, frame: view.frame)
        viewDelegate = view
        return view
    }()

    // MARK: - Data Model

    private let post: Post
    private var viewDelegate: DetailedPostViewDelegate?

    // MARK: - Init

    required public init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(detailedPostView)
        setupConstraints()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        viewDelegate?.updateConstraintsIfNeeded()
    }

    // MARK: - Private Helpers

    private func setupConstraints() {
        detailedPostView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailedPostView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailedPostView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailedPostView.topAnchor.constraint(equalTo: view.topAnchor),
            detailedPostView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
