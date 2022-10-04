//
//  NewsDetailsViewController.swift
//  NewsFeed
//
//  Created by Raja Earla on 23/09/20.
//

import UIKit
import WebKit

class NewsDetailsViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var article : Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = article.title
        
        let newsUrlString = article.url
        assert(newsUrlString != nil , "News url should not be nil")
        webView.load(URLRequest(url: URL(string: newsUrlString!)!))
        
    }

}
