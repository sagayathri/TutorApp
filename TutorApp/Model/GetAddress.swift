//
//  GetAddress.swift
//  TutorApp
//

import Foundation

//MARK:- GetAddress
struct GetAddress: Codable {
    var latitude: Double
    var longitude: Double
    var addresses: [String]
}
