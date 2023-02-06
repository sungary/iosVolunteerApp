//
//  userModel.swift
//  iosVolunteer
//
//  Created by Gary Sun on 2/4/23.
//

import Foundation

class User {
    
    var id: String
    var email: String
    var fname: String
    var lname: String
    var type: String
    
    init(id: String, email: String, fname: String, lname: String, type: String, isSignedIn: Bool) {
        self.id = id
        self.email = email
        self.fname = fname
        self.lname = lname
        self.type = type
    }
}
