//
//  userModel.swift
//  iosVolunteer
//
//  Created by Gary Sun on 2/4/23.
//

import Foundation

struct User: Identifiable {
    var id: String = UUID().uuidString
    var email: String
    var fname: String
    var lname: String
    var type: String
    
}
