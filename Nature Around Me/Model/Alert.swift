//
//  Alert.swift
//  Nature Around Me
//
//  Created by Ron David on 29/06/2021.
//

import Foundation
import UIKit

struct Alert {
    static func alertGeneral(on vc: UIViewController,with title: String,message: String){
        let alert = UIAlertController(title:title,message:message,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func threeOptionAlert(on vc: UIViewController, with title:String, message:String, optionA:UIAlertAction, optionB:UIAlertAction, optionC:UIAlertAction){
        let alert = UIAlertController(title:title,message: message,preferredStyle: .alert)
        alert.addAction(optionA)
        alert.addAction(optionB)
        alert.addAction(optionC)
        vc.present(alert, animated: true, completion:nil)
    }
    
    static func twoOptionAlert(on vc: UIViewController, with title:String, message:String, optionA:UIAlertAction, optionB:UIAlertAction){
        let alert = UIAlertController(title:title,message: message,preferredStyle: .alert)
        alert.addAction(optionA)
        alert.addAction(optionB)
        vc.present(alert, animated: true, completion:nil)
    }
}
