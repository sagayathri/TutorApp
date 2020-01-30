//
//  AccountViewController.swift
//  TutorApp
//

import UIKit
import FirebaseDatabase

class AccountViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var accountTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    let rowItems = ["My Profile", "Edit Availability", "Manage Address", "My Payment", "Account Statement", "Refer & Earn", "About Sophia", "Share App", "Logout"]
    
    let helper = HelperClass()
    var constant = Constant.shared
    let fetchData = FetchData.sharedInstance
    
    var tutors = [Tutor]()
    var tutor: Tutor? = nil
    var tutorID = 1001

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK:- Adds corner edges to profile image
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.systemBackground.cgColor
        profileImage.layer.cornerRadius = 55
        profileImage.clipsToBounds = true
        
        //MARK:- Fetches data from database
        self.fetchDataFromFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK:- Resize tableView height to match screen size
        self.tableViewHeight?.constant = self.accountTableView.contentSize.height + 10
    }
    
    func fetchDataFromFirebase() {
        let ref = Database.database().reference()
        ref.child("tutors").observe(.childAdded, with: {
            (snapshot) in
            self.tutors = self.fetchData.fetchDataFromFirebase(snapshot: snapshot)
            self.updateUI()
        }, withCancel: nil)
    }
    
    func updateUI() {
        //MARK:- Considering the current tutor as 'John'
        for item in self.tutors {
            if item.id == tutorID {
                self.tutor = item
            }
        }
    }
}

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.rowHeight = 60
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountTableViewCell
        cell.rowItem = rowItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let titleValue = rowItems[indexPath.row]
        accountTableView.deselectRow(at: indexPath, animated: true)
        switch titleValue {
        case "Manage Address":
            let vc = self.storyboard?.instantiateViewController(identifier: "AddressViewController") as! AddressViewController
            vc.tutor = self.tutor
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "Edit Availability":
            let vc = self.storyboard?.instantiateViewController(identifier: "AvailablityViewController") as! AvailablityViewController
            vc.tutor = self.tutor
            vc.tutorID = self.tutorID
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case "Logout":
            helper.alertBox(controller: self, title: "Alert", message: "Are you sure to logout?", ok: "Yes", cancel: "Cancel")
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillAppear(false)
    }
}
