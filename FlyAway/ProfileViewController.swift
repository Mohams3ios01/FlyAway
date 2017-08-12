//
//  ProfileViewController.swift
//  FlyAway
//
//  Created by Mohammed Ibrahim on 2017-07-21.
//  Copyright © 2017 Mohammed Ibrahim. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var username : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDesign()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Design setup
    func setupDesign() {
        signOutButton.layer.cornerRadius = 19
        settingsButton.layer.cornerRadius = 19
        
        emailLabel.text = FIRAuth.auth()?.currentUser?.email
        usernameLabel.text = globalVariables.username
    }
    
    // MARK: - Sign out
    @IBAction func signOut(_ sender: Any) {
        do{
            try FIRAuth.auth()?.signOut()
            self.navigationController?.dismiss(animated: true)
            self.navigationController?.popViewController(animated: true)
        } catch {
            print(error)
            return
        }
    }
    
    /* MARK: - Get Username
    func getUsername() {
        FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.childAdded, with: { (snapshot) in
            let usernameValue = snapshot.value
            self.username = usernameValue as! String
        })
    }*/
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
