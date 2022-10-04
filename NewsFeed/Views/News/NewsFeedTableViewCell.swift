

import UIKit
import SDWebImage

class NewsFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    @IBOutlet weak var auhorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.layer.cornerRadius = 25
        newsImageView.layer.borderColor = UIColor.lightGray.cgColor
        newsImageView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCellWith(_ article : Article) {
        

        
        newsImageView.sd_setImage(with: URL(string: article.urlToImage!), placeholderImage: UIImage(named: "newsImage"))

        newsTitleLabel.text = article.title
        
        descriptionLabel.text = article.articleDescription
        
        publishedLabel.text = article.publishedAt
        
        auhorLabel.text = article.author
    }
    
    
    
    

}



