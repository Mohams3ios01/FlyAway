//
//  DashboardViewController.swift
//  FlyAway
//
//  Created by Mohammed Ibrahim on 2017-07-21.
//  Copyright © 2017 Mohammed Ibrahim. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet

struct globalVariables {
    static var username : String = ""
}

class DashboardViewController: UIViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postButton: UIButton!
    
    var listings : [Listing] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getUsername()
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        setupDesign()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getListings()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup design
    func setupDesign() {
        postButton.layer.cornerRadius = 19
    }
    
    // MARK: - Get Username
    func getUsername() {
        FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).observe(.childAdded, with: { (snapshot) in
            let usernameValue = snapshot.value
            globalVariables.username = usernameValue as! String
        })
    }
    
    // MARK: - Empty data config
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty-table")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "There are currently no available listings to browse. You can be the first by adding your item now!"
        let descString = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)])
        return descString
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let string = "No Listings Available"
        let titleString = NSMutableAttributedString(string: string, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 22, weight: UIFontWeightMedium)])
        return titleString
    }
    
    // MARK: - Table View Delegate Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listingCell", for: indexPath) as! ListingTableViewCell
        
        cell.label.text = listings[indexPath.row].title
        cell.price.text = "$\(listings[indexPath.row].price)"
        cell.cellImageView.image = listings[indexPath.row].image
        
        return cell
        
    }
    
    // MARK: - Get all listings
    func getListings() {
        
        FIRDatabase.database().reference().child("Listings").observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! [String: String]
            let key = snapshot.key
            
            self.getImage(key: key, count: self.listings.count)
                        
            let listing = Listing()
            
            listing.title = snapshotValue["title"]!
            listing.description = snapshotValue["description"]!
            listing.price = snapshotValue["price"]!
            listing.tags = snapshotValue["tags"]!
            
            self.listings.append(listing)
            
            self.tableView.reloadData()
            
        })
    }
    
    func getImage(key: String, count: Int) {
        
        let storageRef = FIRStorage.storage().reference()
        let imageRef = storageRef.child(key)
        
        imageRef.data(withMaxSize: 1 * 1024 * 1024) { (data, error) in
            if error != nil {
                print("error")
            } else {
                let image = UIImage(data: data!)
                self.listings[count].image = image
                self.tableView.reloadData()
            }
        }
                
        
        //listings[count].image = image
        //self.tableView.reloadData()
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "goToListing") {
            
            let cell = sender as! ListingTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let listing = listings[(indexPath?.row)!]
            
            let DVC = segue.destination as! ListingViewController
            DVC.itemImage = listing.image
            DVC.itemDesc = listing.description
            DVC.itemTitle = listing.title
            DVC.tags = listing.tags
            DVC.price = listing.price
            
        }
    }
    

}
