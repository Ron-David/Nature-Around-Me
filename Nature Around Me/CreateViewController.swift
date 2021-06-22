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
    

    @IBOutlet weak var id: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func createButton(_ sender: Any) {
        let post = Post.create(id: id.text!, title: postTitle.text!, location: location.text!,imageUrl: "")
        Model.instance.add(post: post){
            
        }
        navigationController?.popViewController(animated: true)
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
