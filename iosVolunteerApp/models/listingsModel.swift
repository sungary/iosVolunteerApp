//
//  listingsModel.swift
//  iosVolunteer
//
//  Created by Gary Sun on 1/23/23.
//

import Foundation

struct Listing: Identifiable {
    var id: String = ""
    var name: String = ""
    var description: String = ""
    var timeStart: Date = Date()
    var timeEnd: Date = Date()
    var createdBy: String = ""
    var createdOn: String = ""
    var location: String = ""
    var favorited: Bool = false
}
