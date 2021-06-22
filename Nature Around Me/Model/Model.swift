//
//  Model.swift
//  Nature Around Me
//
//  Created by Ron David on 18/06/2021.
//

import Foundation
import UIKit
import CoreData

class Model{
    static let instance = Model()
    
    private init(){}
    
    let modelFirebase = ModelFirebase()

    func getAllPosts(callback:@escaping ([Post])->Void){
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let request = Post.fetchRequest() as NSFetchRequest<Post>
//        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
//
//        DispatchQueue.global().async {
//            //second thread code
//            var data = [Post]()
//            do{
//                data = try context.fetch(request)
//            }catch{
//            }
//
//            DispatchQueue.main.async {
//                // main thread
//                callback(data)
//            }
//        }
        
        // Getting the last update value
        let lastUpdateDate = Post.getLastUpdate()
        
        // Getting lastUpdate value from firebase
        modelFirebase.getAllPosts(since: lastUpdateDate ){ (posts) in
            var lastUpdate:Int64 = 0
            for post in posts{

                if (lastUpdate < post.lastUpdated){
                    lastUpdate = post.lastUpdated
                }
                
            }
            //Updating CoreData last update
            Post.saveLastUpdate(time: lastUpdate)
            
            //Saving the context
            if posts.count > 0 {posts[0].save()}
            
            //Reaing all posts list from CoreData
            Post.getAll(callback: callback)
        }
    }
    
    
    func add(post:Post,callback:@escaping ()->Void){
        modelFirebase.add(post: post, callback: callback)
    }
    
    func delete(post:Post,callback:@escaping ()->Void){
        modelFirebase.delete(post: post ,callback: callback)
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

}
