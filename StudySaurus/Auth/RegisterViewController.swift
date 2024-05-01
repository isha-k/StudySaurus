//
//  RegisterViewController.swift
//  StudySaurus
//
//  Created by Isha Kaur on 30/4/2024.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerUser(_ sender: Any) {
        // Check if passwords match
       guard let email = emailTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text, password == confirmPassword else {
           displayMessage(title: "Error", message: "Passwords do not match")
           return
       }
    
       // Attempt to create user
       Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
           if let e = error {
               self.displayMessage(title: "Error", message: e.localizedDescription)
           } else {
               //Navigate to home
               self.performSegue(withIdentifier: "goToHome", sender: self)
           }
       }
        
        
        
//        
//        if let email = emailTextField.text, let password = passwordTextField.text {
//            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//                if let e  = error {
//                    self.displayMessage(title: "Error", message: e.localizedDescription)
//                } else {
//                    //Navigate to home
//                    self.performSegue(withIdentifier: "goToHome", sender: self)
//                }
//            }
//        }
//        
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
