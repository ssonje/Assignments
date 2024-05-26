//
//  PostViewModel.swift
//  Assignment
//
//  Created by Sanket Sonje  on 25/05/24.
//

import Foundation

/// A view model to fetch the data from the server and do the processing.
class PostViewModel {

    // MARK: - Private Properties

    private var postsAPIService: PostsAPIService
    private var posts = [Post]()

    // MARK: - Public Properties

    var shouldShowFooterView: Bool = false

    // MARK: - Init

    init(urlSession: URLSession) {
        self.postsAPIService = PostsAPIService(urlSession: urlSession)
    }

    // MARK: - Network API's

    func getPosts(completion: @escaping () -> ()) {
        guard !postsAPIService.isPaginating else {
            shouldShowFooterView = true
            return
        }

        shouldShowFooterView = false
        postsAPIService.getPosts(completion: { (result) in
            switch result {
            case .success(let posts):
                self.shouldShowFooterView = false
                self.posts.append(contentsOf: posts)
                completion()
                break
            case .failure(let error):
                InAppLogger.sharedInstance.info("[PostViewModel] While processing the json data, got an error: \(error.localizedDescription)")
            }
        })
    }

    // MARK: - Table View API's

    func numberOfRowsInSection(section: Int) -> Int {
        if posts.count != 0 {
            return posts.count
        }

        return 0
    }

    func cellForRow(at indexPath: IndexPath) -> Post {
        return posts[indexPath.row]
    }
}
