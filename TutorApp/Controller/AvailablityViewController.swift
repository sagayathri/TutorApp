//
//  AvailablityViewController.swift
//  TutorApp
//

import UIKit
import Foundation
import FirebaseDatabase

class AvailablityViewController: UIViewController {

    @IBOutlet weak var timeSlotsView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet var daysButton: [UIButton]!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var constant: Constant? = nil
    let toast = Toast()
    let fetchData = FetchData.sharedInstance
    var tutors = [Tutor]()
    var tutor: Tutor? = nil
    var tutorID = 0
    var address = Address()
    var days = AvailableDay()
    let helper = HelperClass()
    let timeSlots = ["07:00", "07:30", "08:00", "08:30", "09:00", "09:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:00", "13:30","14:30", "15:00", "15:30", "16:00", "16:30", "17:00", "17:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30", "21:00" ]
    var isTimeChanged = false
    var availableSlots: [String]?
    var isSlotSelected = false
    var day: String.SubSequence?
    var activeDay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeSlotsView.delegate = self
        timeSlotsView.dataSource = self
        timeSlotsView.allowsMultipleSelection = true
        
        constant = delegate.constant
        
        loadInitialDay()
    }
    
    @IBAction func datesSelected(_ sender: UIButton) {
        day = sender.titleLabel?.text?.suffix(4)
        if isTimeChanged {
            //MARK:- Displays the alert if the schedule doesn't saved
            let alert = UIAlertController(title: "Save Schedule", message: "Please save or cancel the current changes before moving on to another day", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style {
                case .default:
                    print("ok")
                default :
                    break
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            changeDaySlots(day: String(day!), sender: sender)
        }
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        fetchData.updateDatabase(updatePath: "tutors/0/availableDays/\(activeDay)", value: constant!.changesSlots!)
        self.isTimeChanged = false
        self.configurSaveCancel()
        
        fetchDataFromFirebase()
        toast.displayToastMessage("Slots Saved")
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.changeDaySlots(day: String(day!), sender: nil)
        self.isTimeChanged = false
        self.configurSaveCancel()
    }
    
    func fetchDataFromFirebase() {
        let ref = Database.database().reference()
        ref.child("tutors").observe(.childAdded, with: {
            (snapshot) in
             self.tutors = self.fetchData.fetchDataFromFirebase(snapshot: snapshot)
            for item in self.tutors {
                if item.id == self.tutorID {
                    self.tutor = item
                }
            }
        }, withCancel: nil)
    }
    
    func loadInitialDay() {
        //MARK:- Default selected day as 'Monday'
        day = " Mon"
        activeDay = "monday"
        availableSlots = tutor?.availableDays?.monday
        self.constant!.changesSlots = availableSlots
    }
    
    //MARK:- Loads slots from database
    func changeDaySlots(day: String, sender : UIButton?) {
        availableSlots = []
        if sender != nil {
            for button in daysButton {
                button.backgroundColor = UIColor(named: "PrimaryColor")
                button.tintColor = .black
            }
            sender!.backgroundColor = .systemBackground
            sender!.tintColor = .label
        }
        switch day {
            case " Mon":
                activeDay = "monday"
                availableSlots = tutor?.availableDays?.monday
                break
            case " Tue":
                activeDay = "tuesday"
                availableSlots = tutor?.availableDays?.tuesday
                break
            case " Wed":
                activeDay = "wednesday"
                availableSlots = tutor?.availableDays?.wednesday
                break
            case "Thur":
                activeDay = "thursday"
                availableSlots = tutor?.availableDays?.thursday
                break
            case " Fri":
                activeDay = "friday"
                availableSlots = tutor?.availableDays?.friday
                break
            case " Sat":
                activeDay = "saturday"
                availableSlots = tutor?.availableDays?.saturday
                break
            case " Sun":
                activeDay = "sunday"
                availableSlots = tutor?.availableDays?.sunday
                break
            default:
                break
        }
        self.constant!.changesSlots = availableSlots
        timeSlotsView.reloadData()
    }
    
    func configurSaveCancel() {
        if isTimeChanged {
            saveButton.isUserInteractionEnabled = true
            saveButton.setTitleColor(.black, for: .normal)
            
            cancelButton.isUserInteractionEnabled = true
            cancelButton.setTitleColor(.black, for: .normal)
        }
        else {
            saveButton.isUserInteractionEnabled = false
            saveButton.setTitleColor(.darkGray, for: .normal)
            
            cancelButton.isUserInteractionEnabled = false
            cancelButton.setTitleColor(.darkGray, for: .normal)
        }
    }
}

extension AvailablityViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.timeSlots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "availabilityCell", for: indexPath) as! AvailabilityCollectionViewCell
        cell.timeSlot = timeSlots[indexPath.row]
        cell.constant = self.constant
        cell.isSlotSelected = false
        for item in availableSlots! {
            if item == timeSlots[indexPath.row] {
                cell.isSlotSelected = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "availabilityCell", for: indexPath) as! AvailabilityCollectionViewCell
        cell.constant = self.constant
        cell.timeSlot = timeSlots[indexPath.row]
        cell.selectedFunc()
        self.isTimeChanged = true
        self.configurSaveCancel()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "availabilityCell", for: indexPath) as! AvailabilityCollectionViewCell
        cell.constant = self.constant
        cell.timeSlot = timeSlots[indexPath.row]
        cell.deselectedFunc()
        self.isTimeChanged = true
        self.configurSaveCancel()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: 70.0, height: 50.0)
    }
}
