

import Foundation


enum Method : String {
    case GET = "GET"
    case POST = "POST"
}

protocol APIRequest {
    var method : Method { get }
    var base : String { get }
    var path: String { get }
    var parameters: [String : String] { get }
    
}

extension APIRequest {
    
    var method: Method {
        return .GET
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        
        if parameters.values.count > 0 {
            components.queryItems = parameters.map { URLQueryItem(name: String($0) , value: String($1) )
                
            }
        }
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
    
}
