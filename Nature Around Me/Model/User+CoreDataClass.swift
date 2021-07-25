//
//  User+CoreDataClass.swift
//  
//
//  Created by Ron David on 27/06/2021.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["id"] = id!
        json["email"] = email!
        json["name"] = name!
        if let img = img {
            json["img"] = img
        }else{
            json["img"] = ""
        }
        return json
    }
}
