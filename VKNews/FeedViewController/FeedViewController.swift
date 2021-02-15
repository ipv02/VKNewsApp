

import UIKit

class FeedViewController: UIViewController {
    
    private var fetcher: DataFetcherProtocol = NetworkDataFetcher(networking: NetworkService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        
        fetcher.getFeed { (feedResponse) in
            guard let feedRespons = feedResponse else { return }
            feedResponse?.items.map({ (feedItem) in
                print(feedItem.date)
            })
        }
    }
}
