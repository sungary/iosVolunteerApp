//
//  ViewListingEditView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 3/19/23.
//

import SwiftUI

struct ViewListingEditView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @Binding var listing: Listing
    @Binding var isEditing: Bool
    @State var name: String = ""
    @State var location: String = ""
    @State var description: String = ""
    @State private var showAlert = false
    enum AlertType {
        case successDelete
        case successUpdate
        case error
    }
    @State private var alertType: AlertType?
    @State private var buttonDisabled = false
    
    var body: some View {
        VStack {
            Button {
                buttonDisabled = true
                
                let results: (String) -> Void = { result in
                    if(result == "success"){
                        showAlert = true
                        alertType = .successDelete
                    } else if(result != ""){
                        showAlert = true
                        alertType = .error
                    }
                    buttonDisabled = false
                }
                
                firestoreManager.deleteListing(listingID: listing.id, completionHandler: results)
                
            } label: {
                Text("Delete")
            }
            .buttonStyle(.bordered)
            .cornerRadius(25)
            .tint(.red)
            .disabled(buttonDisabled)
            .alert(isPresented: $showAlert){
                getPresentAlert()
            }
            
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
                buttonDisabled = true
                
                listing.name = name
                listing.description = description
                listing.location = location
                
                let results: (String) -> Void = { result in
                    if(result == "success"){
                        showAlert = true
                        alertType = .successUpdate
                    } else if(result != ""){
                        showAlert = true
                        alertType = .error
                    }
                    buttonDisabled = false
                }
                
                firestoreManager.updateListing(myListing: listing, completionHandler: results)
                
            } label: {
                Text("Save")
            }
            .buttonStyle(.bordered)
            .cornerRadius(25)
            .tint(.green)
            .disabled(buttonDisabled)
            .alert(isPresented: $showAlert){
                getPresentAlert()
            }
        }
        .padding()
        
    }
    
    func getPresentAlert() -> Alert {
        switch alertType {
        case .successDelete:
            return Alert(
                title: Text("Listing Deleted"),
                dismissButton: Alert.Button.default(
                    Text("OK"),
                    action: {
                        showAlert = false
                        isEditing = false
                        dismiss()
                    })
            )
        case .successUpdate:
            return Alert(
                title: Text("Listing Updated"),
                dismissButton: Alert.Button.default(
                    Text("OK"),
                    action: {
                        isEditing = false
                        showAlert = false
                    })
            )
        case .error:
            return Alert(
                title: Text("Error"),
                message: Text("Please try again"),
                dismissButton: Alert.Button.default(
                    Text("OK"),
                    action: {
                        showAlert = false
                    })
            )
        case .none:
            return Alert(
                title: Text("Error"),
                dismissButton: Alert.Button.default(
                    Text("Close"),
                    action: {
                        showAlert = false
                    })
            )
        }
    }
}

struct ViewListingEditView_Previews: PreviewProvider {
    @State static var test: Listing = Listing()
    @State static var test3: Bool = true
    static var previews: some View {
        ViewListingEditView(listing: $test, isEditing: $test3)
    }
}
