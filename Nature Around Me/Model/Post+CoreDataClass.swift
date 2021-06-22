//
//  Post+CoreDataClass.swift
//  Nature Around Me
//
//  Created by Ron David on 19/06/2021.
//
//

import UIKit
import CoreData
import Firebase

@objc(Post)
public class Post: NSManagedObject {
    
//    static func create(id:String, title:String, location:String)->Post{
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let post = Post(context: context)
//        post.id = id
//        post.title = title
//        post.location = location
//        return post
//    }
    
    static func create(post:Post)->Post{
        return create(id: post.id!, title: post.title!,location: post.location!, imageUrl: post.imageUrl,lastUpdated: post.lastUpdated)
    }
    
    static func create(id:String, title:String,location:String, imageUrl:String?,isActive:Bool = true, lastUpdated:Int64 = 0)->Post{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let post = Post(context: context)
        post.id = id
        post.title = title
        post.location = location
        post.imageUrl = imageUrl
        post.lastUpdated = lastUpdated
        post.isActive = isActive
        return post
    }

    //Creating post from the Firestore
    static func create(json:[String:Any])->Post?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let post = Post(context: context)
        post.id = json["id"] as? String
        post.title = json["title"] as? String
        post.location = json["location"] as? String
        post.imageUrl = json["imageUrl"] as? String
        post.lastUpdated = 0
        if let lup = json["lastUpdated"] as? Timestamp {
            post.lastUpdated = lup.seconds
        }
        return post
    }
    
    
    
    static func saveLastUpdate(time:Int64){
        UserDefaults.standard.set(time, forKey: "lastUpdate")
    }
    static func getLastUpdate()->Int64{
        return Int64(UserDefaults.standard.integer(forKey: "lastUpdate"))
    }

}
