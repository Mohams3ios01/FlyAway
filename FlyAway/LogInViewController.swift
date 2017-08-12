//
//  LogInViewController.swift
//  FlyAway
//
//  Created by Mohammed Ibrahim on 2017-07-20.
//  Copyright © 2017 Mohammed Ibrahim. All rights reserved.
//

import UIKit
import SVProgressHUD
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupDesign()
        UIApplication.shared.statusBarStyle = .lightContent

    }
    
    override func viewDidAppear(_ animated: Bool) {
        passwordTextField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Setup Design
    
    func setupDesign() {
        
        let borderColor = UIColor.white
        
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.cornerRadius = 25
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.cornerRadius = 25
        
        emailTextField.layer.borderColor = borderColor.cgColor
        passwordTextField.layer.borderColor = borderColor.cgColor
        
        emailTextField.layer.borderWidth = 1
        passwordTextField.layer.borderWidth = 1
        
    }
    
    //MARK: - Keyboard return key
    @IBAction func hideKeyboard(_ sender: CustomTextField) {
        self.resignFirstResponder()
    }
    
    //MARK: - Login
    @IBAction func logIn(_ sender: Any) {
        SVProgressHUD.show()
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            
            if error != nil {
                
                SVProgressHUD.dismiss()
                
                let errorSheet = UIAlertController(title: "Try Again", message: "", preferredStyle: .alert)
                
                if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                    switch errCode {
                        
                    case .errorCodeInvalidEmail:
                        errorSheet.message = "Invalid Email!"
                    case .errorCodeUserNotFound:
                        errorSheet.message = "Your email cannot be found in the database"
                    case .errorCodeWrongPassword:
                        errorSheet.message = "The password you entered was incorrect"
                    default:
                        errorSheet.message = "There was an error while trying to sign you in! Please try again later."
                    }
                }
                
                let errorAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                
                errorSheet.addAction(errorAction)
                
                self.present(errorSheet, animated: true, completion: nil)
                
            } else {
                
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "goToDashboard", sender: self)
                
            }
            
        })
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toSignUp" {
            let DVC = segue.destination as! SignUpViewController
            DVC.firstView = 1
        }
    }
    

}
