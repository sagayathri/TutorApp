//
//  AddressViewController.swift
//  TutorApp
//

import UIKit
import HideKeyboard
import FirebaseDatabase

class AddressViewController: UIViewController, NetworkSessionDelegate {
    
    @IBOutlet weak var postCodeTF: UITextField!
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var addressLine1TF: UITextField!
    @IBOutlet weak var addressLine2TF: UITextField!
    @IBOutlet weak var LocalityTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var countyTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    let networkSession = NetworkSession.sharedInstance
    
    var tutor: Tutor? = nil
    var address: [String] = []
    let toast = Toast()
    var editedAddress: [String: Any] = [:]
    let fetchData = FetchData.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressTableView.delegate = self
        addressTableView.dataSource = self
        
        tableHeight.constant = 0
        
        networkSession.sessionDelegate = self
        
        loadAddressFromDatabase()
    }
    
    func loadAddressFromDatabase() {
        addressLine1TF.text = tutor?.address?.line1
        addressLine2TF.text = tutor?.address?.line2
        LocalityTF.text = tutor?.address?.locality
        cityTF.text = tutor?.address?.city
        countyTF.text = tutor?.address?.county
        countryTF.text = tutor?.address?.country
        postCodeTF.text = tutor?.address?.postcode
    }
    
    func loadAddress(addresses: [String]) {
        tableHeight.constant = 170
        self.address = addresses
        addressTableView.reloadData()
    }
    
    func loadAddressFromAPI(selectedAddress: String) {
        let addressArray = selectedAddress.components(separatedBy: ", ")
        addressLine1TF.text = addressArray[0]
        addressLine2TF.text = addressArray[1]
        LocalityTF.text = addressArray[4]
        cityTF.text = addressArray[5]
        countyTF.text = addressArray[6]
        countryTF.text = "England"
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "Search" {
            searchButton.setTitle("Enter manually", for: .normal)
            if postCodeTF.text! != "" {
                networkSession.fetchHouseFromAPI(postcode: postCodeTF.text!)
                self.hideKeyboard()
                
                saveButton.isUserInteractionEnabled = true
                saveButton.setTitleColor(.black, for: .normal)
                
                cancelButton.isUserInteractionEnabled = true
                cancelButton.setTitleColor(.black, for: .normal)
            }
            else {
                toast.displayToastMessage("Please enter postcode")
            }
        }
        else {
            searchButton.setTitle("Search", for: .normal)
            tableHeight.constant = 0
        }
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        editedAddress = ["line1": addressLine1TF.text!,"line2": addressLine2TF.text!, "locality": LocalityTF.text!, "city": cityTF.text!,
                         "county": countyTF.text!, "country": countryTF.text!, "postcode": postCodeTF.text!]
        fetchData.updateDatabase(updatePath: "tutors/0/address", value: self.editedAddress)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        tableHeight.constant = 0
        loadAddressFromDatabase()
    }
    
    func updateDatabase(updatePath: String) {
        let ref = Database.database().reference()
        ref.child("tutors/0/address").setValue(self.editedAddress)
    }
}

extension AddressViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return address.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        
        //MARK:- Removes empty spaces in address
        let addressArray = address[indexPath.row].components(separatedBy: ", ")
        var newAddress = addressArray[0]
        for i in 1 ..< addressArray.count {
            if addressArray[i] != "" {
                newAddress = newAddress + ", \(addressArray[i])"
            }
        }
        cell.textLabel?.text = newAddress
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableHeight.constant = 0
        loadAddressFromAPI(selectedAddress: address[indexPath.row])
    }
}
