//
//  ViewController.swift
//  FlyAway
//
//  Created by Mohammed Ibrahim on 2017-07-20.
//  Copyright © 2017 Mohammed Ibrahim. All rights reserved.
//

import UIKit
import EAIntroView
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController, EAIntroDelegate {

    @IBOutlet weak var usernameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var scrollViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var firstView : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if firstView == 0 {
            introView()
        }
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        if screenWidth == 320 { // iphone 5 and SE
            bottomConstraint.constant = 10
        } else if screenWidth == 375 { // iphone 6/7
            bottomConstraint.constant = 115
        } else if screenWidth == 414 { // plus
            bottomConstraint.constant = 180
        } else {
            print("error")
        }
        
        setupDesign(borderColor: UIColor.white, error: false, initial: true)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Setup Design
    
    func setupDesign(borderColor: UIColor, error: Bool, initial: Bool) {
        
        if initial == true {
            usernameTextField.layer.borderColor = borderColor.cgColor
            emailTextField.layer.borderColor = borderColor.cgColor
            passwordTextField.layer.borderColor = borderColor.cgColor
        }
        
        if error == true {
            
            if usernameTextField.text == "" || usernameTextField.text == nil {
                usernameTextField.layer.borderColor = borderColor.cgColor
            }
            
            if emailTextField.text == "" || emailTextField.text == nil {
                emailTextField.layer.borderColor = borderColor.cgColor
            }
            
            if passwordTextField.text == "" || passwordTextField.text == nil {
                passwordTextField.layer.borderColor = borderColor.cgColor
            }
            
        } else {
            if !(usernameTextField.text?.isEmpty)! {
                usernameTextField.layer.borderColor = borderColor.cgColor
            }
            if !(emailTextField.text?.isEmpty)! {
                emailTextField.layer.borderColor = borderColor.cgColor
            }
            if !(passwordTextField.text?.isEmpty)! {
                passwordTextField.layer.borderColor = borderColor.cgColor
            }
        }
        
        usernameTextField.layer.masksToBounds = true
        usernameTextField.layer.cornerRadius = 25
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.cornerRadius = 25
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.cornerRadius = 25
        
        usernameTextField.layer.borderWidth = 1
        emailTextField.layer.borderWidth = 1
        passwordTextField.layer.borderWidth = 1
        
    }
    
    //MARK: - Text did start editing
    @IBAction func textDidStartEditing(_ sender: Any) {
        setupDesign(borderColor: UIColor.white, error: false, initial: false)
    }
    
    
    //MARK: - Setup Intro View
    
    func introView() {
        
        let page = EAIntroPage()
        page.title = "Welcome to\nFlyAway"
        page.titleFont = UIFont.systemFont(ofSize: 36, weight: UIFontWeightThin)
        page.bgImage = UIImage(named: "gradient-1");
        page.titlePositionY = self.view.bounds.size.height/2;
        page.titleIconView = UIImageView(image: UIImage(named: "shadow"))
        page.titleIconPositionY = self.view.bounds.size.height/2 - 160;
        page.desc = "Follow through the next few slides\nto get learn how to use the app."
        page.descFont = UIFont.systemFont(ofSize: 20, weight: UIFontWeightThin)
        page.descPositionY = self.view.bounds.size.height/2 + 60
        
        let page2 = EAIntroPage()
        page2.title = "Sellers list\nitems"
        page2.titleFont = UIFont.systemFont(ofSize: 36, weight: UIFontWeightThin)
        page2.bgImage = UIImage(named: "gradient-2")
        page2.titlePositionY = self.view.bounds.size.height/2
        page2.titleIconView = UIImageView(image: UIImage(named: "sneaker"))
        page2.titleIconPositionY = self.view.bounds.size.height/2 - 160
        page2.desc = "Sellers post their item to a large\naudience in which they hope to sell."
        page2.descFont = UIFont.systemFont(ofSize: 20, weight: UIFontWeightThin)
        page2.descPositionY = self.view.bounds.size.height/2 + 60
        
        let page3 = EAIntroPage()
        page3.title = "Buyers look for\nand buy items"
        page3.titleFont = UIFont.systemFont(ofSize: 36, weight: UIFontWeightThin)
        page3.bgImage = UIImage(named: "gradient-3")
        page3.titlePositionY = self.view.bounds.size.height/2
        page3.titleIconView = UIImageView(image: UIImage(named: "search"))
        page3.titleIconPositionY = self.view.bounds.size.height/2 - 160
        page3.desc = "Buyers can browse among\nthousands of listed items\nvarying by category"
        page3.descFont = UIFont.systemFont(ofSize: 20, weight: UIFontWeightThin)
        page3.descPositionY = self.view.bounds.size.height/2 + 60
        
        let page4 = EAIntroPage()
        page4.title = "Connect and\nExchange"
        page4.titleFont = UIFont.systemFont(ofSize: 36, weight: UIFontWeightThin)
        page4.bgImage = UIImage(named: "gradient-4")
        page4.titlePositionY = self.view.bounds.size.height/2
        page4.titleIconView = UIImageView(image: UIImage(named: "placeholder"))
        page4.titleIconPositionY = self.view.bounds.size.height/2 - 160
        page4.desc = "Buyers leave with the item they’ve\nbeen looking for and sellers\nleave with cash in hand. Both\nleave happy."
        page4.descFont = UIFont.systemFont(ofSize: 20, weight: UIFontWeightThin)
        page4.descPositionY = self.view.bounds.size.height/2 + 60
        
        let btn = button()
        
        let intro = EAIntroView(frame: view.bounds, andPages: [page,page2,page3,page4])
        intro?.delegate = self
        intro?.show(in: view, animateDuration: 0.0)
        
        intro?.skipButton = btn
        intro?.skipButtonY = 60.0
        intro?.tapToNext = true
        
    }
    
    func button() -> UIButton {
        let btn = UIButton(type: .roundedRect)
        btn.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        btn.setTitle("Skip", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.borderWidth = 0
        btn.layer.cornerRadius = 0
        btn.layer.borderColor = UIColor.white.cgColor
        return btn
    }

    // MARK: - Keyboard return key
    
    @IBAction func hideKeyboard(_ sender: CustomTextField) {
       self.resignFirstResponder()
    }
    
    // MARK: - Sign up button clicked
    @IBAction func signUp(_ sender: Any) {
        SVProgressHUD.show()
        
        if emailTextField.text != nil && emailTextField.text != "" && passwordTextField.text != nil && passwordTextField.text != "" && usernameTextField.text != nil && usernameTextField.text != "" {
            
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                
                if error != nil {
                    
                    // error signing up
                    SVProgressHUD.dismiss()
                    
                    let errorSheet = UIAlertController(title: "Try Again", message: "", preferredStyle: .alert)
                    
                    
                    if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                        switch errCode {
                        case .errorCodeEmailAlreadyInUse:
                            errorSheet.message = "Email is already in use!"
                        case .errorCodeInvalidEmail:
                            errorSheet.message = "Invalid email!"
                        case .errorCodeWeakPassword:
                            errorSheet.message = "Passwords must be 6 characters or more"
                        default:
                            errorSheet.message = "There was an error while trying to sign you up! Please try again later."
                        }
                    }
                    
                    let errorAction = UIAlertAction(title: "Dismiss", style: .default, handler: { (alert) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    
                    errorSheet.addAction(errorAction)
                    
                    self.present(errorSheet, animated: true, completion: nil)
                    
                } else {
                    
                    // success signing up
                    SVProgressHUD.dismiss()
                    
                    self.performSegue(withIdentifier: "goToDashboard", sender: self)
                    
                    let usersDB = FIRDatabase.database().reference().child("Users")
                    
                    let currentUID = FIRAuth.auth()?.currentUser?.uid
                    
                    usersDB.child(currentUID!).setValue(["username" : self.usernameTextField.text])
                }
                
            })
            
        } else {
            SVProgressHUD.dismiss()
            setupDesign(borderColor: UIColor.red, error: true, initial: false)
        }
        
        
    }
    
    // MARK: - Keyboard functions
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollViewConstraint.constant = keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollViewConstraint.constant = 0
        }
    }
    
    

}

