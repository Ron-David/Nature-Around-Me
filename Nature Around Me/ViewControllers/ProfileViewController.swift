//
//  ProfileViewController.swift
//  Nature Around Me
//
//  Created by Ron David on 17/06/2021.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var editAvatarBtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var bioText: UITextView!
    @IBOutlet weak var logOutBtn: UIButton!

    var currentUser:MyUser?
    let defaultImage = UIImage(systemName: "person.fill")


    var isAnAccount:Bool!
    var editMode = false;
    
    @IBOutlet weak var editBtn: UIBarButtonItem!

    
    @IBAction func editBtn(_ sender: Any) {
        //Clicked edit
        if(!editMode){
            editMode = true
            editBtn.title = "Save"
            name.isEnabled = true
            bioText.isEditable = true
            
        }else{
            self.spinner.startAnimating()
            name.isEnabled = false
            bioText.isEditable = false
    
            updateProfileInfo(email.text ?? "",name.text ?? "",bioText.text ?? ""){succeeded in
                self.spinner.stopAnimating()
                
                if(succeeded){
                    self.editMode = false
                    self.editBtn.title = "Edit"
                }else{
                    Alert.alertGeneral(on: self, with: "Error!", message: "something went wrong... please try again later")
                    self.name.isEnabled = true
                    self.bioText.isEditable = true
                    
                }
                
            }
            
        }
    }
    
    @IBAction func editAvatar(_ sender: Any) {
        ImgPicker.pickImg(on: self);
    }
    //Catching the img
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.spinner.startAnimating()
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.avatar.image = image
        Model.instance.saveImage(image: image!) { url in
            Model.instance.addUser(email: self.email.text!, name: self.name.text!, img: url, bio: self.bioText.text) { updated in
                if(!updated){
                    Alert.alertGeneral(on: self, with: "Error", message: "Please try again later")
                }
                self.spinner.stopAnimating()

            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
    }
    @IBAction func logOut(_ sender: Any) {
        avatar.image = defaultImage
        email.text = nil
        name.text = nil
        bioText.text = "Bio"
        Model.instance.logOut()
        viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.stopAnimating()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Checking if the user is logged-in
        
        isAnAccount = Model.instance.isLoggedIn()
        if(isAnAccount){
            isLoggedIn()
        }else{
            needToLogIn()
        }
    }
    
    func isLoggedIn(){
        editBtn.isEnabled = true
        editAvatarBtn.isEnabled = true
        logInBtn.isHidden = true
        logOutBtn.isHidden = false

        Model.instance.currentUser() { [self]user in
            currentUser = user
            email.text = user.email
            name.text = user.name
            if(!(user.img == "")){
                let url = URL(string: user.img)
                avatar.kf.setImage(with: url)
            }
            if(!(user.bio == "")){
                bioText.text = user.bio
            }
        }
    }
    
    func needToLogIn(){
        editBtn.isEnabled = false
        editAvatarBtn.isEnabled = false
        logOutBtn.isHidden = true
        logInBtn.isHidden = false
        
        let a = UIAlertAction(title: "Log-In", style: .default, handler: {_ in
            self.performSegue(withIdentifier: "toLogIn", sender: self)
        })
        
        let b = UIAlertAction(title: "Sign-Up", style: .default, handler: {_ in
            self.performSegue(withIdentifier: "toSignUp", sender: self)
        })
        let c = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
    
        Alert.threeOptionAlert(on: self, with: "Before we continue", message: "please login or signup to continue", optionA: a, optionB: b,optionC: c)
        
    }
    
    func updateProfileInfo(_ email:String,_ name:String ,_ bio:String,callback:@escaping (Bool)->Void){
        let imgUrl = currentUser?.img
        Model.instance.addUser(email: email, name: name, img: imgUrl ?? "", bio: bio) { succeeded in
            if(!succeeded){
                Alert.alertGeneral(on: self, with: "Error!", message: "something went wrong... please try again later")
            }
            callback(succeeded)
        }
    }
    
    @IBAction func logInButton(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogIn", sender: self)
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
