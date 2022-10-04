


import Foundation

enum NewsAPIRequest {
    case NewsFeed
}


extension NewsAPIRequest : APIRequest {
    
    var parameters: [String : String] {
        
        switch self {
        case .NewsFeed:
            return [ "from" : today,
                     "sortBy": "publishedAt",
                     "apiKey" : "bf995cf99451464d97ce42891956dfe8",
                     "q":"bitcoin"]
        }
    }
    
    var today : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter.string(from: Date())
    }
    
    var method: Method {
        switch self {
        case .NewsFeed:
            return .GET
        }
    }
    
    var base: String {
        switch self {
        case .NewsFeed:
             return "http://newsapi.org"
        }
    }
    
    var path: String {
        switch self {
        case .NewsFeed:
            return "/v2/everything"
  
        }
    }
}

// http://newsapi.org/v2/everything?from=2020-08-22&sortBy=publishedAt&apiKey=bf995cf99451464d97ce42891956dfe8

class NewsFeedRequester : APIClient {
     
    let session : URLSession
    
    init(configuration : URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration : .default)
    }
    
    func newsFeed(for request : NewsAPIRequest, completion: @escaping (Result<NewsFeedResponse?, APIError>, HTTPURLResponse?) -> Void) {
        fetch(with: request.request, decode: { json -> NewsFeedResponse? in
            guard let response = json as? NewsFeedResponse else { return  nil }
            return response
        }, completion: completion)
    }
    
}
