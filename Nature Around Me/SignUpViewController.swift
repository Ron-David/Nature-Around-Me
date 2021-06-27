//
//  SignUpViewController.swift
//  Nature Around Me
//
//  Created by Ron David on 27/06/2021.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    
    @IBAction func addAvatar(_ sender: Any) {
    }
    
    @IBAction func signUp(_ sender: Any) {
        Model.instance.createUser(email: email.text!, password: password.text!,name:name.text!)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
