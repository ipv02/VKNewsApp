

import Foundation

protocol NetworkingProtocol {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: NetworkingProtocol {
    
    private let authService: AuthService
    
    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return }
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version
        let url = self.url(from: path, params: allParams)
        let session = URLSession.init(configuration: .default)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
    
    private func url(from path: String, params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        print(components.url!)
        return components.url!
    }
}

