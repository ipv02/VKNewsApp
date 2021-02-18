
import UIKit

enum Newsfeed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewsfeed
      }
    }
    struct Response {
      enum ResponseType {
        case presentNewsfeed(feed: FeedResponse)
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
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var like: String?
        var comment: String?
        var shared: String
        var view: String
    }
    
    let cells: [Cell]
}
