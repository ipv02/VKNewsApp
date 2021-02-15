

import Foundation

protocol DataFetcherProtocol {
    func getFeed(response: @escaping (FeedResponse?) -> Void)
}


struct NetworkDataFetcher: DataFetcherProtocol {
    
    let networking: NetworkingProtocol
    
    init(networking: NetworkingProtocol) {
        self.networking = networking
    }
    
    func getFeed(response: @escaping (FeedResponse?) -> Void) {
        let params = ["filters": "post, photo"]
        networking.request(path: API.newsFeed, params: params) { (data, error) in
            if let error = error { print(error); response(nil) }
            
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
    
}
