//
//  PostsAPIService.swift
//  Assignment
//
//  Created by Sanket Sonje  on 25/05/24.
//

import Foundation

/// Provides various APIs to do operation on `Post`.
class PostsAPIService {

    // MARK: - Properties

    private let urlSession: URLSession
    private var fetchRequestCount: Int = 1
    private static let pageSize = 10
    var isPaginating: Bool = false

    // MARK: - Init

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    // MARK: - API's

    func getPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        isPaginating = true

        let postsURLString = "https://jsonplaceholder.typicode.com/posts?_page=\(fetchRequestCount)&_limit=\(Self.pageSize)"
        guard let postsURL = URL(string: postsURLString) else {
            InAppLogger.sharedInstance.info("[PostsAPIService] Found `postsURL` nil")
            return
        }

        // Create URL Session to fetch data
        let dataTask = urlSession.dataTask(with: postsURL) { (data, response, error) in
            if let error {
                InAppLogger.sharedInstance.info("[PostsAPIService] Unfortunately, get request failed with error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard response is HTTPURLResponse else {
                InAppLogger.sharedInstance.info("[PostsAPIService] Get nil response from the server. Hence, Unable to parse the response as HTTPURLResponse")
                return
            }

            guard let data else {
                InAppLogger.sharedInstance.info("[PostsAPIService] Get nil data from the server.")
                return
            }

            do {
                // Parse the data
                let jsonDecoder = JSONDecoder()
                let jsonData = try jsonDecoder.decode([Post].self, from: data)

                DispatchQueue.main.async {
                    // Update the `fetchRequestCount` and `isPaginating` variables and send the data
                    self.fetchRequestCount += 1
                    self.isPaginating = false
                    completion(.success(jsonData))
                    InAppLogger.sharedInstance.info("[PostsAPIService] Data fetched successfully.")
                }
            } catch {
                InAppLogger.sharedInstance.info("[PostsAPIService] Failed to decode the data.")
                completion(.failure(error))
                return
            }
        }

        dataTask.resume()
    }
}
