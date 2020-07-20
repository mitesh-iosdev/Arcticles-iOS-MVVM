//
//  User+CoreDataProperties.swift
//  Mitesh Practical
//
//  Created by MiTESH on 17/07/20.
//  Copyright © 2020 Mrs Product. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var about: String?
    @NSManaged public var avatar: String?
    @NSManaged public var blogId: String?
    @NSManaged public var city: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var designation: String?
    @NSManaged public var id: String?
    @NSManaged public var lastname: String?
    @NSManaged public var name: String?

}
