//
//  ViewController.swift
//  Mitesh Practical
//
//  Created by MiTESH on 17/07/20.
//  Copyright © 2020 Mrs Product. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let articleViewModel = ArticleViewModel()
    
    @IBOutlet weak var fetchIndicator: UIActivityIndicatorView!
    @IBOutlet weak var articleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchIndicator.startAnimating()
        
        articleViewModel.fetchArticles {
            DispatchQueue.main.async {
                self.fetchIndicator.stopAnimating()
                //By default set table view hidded from story board so make visible and reload table
                self.articleTableView.isHidden = false
                self.articleTableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    }


}

//MARK: Table View Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articleViewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell") as! ArticleTableViewCell
        let article = articleViewModel.articles[indexPath.row]
        cell.userTitleLable.text = article.userName
        cell.userDesignationLable.text = article.userDesignation
        cell.articleContentLable.text = article.content
        cell.articleTitleLable.text = article.articleTitle
        cell.likeCountLable.text = article.likeCount
        cell.commentCountLable.text = article.commentCount
        cell.articleDateLable.text = article.createdAt
        cell.setAvatarImage(for: article.avtar, to: article.userID)
        cell.setArticleImage(for: article.media, to: article.articleID)
        cell.articleLinkButton.setTitle(article.articleLink, for: .normal)
        return cell
    }
    
    
}
