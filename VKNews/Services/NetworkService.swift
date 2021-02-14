

import Foundation

class NetworkService {
    
    func getFeed() {
        
        let params = ["filters": "post, photo"]
        let allParams = params
        allParams["access_token"]
        
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = API.newsFeed
        components.queryItems
        
        components.url
    }
}

