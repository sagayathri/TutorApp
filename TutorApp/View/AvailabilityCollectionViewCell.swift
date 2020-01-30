//
//  AvailabilityCollectionViewCell.swift
//  TutorApp
//

import UIKit

class AvailabilityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var constant: Constant? = nil
    var selectedSlots: [String] = []
    var isSlotChanged = false
    var isFound = false
    var index: Int? = nil
    
    var timeSlot: String = "" {
        didSet {
            configureCell()
        }
    }
    
    var availableSlots:[String] = []
    
    var isSlotSelected: Bool = false {
        didSet{
            if isSlotSelected {
                self.timeLabel.backgroundColor = UIColor(named: "PrimaryColor")
                self.timeLabel.textColor = .black
            }
            else {
                self.timeLabel.backgroundColor = UIColor.systemBackground
                self.timeLabel.textColor = .label
            }
        }
    }
    
    override var isSelected: Bool{
        didSet{
            updateSlots()
        }
    }
    
    func configureCell() {
        timeLabel.layer.borderWidth = 1
        timeLabel.layer.cornerRadius = 5
        timeLabel.layer.borderColor = UIColor.black.cgColor
        
        timeLabel.text = timeSlot
    }
    
    func loadSlots(isSlotSelected: Bool) {
        if isSlotSelected {
            self.timeLabel.backgroundColor = UIColor(named: "PrimaryColor")
            self.timeLabel.textColor = .black
        }
        else {
            self.timeLabel.backgroundColor = UIColor.systemBackground
            self.timeLabel.textColor = .label
        }
    }
    
    
    func updateSlots() {
        if isSelected {
            if isSlotSelected {
                self.timeLabel.backgroundColor = UIColor.systemBackground
                self.timeLabel.textColor = .label
            }
            else {
                self.timeLabel.backgroundColor = UIColor(named: "PrimaryColor")
                self.timeLabel.textColor = .black
            }
        }
        else {
            if isSlotSelected {
                self.timeLabel.backgroundColor = UIColor(named: "PrimaryColor")
                self.timeLabel.textColor = .black
            }
            else {
                self.timeLabel.backgroundColor = UIColor.systemBackground
                self.timeLabel.textColor = .label
            }
        }
    }
    
    func selectedFunc() {
        DispatchQueue.main.async {
            //MARK:- Finds the current index of the slots
            for index in 0 ..< self.constant!.changesSlots!.count {
                if self.constant!.changesSlots![index] == self.timeSlot {
                     self.index = index
                }
            }
            
            //MARK:- If current slot exixts it will be removed else new slot will be added to the slot
            if self.timeLabel.backgroundColor == UIColor(named: "PrimaryColor") {
                if self.index != nil {
                    if self.constant!.changesSlots![self.index!] == self.timeSlot {
                        self.constant!.changesSlots!.remove(at: self.index!)
                    }
                }
                else {
                    self.constant!.changesSlots!.append(self.timeSlot)
                }
            }
        }
        
    }
    
    func deselectedFunc() {
        DispatchQueue.main.async {
            //MARK:- Finds the current index of the slots
            for index in 0 ..< self.constant!.changesSlots!.count {
                if self.constant!.changesSlots![index] == self.timeSlot {
                     self.index = index
                }
            }
            
            //MARK:- If current slot exixts it will be removed else new slot will be added to the slot
            if self.timeLabel.backgroundColor == UIColor.systemBackground {
                if self.index != nil {
                    if self.constant!.changesSlots![self.index!] == self.timeSlot {
                        self.constant!.changesSlots!.remove(at: self.index!)
                    }
                }
                else {
                    self.constant!.changesSlots!.append(self.timeSlot)
                }
            }
        }
    }
}
