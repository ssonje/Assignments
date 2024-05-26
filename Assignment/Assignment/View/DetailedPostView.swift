//
//  DetailedPostView.swift
//  Assignment
//
//  Created by Sanket Sonje  on 26/05/24.
//

import Foundation
import UIKit

protocol DetailedPostViewDelegate {
    func updateConstraintsIfNeeded()
}

class DetailedPostView: UIView, DetailedPostViewDelegate {

    // MARK: - UI Properties

    private lazy var postDetailsLabel: UILabel = {
        let label = createLabel(with: "Post Details")
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()

    private lazy var postIDStackView: UIStackView = {
        if let postID = post.id {
            return createStackView(staticText: "Post ID", dynamicText: String(postID))
        }
        return createStackView(staticText: "Post ID", dynamicText: nil)
    }()

    private lazy var userIDStackView: UIStackView = {
        if let userID = post.userID {
            return createStackView(staticText: "User ID", dynamicText: String(userID))
        }
        return createStackView(staticText: "User ID", dynamicText: nil)
    }()

    private lazy var titleStackView: UIStackView = {
        return createStackView(staticText: "Title", dynamicText: post.title)
    }()

    private lazy var bodyStackView: UIStackView = {
        return createStackView(staticText: "Body", dynamicText: post.body)
    }()

    private lazy var mainStackView: UIStackView = {
        return createStackView()
    }()

    private var portraitConstraints = [NSLayoutConstraint]()
    private var landscapeConstraints = [NSLayoutConstraint]()

    // MARK: - Data Model

    private let post: Post

    // MARK: - Init

    required public init(post: Post, frame: CGRect) {
        self.post = post
        super.init(frame: frame)
        setupView()
        updateConstraintsIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - DetailedPostViewDelegate

    override func updateConstraintsIfNeeded() {
        // This method gets called every time when user changes orientation,
        // so we should deactivate respective constraints before applying new constraints.
        NSLayoutConstraint.deactivate(portraitConstraints)
        NSLayoutConstraint.deactivate(landscapeConstraints)

        if UIDevice.current.orientation == .portrait {
            // Setup portrait mode constraints
            portraitConstraints = [
                postDetailsLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                postDetailsLabel.bottomAnchor.constraint(equalTo: mainStackView.layoutMarginsGuide.topAnchor, constant: -5),
                postDetailsLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 10),
                postDetailsLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -10),
                postDetailsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                postDetailsLabel.heightAnchor.constraint(equalToConstant: 50),

                mainStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -25),
                mainStackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 10),
                mainStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -10),

                postIDStackView.heightAnchor.constraint(equalToConstant: 75),
                userIDStackView.heightAnchor.constraint(equalToConstant: 75),
                titleStackView.heightAnchor.constraint(equalToConstant: 100)
            ]
            NSLayoutConstraint.activate(portraitConstraints)
        } else {
            // Setup landscape mode constraints
            landscapeConstraints = [
                postDetailsLabel.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                postDetailsLabel.bottomAnchor.constraint(equalTo: mainStackView.layoutMarginsGuide.topAnchor, constant: -5),
                postDetailsLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 10),
                postDetailsLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -10),
                postDetailsLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                postDetailsLabel.heightAnchor.constraint(equalToConstant: 50),

                mainStackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: -10),
                mainStackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 10),
                mainStackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: -10),

                postIDStackView.heightAnchor.constraint(equalToConstant: 50),
                userIDStackView.heightAnchor.constraint(equalToConstant: 50)
            ]
            NSLayoutConstraint.activate(landscapeConstraints)
        }
    }

    // MARK: - Private Helpers

    private func setupView() {
        setupAllStackViews()
        setupDetailedPostView()
    }

    private func setupAllStackViews() {
        // Setup main stack view
        setup(stackView: mainStackView, axis: .vertical)

        // Setup all the labels stack view
        let allStacks = [postIDStackView, userIDStackView, titleStackView, bodyStackView]
        for stack in allStacks {
            setup(stackView: stack, axis: .horizontal)
        }
    }

    private func setup(stackView: UIStackView, axis: NSLayoutConstraint.Axis) {
        stackView.axis = axis
        stackView.spacing = axis == .vertical ? 10 : 25
    }

    private func setupDetailedPostView() {
        // Arrange Detailed post view
        self.addSubview(postDetailsLabel)
        self.addSubview(mainStackView)
        mainStackView.addArrangedSubview(postIDStackView)
        mainStackView.addArrangedSubview(userIDStackView)
        mainStackView.addArrangedSubview(titleStackView)
        mainStackView.addArrangedSubview(bodyStackView)

        // Setup required constraints
        updateConstraintsIfNeeded()
    }

    private func createLabel(with text: String? = nil) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        if let text {
            label.text = text
        }
        return label
    }

    private func createStackView(staticText: String? = nil, dynamicText: String? = nil) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false

        if let staticText {
            let staticLabel = createLabel(with: staticText)
            staticLabel.numberOfLines = 0
            staticLabel.translatesAutoresizingMaskIntoConstraints = false
            staticLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
            stackView.addArrangedSubview(staticLabel)
        }

        if let dynamicText {
            let dynamicLabel = createLabel(with: dynamicText)
            dynamicLabel.numberOfLines = 0
            dynamicLabel.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(dynamicLabel)
        }
        return stackView
    }
}
