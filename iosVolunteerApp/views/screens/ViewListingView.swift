//
//  ViewListingView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 1/28/23.
//

import SwiftUI

struct ViewListingView: View {
    
    let listing: Listing
    
    var body: some View {
        VStack(){
            Text(listing.name)
                .padding()
            Text(listing.lDescription)
        }
    }
}

struct ViewListingView_Previews: PreviewProvider {
    static var previews: some View {
        ViewListingView(listing: Listing(name: "Test Name", sDescription: "Test S Description", lDescription: "Test L Description"))
    }
}
