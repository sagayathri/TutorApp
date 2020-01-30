//
//  Constant.swift
//  TutorApp
//

import Foundation

class Constant {
    
    static let shared = Constant()
    
    let GetAddress_ApiKey_1 = "ycn4sRL_s0mPC-cb04NNwg22959"
    let GetAddress_ApiKey = "MfEAExFBT0GDYT8HaXBOJQ24017";
    let GetAddressURL = "https://api.getAddress.io/find/"
    
    var changesSlots: [String]? = []
    var isReloading = false
    
    var selectedSlots: [String] = []
    
}
