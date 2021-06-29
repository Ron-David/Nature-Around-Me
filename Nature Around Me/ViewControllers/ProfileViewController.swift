//
//  ProfileViewController.swift
//  Nature Around Me
//
//  Created by Ron David on 17/06/2021.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var loginPopup: UIView!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    @IBAction func logOut(_ sender: Any) {
        Model.instance.logOut()
        viewWillAppear(true)
    }
    @IBAction func logInButton(_ sender: Any) {

        Model.instance.logIn(email: loginEmail.text!, password: loginPassword.text!)
        loginPopup.isHidden = true
        viewWillAppear(true)

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Checking if the user is logged-in
        if(Model.instance.isLoggedIn()){
            isLoggedIn()
        }else{
            logInView()
        }
    }
    
    func isLoggedIn(){
        print(Model.instance.isLoggedIn())
        loginPopup.isHidden = true
    }
    
    func logInView(){
        print(Model.instance.isLoggedIn())
        loginPopup.isHidden = false
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
