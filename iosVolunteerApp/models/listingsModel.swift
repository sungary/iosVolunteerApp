//
//  listingsModel.swift
//  iosVolunteer
//
//  Created by Gary Sun on 1/23/23.
//

import Foundation

struct Listing: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var sDescription: String
    var lDescription: String
    
}
