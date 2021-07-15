//
//  ImgPicker.swift
//  Nature Around Me
//
//  Created by Ron David on 10/07/2021.
//

import Foundation
import UIKit

struct ImgPicker {

    static func pickImg(on vc: UIViewController){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = vc as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.allowsEditing = true

        let a = UIAlertAction(title: "Camera", style: .default, handler: {_ in
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                vc.present(imagePicker, animated: true, completion: nil)}})
        
        let b = UIAlertAction(title: "Photo Album", style: .default, handler: {_ in
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            vc.present(imagePicker, animated: true, completion: nil)})

        let c = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        Alert.threeOptionAlert(on: vc, with: "Image Selection", message: "From where you want to pick this image?",optionA:a ,optionB:b ,optionC:c)
        
    }
    
    
    
    
}
