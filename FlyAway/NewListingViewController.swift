//
//  NewListingViewController.swift
//  FlyAway
//
//  Created by Mohammed Ibrahim on 2017-07-22.
//  Copyright © 2017 Mohammed Ibrahim. All rights reserved.
//

import UIKit
import TagListView
import Firebase
import SVProgressHUD
import EHPlainAlert

class NewListingViewController: UIViewController, TagListViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleTextField: CustomTextField!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var tagTextField: CustomTextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceString: CustomTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewConstraint: NSLayoutConstraint!
    
    var imageData : Data? = nil
    
    var tags : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDesign()
        config()
        
        imageData = UIImageJPEGRepresentation(itemImageView.image!, 0.8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup design
    func setupDesign() {
        
        // image view
        itemImageView.layer.cornerRadius = 15
        
        // title text field
        titleTextField.layer.masksToBounds = true
        titleTextField.layer.cornerRadius = 25
        
        titleTextField.layer.borderColor = UIColor(red: 99/255, green: 169/255, blue: 245/255, alpha: 1).cgColor
        
        titleTextField.layer.borderWidth = 1.5
        
        // tag text field
        tagTextField.delegate = self
        
        tagTextField.layer.masksToBounds = true
        tagTextField.layer.cornerRadius = 25
        
        tagTextField.layer.borderColor = UIColor(red: 99/255, green: 169/255, blue: 245/255, alpha: 1).cgColor
        
        tagTextField.layer.borderWidth = 1.5
        
        textView.text = "Description (tap to edit)"
        textView.textColor = UIColor.lightGray
        
        descriptionLabel.textColor = UIColor.lightGray
        
        // price text field
        
        priceString.delegate = self
        
        priceString.layer.masksToBounds = true
        priceString.layer.cornerRadius = 25
        
        priceString.layer.borderColor = UIColor(red: 99/255, green: 169/255, blue: 245/255, alpha: 1).cgColor
        
        priceString.layer.borderWidth = 1.5
        
        priceString.keyboardType = UIKeyboardType.numberPad
        
        // text view
        
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 25
        
        textView.layer.borderColor = UIColor(red: 99/255, green: 169/255, blue: 245/255, alpha: 1).cgColor
        
        textView.layer.borderWidth = 1.5
        
        textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20)

    }
    
    // MARK: - Configure delegates
    func config() {
        tagListView.delegate = self
        textView.delegate = self
    }
    
    func pushTag(tagTitle: String) {
        tags.append(tagTitle)
        print(tags)
        if tags.count >= 4 {
            tagTextField.isEnabled = false
            tagTextField.alpha = 0.4
        } else {
            tagTextField.isEnabled = true
            tagTextField.alpha = 1
        }
    }
    
    func removeTag(tagTitle: String) {
        let newTags = self.tags.filter { $0 != tagTitle }
        tags = newTags
        print("New tags: \(tags)")
        if tags.count >= 4 {
            tagTextField.isEnabled = false
            tagTextField.alpha = 0.4
        } else {
            tagTextField.isEnabled = true
            tagTextField.alpha = 1
        }
    }
    
    // MARK: - Text Field Delegate functions
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " && textField.tag == 1 {
            
            let tagTitle = tagTextField.text!
            let newTagTitle = tagTitle.replacingOccurrences(of: " ", with: "")
            if tags.contains(newTagTitle) {
                let errorAction = UIAlertController(title: "There was a problem!", message: "You cannot add two of the same tags on one post", preferredStyle: .alert)
                let actionSheet = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
                errorAction.addAction(actionSheet)
                present(errorAction, animated: true, completion: { 
                    self.tagTextField.text = ""
                })
            } else {
                pushTag(tagTitle: newTagTitle)
                tagTextField.text = ""
                tagListView.addTag(newTagTitle).onTap = { [weak self] tagView in
                    self?.tagListView.removeTagView(tagView)
                    self?.removeTag(tagTitle: newTagTitle)
                }
            }
            
        } else if textField.tag == 2 && !(string.rangeOfCharacter(from: NSCharacterSet(charactersIn: "0123456789") as CharacterSet) != nil){
            
            print("not letter entered")
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
            
        }
        
        return true
    }
    
    // MARK: - Return key config
    @IBAction func returnKeyboard(_ sender: Any) {
        self.resignFirstResponder()
    }
    
    
    // MARK: - Text view delegate functions
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description (tap to edit)"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count // for Swift use count(newText)
        if numberOfChars != 0 {
            descriptionLabel.text = "Description (\(350 - numberOfChars) characters left)"
        } else {
            descriptionLabel.text = "Description (350 characters maximum)"
        }
        
        return numberOfChars < 350;
    }
    
    // MARK: - Photo picking 
    @IBAction func choosePhoto(_ sender: Any) {
        
        let photoActionSheet = UIAlertController(title: "Camera or Photo Library", message: "Please pick your camera or gallery to select a photo", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (alert) in
            
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.camera
            pickerController.allowsEditing = true
            
            self.present(pickerController, animated: true, completion: nil)

        }
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (alert) in
            
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerController.allowsEditing = true
            
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        photoActionSheet.addAction(cameraAction)
        photoActionSheet.addAction(photoAction)
        photoActionSheet.addAction(cancelAction)
        
        present(photoActionSheet, animated: true, completion: nil)
        
    }
    
    //delegate function(s)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageData = UIImageJPEGRepresentation(image, 0.8)
            itemImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Save listing
    @IBAction func saveListing(_ sender: Any) {
        if textView.text == nil || textView.text == "Description (tap to edit)" || textView.text == "" || titleTextField.text == nil || titleTextField.text == "" || tags.isEmpty || priceString.text == nil || priceString.text == "" {
            let alertController = UIAlertController(title: "Please fill in all required fields!", message: "A listing requires a title, price, at least one tag, and a description in order to post.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        } else {
            SVProgressHUD.show()
            let stringTags = tags.joined(separator: ",")
            let dictionary = ["title":titleTextField.text!, "price": priceString.text!, "tags":stringTags, "description":textView.text as String] as [String : Any]
            uploadListing(listing: dictionary)
        }
    }
    
    // MARK: - Firebase upload methods
    func uploadListing(listing: Dictionary<String, Any>) {
        let databaseRef = FIRDatabase.database().reference().child("Listings").childByAutoId()
        let databaseID = databaseRef.key
        databaseRef.setValue(listing)
        databaseRef.setValue(listing) { (error, databaseRef) in
            if error != nil {
                EHPlainAlert.show(withTitle: "Please try again later", message: "An error was encountered when trying to upload your listing", type: ViewAlertError)
            } else {
                self.uploadImageToFirebase(id: databaseID)
            }
        }
        
    }
    
    func uploadImageToFirebase(id: String) {
        let storageRef = FIRStorage.storage().reference().child(id)
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        storageRef.put(imageData!, metadata: uploadMetadata) { (metadata, error) in
            if error != nil {
                SVProgressHUD.dismiss()
                print("error: \(error?.localizedDescription ?? "error")")
                EHPlainAlert.show(withTitle: "Please try again later", message: "An error was encountered when trying to upload your image", type: ViewAlertError)
            } else {
                SVProgressHUD.dismiss()
                print("upload complete!: \(metadata!)")
                EHPlainAlert.show(withTitle: "Success", message: "Your listing was successfully posted!", type: ViewAlertSuccess)
                self.performSegue(withIdentifier: "goToListing", sender: self)
            }
        }
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "goToListing" {
            let DVC = segue.destination as! ListingViewController
            DVC.itemTitle = titleTextField.text!
            DVC.price = priceString.text!
            let stringTags = tags.joined(separator: ",")
            DVC.tags = stringTags
            DVC.itemDesc = textView.text
            DVC.itemImage = itemImageView.image
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
