//
//  CreateViewController.swift
//  Nature Around Me
//
//  Created by Ron David on 18/06/2021.
//

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet weak var location: UITextField!

    @IBOutlet weak var postTitle: UITextField!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
