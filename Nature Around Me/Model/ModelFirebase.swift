//
//  ModelFirebase.swift
//  Nature Around Me
//
//  Created by Ron David on 22/06/2021.
//

import Foundation
import Firebase

class ModelFirebase {
    init() {
        FirebaseApp.configure()
    }
    

    func getAllPosts(since: Int64, callback:@escaping ([Post])->Void){
        let db = Firestore.firestore()
        db.collection("posts")
            .order(by: "lastUpdated")
            .start(at: [Timestamp(seconds: since, nanoseconds: 0)]).whereField("isActive", isEqualTo: true)
            .getDocuments { (snapshot, err) in
            var posts = [Post]()
            if let err = err{
                print("Error reading document: \(err)")
            }else{
                if let snapshot = snapshot{
                    for snap in snapshot.documents{
                        print("? \(snap.data())")

                        if let post = Post.create(json:snap.data()){
                                posts.append(post)

                        }
                    }
                }
            }
            callback(posts)
        }
    }

    func add(post:Post,callback:@escaping ()->Void){
        let db = Firestore.firestore()
        db.collection("posts").document(post.id!).setData(post.toJson()){
            err in
            if let err = err {
                print("Error writing document: \(err)")
            }else{
                print("Document successfully written!")
            }
            callback()
        }
    }

    func delete(post:Post,callback:@escaping ()->Void){
//        let db = Firestore.firestore()
//
//        db.collection("posts").document(post.id!).delete() { err in
//            if let err = err {
//                print("Error removing document: \(err)")
//            } else {
//                print("Document successfully removed!")
//            }
//        }

        post.isActive = false
        add(post:post){}
    }
//
//    func getStudent(byId:String)->Student?{
//
//        return nil
//    }
}
