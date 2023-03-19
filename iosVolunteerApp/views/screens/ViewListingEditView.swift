//
//  ViewListingEditView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 3/19/23.
//

import SwiftUI

struct ViewListingEditView: View {
    
    @Binding var listing: Listing
    @Binding var isEditing: Bool
    @State var name: String = ""
    @State var location: String = ""
    @State var description: String = ""
    
    var body: some View {
        VStack {
            Button {
                
            } label: {
                Text("Delete")
            }
            .buttonStyle(.bordered)
            .cornerRadius(25)
            .tint(.red)
            
            TextField(text: $name, prompt: Text("Name")) {
                Text("Event Name")
            }
            .padding()
            .background(Color(red: 220/256, green: 220/256, blue: 220/256))
            .cornerRadius(25)
            .onAppear() {
                self.name = listing.name
            }
            
            TextField(text: $location, prompt: Text("Location")) {
                Text("Ex. 111 First St, Los Angeles, CA 90007")
            }
            .padding()
            .background(Color(red: 220/256, green: 220/256, blue: 220/256))
            .cornerRadius(25)
            .onAppear() {
                self.location = listing.location
            }
            
            TextField(text: $description, prompt: Text("Description")) {
                Text("Event Description")
            }
            .onAppear() {
                self.description = listing.description
            }
            .padding()
            .background(Color(red: 220/256, green: 220/256, blue: 220/256))
            .cornerRadius(25)
            
            Button {
                
            } label: {
                Text("Save")
            }
            .buttonStyle(.bordered)
            .cornerRadius(25)
            .tint(.green)
        }
        .padding()
        
    }
}

struct ViewListingEditView_Previews: PreviewProvider {
    @State static var test: Listing = Listing()
    @State static var test3: Bool = true
    static var previews: some View {
        ViewListingEditView(listing: $test, isEditing: $test3)
    }
}
