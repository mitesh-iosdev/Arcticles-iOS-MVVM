//
//  Article+CoreDataProperties.swift
//  Mitesh Practical
//
//  Created by MiTESH on 17/07/20.
//  Copyright © 2020 Mrs Product. All rights reserved.
//
//

import Foundation
import CoreData


extension Article {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Article> {
        return NSFetchRequest<Article>(entityName: "Article")
    }

    @NSManaged public var comments: Int64
    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: String?
    @NSManaged public var likes: Int64
    @NSManaged public var articleToMedia: Media?
    @NSManaged public var articleToUser: User?

}
