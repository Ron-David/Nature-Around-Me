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
    
    func getAllPosts(callback:@escaping ([Post])->Void){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = Post.fetchRequest() as NSFetchRequest<Post>
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        DispatchQueue.global().async {
            //second thread code
            var data = [Post]()
            do{
                data = try context.fetch(request)
            }catch{
            }
            
            DispatchQueue.main.async {
                // main thread
                callback(data)
            }
        }
    }
    
    
    func add(post:Post){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try context.save()
        }catch{
            
        }
    }
    
    func delete(post:Post){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(post)
        do{
            try context.save()
        }catch{
            
        }
    }
    
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
