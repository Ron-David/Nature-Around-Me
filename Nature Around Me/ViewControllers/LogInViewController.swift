//
//  LogInViewController.swift
//  Nature Around Me
//
//  Created by Ron David on 11/07/2021.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.stopAnimating()
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        //        dismiss(animated: true, completion: nil)
    }
    @IBAction func logInButton(_ sender: Any) {
        spinner.startAnimating()
        
        Model.instance.logIn(email: loginEmail.text!, password: loginPassword.text!){bool in
            self.spinner.stopAnimating()
            if bool{
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            }else{
                Alert.alertGeneral(on: self, with: "Opss...", message: "The email address or password is incorrect. Please retry...")
            }
            
        }
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
