//
//  FetchData.swift
//  TutorApp
//

import Foundation
import  FirebaseDatabase

class FetchData {
    
    static let sharedInstance = FetchData()
    
    var tutors : [Tutor] = []
    
    //MARK:- Fetches and manipulate data from database
    func fetchDataFromFirebase(snapshot: DataSnapshot) -> [Tutor] {
        if let tutorDict = snapshot.value as? [String: AnyObject] {
            let tutor = Tutor()
            var address = Address()
            var days = AvailableDay()
            tutor.name = tutorDict["name"] as? String
            tutor.id = tutorDict["id"] as? Int
            tutor.subjects = tutorDict["subjects"] as? [String]

            let addressDict = tutorDict["address"] as? [String: Any]
            address.city = addressDict!["city"] as? String
            address.line1 = addressDict!["line1"] as? String
            address.line2 = addressDict!["line2"] as? String
            address.locality = addressDict!["locality"] as? String
            address.county = addressDict!["county"] as? String
            address.country = addressDict!["country"] as? String
            address.postcode = addressDict!["postcode"] as? String
            tutor.address = address
            
            let daysDict = tutorDict["availableDays"] as? [String: Any]
            days.monday = daysDict!["monday"] as? [String]
            days.tuesday = daysDict!["tuesday"] as? [String]
            days.wednesday = daysDict!["wednesday"] as? [String]
            days.thursday = daysDict!["thursday"] as? [String]
            days.friday = daysDict!["friday"] as? [String]
            days.saturday = daysDict!["saturday"] as? [String]
            days.sunday = daysDict!["sunday"] as? [String]
            tutor.availableDays = days

            self.tutors.append(tutor)
        }
        return self.tutors
    }
    
    //MARK:- Updates the database
    func updateDatabase(updatePath: String, value: Any) {
        let ref = Database.database().reference()
        ref.child(updatePath).setValue(value)
    }
}
