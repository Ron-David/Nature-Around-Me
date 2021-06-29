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
    
    init(email:String,name:String,img:String){
        self.name = name
        self.email = email
        self.img = img
        
    }


    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["email"] = email
        json["name"] = name
        json["img"] = img
        
        return json
    }
    
}
