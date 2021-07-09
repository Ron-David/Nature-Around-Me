//
//  SignUpViewController.swift
//  Nature Around Me
//
//  Created by Ron David on 27/06/2021.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    var image: UIImage?
    
    //Adding avatar from cam/gallery
    @IBAction func addAvatar(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

        let a = UIAlertAction(title: "Camera", style: .default, handler: {_ in
            if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
                imagePicker.sourceType = UIImagePickerController.SourceType.camera;
                self.present(imagePicker, animated: true, completion: nil)}})
        
        let b = UIAlertAction(title: "Photo Album", style: .default, handler: {_ in
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
            self.present(imagePicker, animated: true, completion: nil)})

        let c = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        Alert.imgPickerDialog(on: self, with: "Image Selection", message: "From where you want to pick this image?",optionA:a ,optionB:b ,optionC:c)

    }
    //Catching the img
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.avatar.image = image
        self.dismiss(animated: true, completion: nil)
    }
    
    //Signup
    @IBAction func signUp(_ sender: Any) {
        //Checking empty field and length of password
        if(email.text == "" || password.text == "" || name.text == "" || password.text!.count<6 || password.text!.count>12){
            Alert.alertGeneral(on: self, with: "Opss...", message: "Please make sure all fields are filled in correctly.")
            return
        }
        //Checking if the email is valid
        if(!isValidEmail(email.text!)){
            Alert.alertGeneral(on: self, with: "Opss...", message: "Please make sure your email address is correct.")
            return
        }
        spinner.startAnimating();
        
        Model.instance.createUser(email: email.text!, password: password.text!,name:name.text!){(success) in
            
            self.spinner.stopAnimating()
            if(success){
                self.dismiss(animated: true, completion: nil)
            }else{
                Alert.alertGeneral(on: self, with: "Opss...", message: "The email address is already in use by another account.")

            }

        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
