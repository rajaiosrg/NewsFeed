

import Foundation


enum APIError : Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .jsonConversionFailure: return "Json Conversion Failure"
        case .invalidData: return "invalid Data"
        case .responseUnsuccessful: return "Response unsuccessful "
        case .jsonParsingFailure : return "Json Parsing Failure "
        }
    }
    
}

protocol APIClient {
    var session : URLSession { get }
    func fetch<T : Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>, HTTPURLResponse?) -> Void)
}

extension APIClient {
    
    var session: URLSession{
        return URLSession(configuration: .default)
    }
    
    var token: String {
        guard let accessToken = UserDefaults.standard.string(forKey: "token") else {
            return ""
        }
        return accessToken
    }
    
    typealias JsonTaskCompletionHandler = (Decodable?, APIError?, HTTPURLResponse?) -> Void
    
    typealias TaskCompletionHandler  = (Data?, APIError?, HTTPURLResponse?) -> Void
    
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JsonTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed, nil)
                return
            }
            if httpResponse.statusCode ==  200 {
                if let data = data{
                    do {
                        self.testParseJson(data: data)
                        let genericModel = try JSONDecoder().decode(decodingType.self, from: data)
                        completion(genericModel, nil, httpResponse)
                    } catch {
                        Log.e(error)
                        completion(nil, .jsonConversionFailure, httpResponse)
                    }
                } else {
                    completion(nil, .invalidData, httpResponse)
                }
            } else {
                if let data = data{
                    do{
                        self.testParseJson(data: data)
                        let genericModel = try JSONDecoder().decode(decodingType.self, from: data)
                        completion(genericModel, nil, httpResponse)
                    } catch {
                        Log.d("$$$$$$$$$ ----- http status code $$$$$$$-------- \(httpResponse.statusCode)")
                        completion(nil, .jsonParsingFailure, httpResponse)
                    }
                } else {
                    completion(nil, .responseUnsuccessful, httpResponse)
                }
            }
        }
        
        return task
    }
    
    func addDefaultHeaders(to request: inout URLRequest) {
        request.addValue("Bearer\(token)", forHTTPHeaderField: "Authorization")
        request.addValue("", forHTTPHeaderField: "AppToken")
        request.addValue(token, forHTTPHeaderField: "token")
    }
    
    
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>, HTTPURLResponse?) -> Void) {
        Log.i("URL :: \(String(describing: request.url))")
        let task = decodingTask(with: request, decodingType: T.self) { (json, error, response) in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(.failure(error), response)
                    } else {
                        completion(.failure(.invalidData), response)
                    }
                    return
                }
                if let value = decode(json){
                    completion(Result.success(value), response)
                } else {
                    completion(Result.failure(.jsonParsingFailure), response)
                }
            }
        }
        task.resume()
        
    }
    
    func fetchJsonData(with request: URLRequest,completionHandler completion: @escaping TaskCompletionHandler)  {
        Log.i("URL :: \(String(describing: request.url))")
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, .requestFailed, nil)
                    return
                }
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        Log.d(data.prettyPrintedJSONString)
                        //                    self.testParseJson(data: data)
                        completion(data, nil, httpResponse)
                    } else {
                        completion(nil, .invalidData, httpResponse)
                    }
                } else {
                    if let dataObj = data {
                        self.testParseJson(data: dataObj)
                    }
                    completion(data, .responseUnsuccessful, httpResponse)
                }
            }
        }
        task.resume()
        
    }
    
    func testParseJson(data: Data)  {
//        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else{ return }
//        Log.d(jsonObject)
        Log.d(data.prettyPrintedJSONString)
    }
    
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        
        return prettyPrintedString
    }
}
