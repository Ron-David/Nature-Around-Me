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
    func addUser(_ email:String,_ name:String, _ img:String,_ bio:String = "",callback:@escaping (Bool)->Void){
        let db = Firestore.firestore()
        let user = MyUser(email:email,name:name,img:img,bio:bio)
        
        db.collection("users").document(user.email).setData(user.toJson()){
            err in
            if let err = err {
                print("Error writing user: \(err)")
                callback(false)
            }else{
                print("User successfully written!")
                callback(true)
            }
        }
    }
    
    //Creating user with Firestore authentication
    func createUser(email:String ,password: String,name:String,img:String,bio:String = "",callback:@escaping (Bool)->Void){
        let id = generateRandomId(length: 10)
        print(id)
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error{
                print("Error in registration: \(error)")
                callback(false)
                return

            }else{
                print("Registration succeeded!")
                self.addUser(email,name,img,bio){_ in}
                callback(true)
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
    
    //Assuming the user is exist!
    func currentUser(callback:@escaping (MyUser)->Void){
        let db = Firestore.firestore()
//        let user = MyUser(email:Auth.auth().currentUser.email!, name:Auth.auth().currentUser.name,img:Auth.auth().currentUser.)
        let docRef = db.collection("users").document((Auth.auth().currentUser?.email!)!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let user = MyUser(json: document.data()!)
                callback(user)
            } else {
                print("Document does not exist")
            }
        }
    
    }
    
    func logOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    func logIn(email:String,password:String,callback:@escaping (Bool)->Void){
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                  guard let strongSelf = self else { return }
        // ...
                    callback(true)
                }
    }
    
    func saveImage(image:UIImage, callback:@escaping (String)->Void){
        let storageRef = Storage.storage()
            .reference(forURL:"gs://nature-around-me.appspot.com/avatars")
        let data = image.jpegData(compressionQuality: 0.8)
        let imageRef = storageRef.child("imageName")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    callback("")
                    return
                }
                print("url: \(downloadURL)")
                callback(downloadURL.absoluteString)
            }
        }
    }
    
    func changeEmail(email:String,callback:@escaping (Bool)->Void){
        Auth.auth().currentUser?.updateEmail(to: email, completion: {bool in
            callback(bool != nil)
        })
    }
    func changePassword(password:String,callback:@escaping (Bool)->Void){
        Auth.auth().currentUser?.updatePassword(to: password, completion: { bool in
                callback(bool != nil)
        })
    }
}




