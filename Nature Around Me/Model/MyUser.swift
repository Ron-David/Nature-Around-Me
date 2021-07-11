//
//  MyUser.swift
//  Nature Around Me
//
//  Created by Ron David on 27/06/2021.
//

import Foundation

class MyUser{
    let email: String
    let name: String
    let img: String
    let bio:String
    
    init(email:String,name:String,img:String,bio:String){
        self.name = name
        self.email = email
        self.img = img
        self.bio = bio
    }
    
    //Empty user
//    init(email:String = "",name:String = "",img:String = ""){
//        self.name = name
//        self.email = email
//        self.img = img
//        self.bio = ""
//    }
    
    //Creating user from the Firestore
     init(json:[String:Any]){
        self.email = json["email"] as! String
        self.name = json["name"] as! String
        self.img = json["img"] as! String
        self.bio = json["bio"] as! String

    }
    
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["email"] = email
        json["name"] = name
        json["img"] = img
        json["bio"] = bio
        
        return json
    }
    
}
