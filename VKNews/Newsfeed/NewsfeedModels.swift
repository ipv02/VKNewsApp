
import UIKit

enum Newsfeed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewsfeed
        case getUser
        case revealPostIds(postId: Int)
        case getNextBatch
      }
    }
    struct Response {
      enum ResponseType {
        case presentNewsfeed(feed: FeedResponse, revealdePostIds: [Int])
        case presentUserInfo(user: UserResponse?)
        case presentFooterLoader
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayNewsfeed(feedViewModel: FeedViewModel)
        case displayUser(userViewModel: UserViewModel)
        case displayFooterLoader
      }
    }
  }
}

struct UserViewModel: TitleViewViewModelProtocol {
    var photoUrlString: String?
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
    let footerTitle: String?
}
