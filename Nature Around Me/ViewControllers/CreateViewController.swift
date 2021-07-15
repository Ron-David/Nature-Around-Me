//
//  CreateViewController.swift
//  Nature Around Me
//
//  Created by Ron David on 18/06/2021.
//

import UIKit

class CreateViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var location: UITextField!

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var detailsText: UITextView!
    @IBOutlet weak var postTitle: UITextField!
        
    let defaultImage = UIImage(systemName: "photo.on.rectangle.angled")
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    var imgIndex:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.stopAnimating()
        // Do any additional setup after loading the view.
    }
    @IBAction func clearButton(_ sender: Any) {
        img1.image = defaultImage
        img2.image = defaultImage
        img3.image = defaultImage
        detailsText.text = ""
        postTitle.text = ""
        location.text = ""
    }
    @IBAction func addImg1(_ sender: Any) {
        imgIndex = 1
        ImgPicker.pickImg(on: self);
    }
    
    @IBAction func addImg2(_ sender: Any) {
        imgIndex = 2
        ImgPicker.pickImg(on: self);
    }
    
    @IBAction func addImg3(_ sender: Any) {
        imgIndex = 3
        ImgPicker.pickImg(on: self);
    }
    //Catching the img
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.spinner.startAnimating()
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        switch imgIndex {
        case 1:
            self.img1.image = image
        case 2:
            self.img2.image = image
        case 3:
            self.img3.image = image
        default:
            self.img1.image = image
        }

        self.spinner.stopAnimating()

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButton(_ sender: Any) {
        
        if !validatePost(){
            return
        }
        self.spinner.startAnimating()
        let randId = generateRandomId()

        saveImages(imgs: [img1.image ,img2.image,img3.image]) { (urls) in
            let post = Post.create(id: randId, title: self.postTitle.text!, location: self.location.text!,imageUrl1: urls[0] ,imageUrl2: urls[1] ,imageUrl3: urls[2] ,freeText: self.detailsText.text, isActive: true)
            Model.instance.add(post: post){
                self.spinner.stopAnimating()
                self.clearButton(self)
                self.tabBarController?.selectedIndex = 0

        }
  
        }

    }
    
    func generateRandomId() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<10).map{ _ in letters.randomElement()! })
    }
    
    func saveImages(imgs:[UIImage?],callback:@escaping ([String])->Void){
        let length = imgs.count
        var urls = [String]()

        for img in imgs{
            if img == defaultImage{
                urls.append("")
                if urls.count == length{
                    callback(urls)
                }
            }else{
                Model.instance.saveImage(image: img!) { (url) in
                    urls.append(url)
                    if urls.count == length{
                        callback(urls)
                    }
                }
            }
        }
        
    }


    func validatePost()->Bool{
        if !Model.instance.isLoggedIn(){
            let a = UIAlertAction(title: "Log-In", style: .default, handler: {_ in
                self.performSegue(withIdentifier: "toLogIn2", sender: self)
            })
            
            let b = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            Alert.twoOptionAlert(on: self, with: "Opps...", message: "Please log-in to continue", optionA: a, optionB: b)
            return false
        }
        var atLeastOneImg = false
        for img in [img1.image ,img2.image,img3.image]{
            if img != nil && img != defaultImage {
                atLeastOneImg = true
                break
            }
        }
        if(!atLeastOneImg){
            Alert.alertGeneral(on: self, with: "Error", message: "Choose at least one image")
            return false
        }
        if(postTitle.text == "" || location.text == "" || detailsText.text == ""){
            Alert.alertGeneral(on: self, with: "Error", message: "Please fill all field")
            return false
        }
        return true
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
