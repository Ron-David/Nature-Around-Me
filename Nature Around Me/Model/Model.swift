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
    public let notificationPostsList = NotificationGeneral("com.rondavid.nature.notificationPostsList")
    public let notificationTest = NotificationGeneral("com.rondavid.nature.Test1321329")

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
            self.deleteInactivePosts()

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
            self.notificationPostsList.post()
            callback()
        }
    }
    
    func removeFromCoreData(_ post:Post,callback:@escaping ()->Void){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        context.delete(post)
        do{
            try context.save()
        }catch{
            
        }
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
    
    //Deleting the inactive posts from the coredata
    func deleteInactivePosts(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        Post.getAll { posts in
            for post in posts{
                if !post.isActive{
                    context.delete(post)
                }
            }
        }
    }
    
    //Creating user
    func createUser(email:String ,password: String,name:String,img:String="",bio:String = "",callback:@escaping (Bool)->Void){
        modelFirebase.createUser(email: email, password: password,name:name, img: img, bio:bio,callback:callback)
    }
    
    func isLoggedIn()->Bool{
        return modelFirebase.isLoggedIn()
    }
    func logOut(){
        modelFirebase.logOut()
    }

    func logIn(email:String,password:String,callback:@escaping (Bool)->Void){
        modelFirebase.logIn(email: email, password: password,callback:callback)
    }

    func addUser(email:String,name:String,img:String = "",bio:String = "",callback:@escaping (Bool)->Void){
        modelFirebase.addUser(email, name, img, bio, callback:callback)
    }
    func saveImage(image:UIImage, callback:@escaping (String)->Void){
        modelFirebase.saveImage(image: image, callback: callback)
        
    }
    func currentUser(callback:@escaping (MyUser)->Void){
        modelFirebase.currentUser(callback:callback)
    }
    func changeEmail(email:String,callback:@escaping (Bool)->Void){
        modelFirebase.changeEmail(email: email, callback: callback)
    }
    func changePassword(password:String,callback:@escaping (Bool)->Void){
        modelFirebase.changePassword(password:password,callback:callback)
    }


}
