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
        
    let defaultImage = UIImage(systemName: "person.fill")
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
//        Model.instance.saveImage(image: image!) { url in
//            self.spinner.stopAnimating()
//
//        }
        self.spinner.stopAnimating()

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createButton(_ sender: Any) {
        let randId = generateRandomId()
        let post = Post.create(id: randId, title: postTitle.text!, location: location.text!,imageUrl: "", isActive: true)
        Model.instance.add(post: post){
            
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    func generateRandomId() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<10).map{ _ in letters.randomElement()! })
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
