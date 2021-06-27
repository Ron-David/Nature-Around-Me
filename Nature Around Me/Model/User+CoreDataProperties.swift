//
//  User+CoreDataProperties.swift
//  
//
//  Created by Ron David on 27/06/2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var lastUpdated: Int64
    @NSManaged public var posts: NSObject?
    @NSManaged public var img: String?

}
