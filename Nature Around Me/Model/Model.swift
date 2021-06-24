//
//  Model.swift
//  Nature Around Me
//
//  Created by Ron David on 18/06/2021.
//

import Foundation
import UIKit
import CoreData

class NotificationGeneral{
    
    let name:String
    
    init(_ name: String){
        self.name = name
    }
    
    func post(){
        NotificationCenter.default.post(name: NSNotification.Name(name), object: self)
    }

    func observe(callback:@escaping ()->Void){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(name), object: self, queue: nil) { (notification) in
            callback()
        }
    }
}

class Model{
    static let instance = Model()
    public let notificationPostsList = NotificationGeneral("notificationPostsList")
    private init(){}
    
    let modelFirebase = ModelFirebase()

    func getAllPosts(callback:@escaping ([Post])->Void){
        
        // Getting the last update value
        let lastUpdateDate = Post.getLastUpdate()
        
        // Getting lastUpdate value from firebase
        modelFirebase.getAllPosts(since: lastUpdateDate ){ (posts) in
            var lastUpdate:Int64 = 0
            for post in posts{
                if(!post.isActive){
                    self.removeFromCoreData(post){}
                }
                if (lastUpdate < post.lastUpdated){
                    lastUpdate = post.lastUpdated
                }
                
            }
            //Updating CoreData last update
            Post.saveLastUpdate(time: lastUpdate)
            
            //Saving the context
            if posts.count > 0 {posts[0].save()}
            
            //Reading all posts list from CoreData
            Post.getAll(callback: callback)
        }
    }
    
    
    func add(post:Post,callback:@escaping ()->Void){
        modelFirebase.add(post: post){
            callback()
            self.notificationPostsList.post()
        }
    }
    
    func delete(post:Post,callback:@escaping ()->Void){
        modelFirebase.delete(post: post){
            self.removeFromCoreData(post){}
//            callback()
            self.notificationPostsList.post()
        }
    }
    
    func removeFromCoreData(_ post:Post,callback:@escaping ()->Void){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(post)
    }
    
//    func add(post:Post){
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        do{
//            try context.save()
//        }catch{
//
//        }
//    }
    
//    func delete(post:Post){
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        context.delete(post)
//        do{
//            try context.save()
//        }catch{
//
//        }
//    }
    
    func getPost(byId:String)->Post?{
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let request = Post.fetchRequest() as NSFetchRequest<Post>
        request.predicate = NSPredicate(format: "id == \(byId)")
        do{
            let posts = try context.fetch(request)
            if posts.count > 0 {
                return posts[0]
            }
        }catch{
            
        }
        return nil
    }
    
    //Creating user
    func createUser(email:String ,password: String){
        modelFirebase.createUser(email: email, password: password)
    }


}
