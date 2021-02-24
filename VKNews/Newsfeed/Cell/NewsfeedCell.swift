
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
    var photoAttachment: FeedCellPhotoAttachmentViewModelProtocol? { get }
    var size: FeddCellSizeProtocol { get }
}

protocol FeedCellPhotoAttachmentViewModelProtocol {
    var photoUrlString: String? { get }
    var width: Int { get }
    var height: Int { get }
}

protocol FeddCellSizeProtocol {
    var postLableFrame: CGRect { get }
    var attachmentFrame: CGRect { get }
    var bottomViewFrame: CGRect { get }
    var totalHeight: CGFloat { get }
}

class NewsfeedCell: UITableViewCell {
    
    static let reusedId = "NewsfeedCell"
    
    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postImageView: WebImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var sharedLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    override func prepareForReuse() {
        iconImageView.set(imageURL: nil)
        postImageView.set(imageURL: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.clipsToBounds = true
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        backgroundColor = .clear
        selectionStyle = .none
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
        
        postLabel.frame = viewModel.size.postLableFrame
        postImageView.frame = viewModel.size.attachmentFrame
        bottomView.frame = viewModel.size.bottomViewFrame
        
        if let photoAttachment = viewModel.photoAttachment {
            postImageView.set(imageURL: photoAttachment.photoUrlString ?? "")
            postImageView.isHidden = false
        } else {
            postImageView.isHidden = true
        }
    }
}

