
import UIKit

enum Newsfeed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewsfeed
        case revealPostIds(postId: Int)
      }
    }
    struct Response {
      enum ResponseType {
        case presentNewsfeed(feed: FeedResponse, revealdePostIds: [Int])
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayNewsfeed(feedViewModel: FeedViewModel)
      }
    }
  }
}

struct FeedViewModel {
    struct Cell: FeedCellViewModelProtocol {
        var postId: Int
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var like: String?
        var comment: String?
        var shared: String
        var view: String
        var photoAttachments: [FeedCellPhotoAttachmentViewModelProtocol]
        var size: FeddCellSizeProtocol
    }
    
    struct FeedCellPhotoAttachment: FeedCellPhotoAttachmentViewModelProtocol {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
    
    let cells: [Cell]
}
