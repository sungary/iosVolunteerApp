//
//  ViewMyListingView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 3/19/23.
//

import SwiftUI

struct ViewMyListingView: View {
    
    @State var listing: Listing
    @State var isEditing: Bool = false
    @State var isToolbarHidden: Bool = true
    
    var body: some View {
        ZStack {
            switch isEditing {
            case true:
                ViewListingEditView(listing: $listing, isEditing: $isEditing)
            case false:
                VStack(){
                    Text(listing.name)
                        .padding()
                    Text(listing.location)
                        .padding()
                    Text(listing.description)
                        .padding()
                }
                .navigationTitle(listing.name)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        Button {
                            isEditing.toggle()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .buttonStyle(.bordered)
                        .cornerRadius(25)
                        .tint(.blue)
                    }
                }
            }
        }
        .padding()
    }
}

struct ViewMyListingView_Previews: PreviewProvider {
    static var previews: some View {
        ViewMyListingView(listing: Listing(name: "Test Name", description: "Test L Description"))
    }
}
