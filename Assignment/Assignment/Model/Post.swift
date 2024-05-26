//
//  Post.swift
//  Assignment
//
//  Created by Sanket Sonje  on 25/05/24.
//

import Foundation

/// Data model for Posts which are fetched from the server
/// - Parameters:
///   - userID: identifier of the user
///   - id: unique identifier for the Post
///   - title: title of the Post
///   - body: description of the Post
struct Post: Decodable {
    let userID: Int?
    let id: Int?
    let title: String?
    let body: String?

    private enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id = "id"
        case title = "title"
        case body = "body"
    }
}
