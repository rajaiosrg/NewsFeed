


import Foundation

typealias RAJSON = Any
typealias JSONDictionary = [String: Any]
typealias JSONArray = [RAJSON]

protocol JSONDecodable {
    init?(dictionary: JSONDictionary)
}

func decode<T:JSONDecodable>(data: Data) -> [T]? {
    guard let JSONObject = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
    }
    var objects : [T] = [T]()
    if isDictionary(JSONObject) {
        objects = [T(dictionary: JSONObject as! Dictionary)] as! [T]
    } else if isArray(JSONObject) {
        objects = (JSONObject as! Array).compactMap { T(dictionary: $0) }
    } else {
    }
    return objects
}


func isDictionary(_ object: RAJSON) -> Bool {
    return ((object as? JSONDictionary) != nil) ? true : false
}

func isArray(_ object: RAJSON) -> Bool {
    return ((object as? JSONArray) != nil) ? true : false
}
