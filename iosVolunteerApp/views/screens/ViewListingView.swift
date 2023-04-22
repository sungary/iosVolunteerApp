//
//  ViewListingView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 1/28/23.
//

import SwiftUI

struct ViewListingView: View {
    
    let listing: Listing
    let dateFormatter = DateFormatter()
    
    var body: some View {
        VStack(){
            Text(listing.name)
                .padding()
            Text(listing.location)
                .padding()
            HStack() {
                Text(listing.timeStart, style: .date)
                    .padding()
                Text(listing.timeStart, style: .time)
                    .padding()
            }
            HStack() {
                Text(listing.timeEnd, style: .date)
                    .padding()
                Text(listing.timeEnd, style: .time)
                    .padding()
            }
            
            Text(listing.description)
                .padding()
        }
    }
}

struct ViewListingView_Previews: PreviewProvider {
    static var previews: some View {
        ViewListingView(listing: Listing(name: "Test Name", description: "Test L Description"))
    }
}
