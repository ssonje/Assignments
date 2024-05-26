//
//  PostTableViewCell.swift
//  Assignment
//
//  Created by Sanket Sonje  on 25/05/24.
//

import Foundation
import UIKit

/// Provides configuration api's to the table view cell
class PostTableViewCell: UITableViewCell {

    // MARK: - UI Properties

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var title: UILabel!

    // MARK: - Table View Cell API's

    func configure(for post: Post) {
        updateUI(id: post.id, title: post.title)
    }

    // MARK: - Private Properties

    private func updateUI(id: Int?, title: String?) {
        guard let id, let title else {
            InAppLogger.sharedInstance.info("[PostTableViewCell] ID or Title found nil.")
            return
        }

        self.id.text = String(id)
        self.title.text = title
    }
}
