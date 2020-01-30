//
//  Tutor.swift
//  TutorApp
//

import Foundation

// MARK: - Tutor
class Tutor: NSObject {
    var id: Int? = nil
    var name: String? = nil
    var subjects: [String]? = nil
    var address: Address? = nil
    var availableDays: AvailableDay? = nil
    var bookedSlot: [String]? = nil
}

// MARK: - Address
struct Address {
    var city: String? = nil
    var locality: String? = nil
    var line1: String? = nil
    var line2: String? = nil
    var postcode: String? = nil
    var county: String? = nil
    var country: String? = nil
}

// MARK: - AvailableDay
struct AvailableDay {
    var monday: [String]? = nil
    var tuesday: [String]? = nil
    var wednesday: [String]? = nil
    var thursday: [String]? = nil
    var friday: [String]? = nil
    var saturday: [String]? = nil
    var sunday: [String]? = nil
}
