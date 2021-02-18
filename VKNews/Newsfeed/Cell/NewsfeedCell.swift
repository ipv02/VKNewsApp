//
//  NewsfeedCell.swift
//  VKNews
//
//  Created by Elena Igumenova on 17.02.2021.
//

import UIKit

protocol FeedCellViewModelProtocol {
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var like: String? { get }
    var comment: String? { get }
    var shared: String { get }
    var view: String { get }
}

class NewsfeedCell: UITableViewCell {
    

    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    
    
    static let reusedId = "NewsfeedCell"
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(viewModel: FeedCellViewModelProtocol) {
        iconImageView.set(imageURL: viewModel.iconUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likeLabel.text = viewModel.like
        commentLabel.text = viewModel.comment
        sharedLabel.text = viewModel.shared
        viewLabel.text = viewModel.view
    }
}

