

import Foundation

typealias onSuccessOfNewsResponse = ((_ reloadData : Bool) -> Void)


class NewsFeedViewModel {
    
   private var newsResponse : NewsFeedResponse?
    
    var rowCount : Int {
        return newsResponse?.articles?.count ?? 0
    }
    
    func fetchNews(_ callback : @escaping onSuccessOfNewsResponse)  {
        NewsFeedRequester().newsFeed(for: .NewsFeed) {[weak self] (result, httpResponse) in
            switch result {
            case .success(let response):
                self?.newsResponse = response
                callback(true)
                break
            case .failure(_):
                callback(true)
                break
            }
        }
    }
    
    func articleAtIndexPath(_ indexPath: IndexPath) -> Article {
        return ((newsResponse?.articles![indexPath.row])!)
    }
    
}
