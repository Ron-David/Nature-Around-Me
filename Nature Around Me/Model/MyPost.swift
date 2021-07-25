//
//  MyPost.swift
//  Nature Around Me
//
//  Created by Ron David on 14/07/2021.
//

import Foundation

class MyPost{
    
    public var id: String?
    public var imageUrl1: String?
    public var isActive: Bool
    public var lastUpdated: Int64
    public var location: String?
    public var title: String?
    public var imageUrl2: String?
    public var imageUrl3: String?
    public var freeText: String?
    
    
    
    //Creating post from the Firestore
    init(json:[String:Any]){
        
        id = json["id"] as? String
        title = json["title"] as? String
        location = json["location"] as? String
        imageUrl1 = json["imageUrl1"] as? String
        imageUrl2 = json["imageUrl2"] as? String
        imageUrl3 = json["imageUrl3"] as? String
        freeText = json["freeText"] as? String
        isActive = json["isActive"] as! Bool
        
        lastUpdated = 0
    }
    
    
}
