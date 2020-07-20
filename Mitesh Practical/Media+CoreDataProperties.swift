//
//  Media+CoreDataProperties.swift
//  Mitesh Practical
//
//  Created by MiTESH on 17/07/20.
//  Copyright © 2020 Mrs Product. All rights reserved.
//
//

import Foundation
import CoreData


extension Media {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Media> {
        return NSFetchRequest<Media>(entityName: "Media")
    }

    @NSManaged public var blogId: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?

}
