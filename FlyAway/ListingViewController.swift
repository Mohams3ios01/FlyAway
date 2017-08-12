//
//  ListingViewController.swift
//  FlyAway
//
//  Created by Mohammed Ibrahim on 2017-07-25.
//  Copyright © 2017 Mohammed Ibrahim. All rights reserved.
//

import UIKit
import TagListView

class ListingViewController: UIViewController, TagListViewDelegate {

    // outlets
    @IBOutlet weak var listingImage: UIImageView!
    @IBOutlet weak var listingTitle: UILabel!
    @IBOutlet weak var listingPrice: UILabel!
    @IBOutlet weak var listingDesc: UITextView!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var contactButton: UIButton!
    
    // local variables
    var itemImage : UIImage?
    var itemTitle : String = ""
    var price : String = ""
    var tags : String = ""
    var itemDesc : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        config()
        setupDesign()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup design
    func setupDesign() {
        listingImage.layer.cornerRadius = 15
        listingDesc.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0)
        contactButton.layer.cornerRadius = 19
    }
    
    // MARK: - Configure everything else
    func config() {
        tagListView.delegate = self
        
        self.navigationItem.title = listingTitle.text
        listingImage.image = itemImage
        listingTitle.text = itemTitle
        listingPrice.text = "$\(price)"
        listingDesc.text = itemDesc
        let tagsArray = tags.components(separatedBy: ",")
        for tag in tagsArray {
            tagListView.addTag(tag)
        }
    }
    
    @IBAction func contactUser(_ sender: Any) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
