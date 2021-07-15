//
//  Post+CoreDataProperties.swift
//  
//
//  Created by Ron David on 15/07/2021.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: String?
    @NSManaged public var imageUrl1: String?
    @NSManaged public var isActive: Bool
    @NSManaged public var lastUpdated: Int64
    @NSManaged public var location: String?
    @NSManaged public var title: String?
    @NSManaged public var imageUrl2: String?
    @NSManaged public var imageUrl3: String?
    @NSManaged public var freeText: String?
    @NSManaged public var userEmail: String?

}
