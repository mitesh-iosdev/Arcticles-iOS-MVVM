//
//  ArticleTableViewCell.swift
//  Mitesh Practical
//
//  Created by MiTESH on 17/07/20.
//  Copyright © 2020 Mrs Product. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userTitleLable: UILabel!
    @IBOutlet weak var userDesignationLable: UILabel!
    @IBOutlet weak var articleDateLable: UILabel!
    
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var articleContentLable: UILabel!
    @IBOutlet weak var articleTitleLable: UILabel!
    
    @IBOutlet weak var likeCountLable: UILabel!
    @IBOutlet weak var commentCountLable: UILabel!
    
    @IBOutlet weak var articleLinkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Make avtar round style. Avtar height and width fix so used 20
        self.userImageView.setBorder(ofWidth: 1, withColor: .gray, ofRadius: 20.0)
        
        ////Set rounded corner  to article image
        self.mediaImageView.setBorder(ofWidth: 1, withColor: .gray, ofRadius: 3)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setAvatarImage(for urlStr: String, to path: String) {
        //If valid URL download the image
        if let url = URL(string: urlStr){
            let filePath = documentsDirectory.appendingPathComponent("Profile/\(path)").appendingPathExtension(url.pathExtension).path
            self.userImageView.downloadImageFrom(link: url, saveAt: filePath)
        }
    }
    
    func setArticleImage(for urlStr: String, to path: String) {
        if let url = URL(string: urlStr){
            //Make visible if valid URL
            self.mediaImageView.isHidden = false
            
            let filePath = documentsDirectory.appendingPathComponent("Article/\(path)").appendingPathExtension(url.pathExtension).path
            self.mediaImageView.downloadImageFrom(link: url, saveAt: filePath)
            
        }else{
            //Hide article no url or invaid URL
            self.mediaImageView.isHidden = true
        }
    }
    
    @IBAction func articleLinkTapped(_ sender: UIButton) {
        //Get url from button title and open in browser if valid
        if let url = URL(string: sender.titleLabel?.text ?? ""), UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: { (success) in

            })
        }
    }
    
}
