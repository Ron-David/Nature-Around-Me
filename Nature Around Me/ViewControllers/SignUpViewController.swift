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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        
    }
    
    
    //Adding avatar from cam/gallery
    @IBAction func addAvatar(_ sender: Any) {
        ImgPicker.pickImg(on: self)
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
            
            
            if(success){
                if let img = self.image {
                    Model.instance.saveImage(image: img) { (url) in
                        Model.instance.addUser(email: self.email.text!, name: self.name.text!, img: url) { (success) in
                            if(!success){
                                Alert.alertGeneral(on: self, with: "Opss...", message: "User created but failed to add avatar, please try again later")
                            }
                            self.spinner.stopAnimating()
                            self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true, completion: nil)
                            
                        }
                    }
                }else{
                    self.spinner.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            }else{
                self.spinner.stopAnimating()
                Alert.alertGeneral(on: self, with: "Opss...", message: "The email address is already in use by another account.")
                
            }
            
        }
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
