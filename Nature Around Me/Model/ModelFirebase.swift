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
            .start(at: [Timestamp(seconds: since, nanoseconds: 0)])
//            .whereField("isActive", isEqualTo: true)
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
                            print("--- \(post.isActive)")

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
//    func getPost(byId:String)->Post?{
//
//        return nil
//    }
    
    
    /*TODO*/
    func addUser(_ email:String,_ name:String, _ img:String){
        let db = Firestore.firestore()
        let user = MyUser(email:email,name:name,img:img)

        db.collection("users").document(user.email).setData(user.toJson()){
            err in
            if let err = err {
                print("Error writing user: \(err)")
            }else{
                print("User successfully written!")
            }
        }
    }
    
    //Creating user with Firestore authentication
    func createUser(email:String ,password: String,name:String,img:String){
        let id = generateRandomId(length: 10)
        print(id)
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error{
                print("Error in registration: \(error)")

            }else{
                print("Registration succeeded!")
                self.addUser(email,name,img)
            }
        }
    }
    func generateRandomId(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func isLoggedIn()->Bool{
    
        if(Auth.auth().currentUser == nil){
            return false
        }

        return true
    }
    
    func logOut(){
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
      
    }
    
    func logIn(email:String,password:String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
          // ...
        }
    }
    
}
