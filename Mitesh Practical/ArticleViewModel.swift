//
//  ArticleViewModel.swift
//  Mitesh Practical
//
//  Created by MiTESH on 17/07/20.
//  Copyright © 2020 Mrs Product. All rights reserved.
//

import UIKit
import CoreData

//MARK: ArticleView
//Structure of architecture to show in article list
struct ArticleView {
    let avtar: String
    let userName: String
    let userDesignation: String
    let media: String
    let content: String
    let articleTitle: String
    let articleLink: String
    let likeCount: String
    let commentCount: String
    let createdAt: String
    let userID: String
    let articleID: String
    
    init(with article: Article) {
        self.avtar = article.articleToUser?.avatar ?? ""
        self.userName = article.articleToUser?.name ?? ""
        self.userDesignation = article.articleToUser?.designation ?? ""
        self.media = article.articleToMedia?.image ?? ""
        self.content = article.content ?? ""
        self.articleTitle = article.articleToMedia?.title ?? ""
        self.articleID = article.id ?? ""
        self.userID = article.articleToUser?.id ?? ""
        self.articleLink = article.articleToMedia?.url ?? ""
        self.likeCount = article.likes.suffixNumber() + " " + "Likes"
        self.commentCount = article.comments.suffixNumber() + " "  + "Comments"
        self.createdAt = article.createdAt?.getElapsedInterval() ?? ""
    }
}

//MARK: Article View Model
class ArticleViewModel {
    var managObjectContext: NSManagedObjectContext?
    
    init() {
        managObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? nil
        
        do {
            
            //Creat Local directory for save files
            try FileManager.default.createDirectory(atPath: documentsDirectory.appendingPathComponent("Profile").path, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(atPath: documentsDirectory.appendingPathComponent("Article").path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print(error.localizedDescription);
        }
    }
    
    var articles = [ArticleView]()
}

//MARK: API
extension ArticleViewModel {
    //MARK: Get Article List
    func fetchArticles(completion: @escaping () -> Void) {

        var request = URLRequest(url: URL(string: "https://5e99a9b1bc561b0016af3540.mockapi.io/jet2/api/v1/blogs?page=1&limit=10")!)
        request.httpMethod = "GET"

        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            print(response!)
            do {
                if let jsonArr = try JSONSerialization.jsonObject(with: data!) as? [[String: Any]]{
                    if jsonArr.count > 0{
                        for artcleData in jsonArr {
                            if self.getArticleData(from : artcleData) != nil{
                                debugPrint("save article")
                            }else{
                                debugPrint("Save Fail")
                            }
                        }
                        //Save created article objects
                        self.saveContext()
                    }
                }
                
            } catch {
                print("error")
            }
            let sort = NSSortDescriptor(key: "createdAt", ascending: false)
            let articleData = self.fetchData(ofEntity: "Article", withPredicates: nil, inSortOrder: [sort], limitBy: 0) as? [Article] ?? [Article]()
            self.articles.removeAll()
            for article in articleData{
                self.articles.append(ArticleView(with: article))
            }
            completion()
        })

        task.resume()
    }
    
}

//MARK: Coredata Helper
extension ArticleViewModel{
    //Artile Object
    func getArticleData(from articleDic: [String:Any]) -> Article? {
        if let articleID = articleDic["id"] as? String{
            let predicate: NSPredicate = NSPredicate(format: "id = %d", articleID )
            let article : Article?
            if let exitingArticle = self.fetchData(ofEntity: "Article", withPredicates: predicate, inSortOrder: [], limitBy: 1) as? [Article], exitingArticle.count > 0{
                article = exitingArticle.first
            }else{
                article = getEntityOfName("Article") as? Article
            }
            
            article?.id = articleID
            if let cretedAt = articleDic["createdAt"] as? String{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date = dateFormatter.date(from:cretedAt)
                article?.createdAt = date
            }
            article?.content = articleDic["content"] as? String
            article?.comments = articleDic["comments"] as? Int64 ?? 0
            article?.likes = articleDic["likes"] as? Int64 ?? 0
            
            if let mediaArr = articleDic["media"] as? [[String : String]], mediaArr.count > 0, let mediaDic = mediaArr.first {
                article?.articleToMedia = getMediaData(from: mediaDic)
            }
            
            if let userArr = articleDic["user"] as? [[String : String]], userArr.count > 0, let userDic = userArr.first {
                article?.articleToUser = getUserData(from: userDic)
            }
            return article
        }else{
            return nil
        }
        
    }
    
    //Media Object
    func getMediaData(from mediaDic: [String:Any]) -> Media? {
        if let mediaID = mediaDic["blogId"] as? String{
            let predicate: NSPredicate = NSPredicate(format: "blogId = %d", mediaID )
            let media : Media?
            if let exitingMedia = self.fetchData(ofEntity: "Media", withPredicates: predicate, inSortOrder: [], limitBy: 1) as? [Media], exitingMedia.count > 0{
                media = exitingMedia.first
            }else{
                media = getEntityOfName("Media") as? Media
            }
            
            media?.id = mediaID
            if let cretedAt = mediaDic["createdAt"] as? String{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date = dateFormatter.date(from:cretedAt)
                media?.createdAt = date
            }
            media?.blogId = mediaDic["blogId"] as? String
            media?.image = mediaDic["image"] as? String
            media?.title = mediaDic["title"] as? String
            media?.url = mediaDic["url"] as? String
            return media
        }else{
            return nil
        }
    }
    
    //User Object
    func getUserData(from userDic: [String:Any]) -> User? {
        if let userID = userDic["id"] as? String{
            let predicate: NSPredicate = NSPredicate(format: "id = %d", userID )
            let user : User?
            if let exitingUser = self.fetchData(ofEntity: "User", withPredicates: predicate, inSortOrder: [], limitBy: 1) as? [User], exitingUser.count > 0{
                user = exitingUser.first
            }else{
                user = getEntityOfName("User") as? User
            }
            
            user?.id = userID
            if let cretedAt = userDic["createdAt"] as? String{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let date = dateFormatter.date(from:cretedAt)
                user?.createdAt = date
            }
            user?.blogId = userDic["blogId"] as? String
            user?.avatar = userDic["avatar"] as? String
            user?.name = userDic["name"] as? String
            user?.lastname = userDic["lastname"] as? String
            user?.designation = userDic["designation"] as? String
            user?.city = userDic["city"] as? String
            user?.about = userDic["about"] as? String
            return user
        }else{
            return nil
        }
    }
    
    
}

//MARK: CoreData Operations
extension ArticleViewModel{

    //Save opertion
    func saveContext() {
        //Before save new data delete old articles
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Article")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do
        {
            try self.managObjectContext?.execute(deleteRequest)
            try self.managObjectContext?.save()
        }
        catch
        {
            print ("There was an error")
        }
        
        //Perform operation in main thread
        DispatchQueue.main.async(execute: {
            
            do {
                try self.managObjectContext?.save()
            } catch let mocSaveError as NSError {
                debugPrint("Master Managed Object Context error: \(mocSaveError.localizedDescription)")
            }
        })
    }
    
    //Create NSManagedObject
    func getEntityOfName(_ entityName: String?) -> NSManagedObject? {
        let newObject: NSManagedObject? = NSEntityDescription.insertNewObject(forEntityName: entityName ?? "", into: managObjectContext!)
        return newObject
    }
    
    //Fetch data from entity
    func fetchData(ofEntity entityName: String, withPredicates predicates: NSPredicate?, inSortOrder sortDescriptor: [NSSortDescriptor], limitBy limit: Int) -> [Any] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        if predicates != nil {
            fetchRequest.predicate = predicates
        }
        
        if sortDescriptor.count > 0 {
            fetchRequest.sortDescriptors = sortDescriptor
        }
        
        if limit > 0 {
            fetchRequest.fetchLimit = limit
        }
        
        var objArray: [Any]
        do {
            objArray = try managObjectContext!.fetch(fetchRequest)
            return objArray
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return []
    }
}
