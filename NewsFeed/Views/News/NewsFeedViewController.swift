

import UIKit

class NewsFeedViewController: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
    var viewModel : NewsFeedViewModel!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "News"
        viewModel = NewsFeedViewModel()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        newsTableView.separatorStyle = .none
        viewModel.fetchNews() {[weak self] reload in
            self?.activityIndicatorView.stopAnimating()
            if (reload) {
                self?.newsTableView.separatorStyle = .singleLine
                self?.newsTableView.reloadData()
            }
        }
    }
}

extension NewsFeedViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsDetailsViewController = MainStoryboard.instantiateViewController(withIdentifier: StoryBoardIdentifier.NewsDetailsViewController.rawValue) as! NewsDetailsViewController
        newsDetailsViewController.article = viewModel.articleAtIndexPath(indexPath)
        navigationController?.pushViewController(newsDetailsViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewsFeedViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsFeedTableViewCell", for: indexPath) as! NewsFeedTableViewCell
        cell.configureCellWith(viewModel.articleAtIndexPath(indexPath))
        return cell
    }
}
