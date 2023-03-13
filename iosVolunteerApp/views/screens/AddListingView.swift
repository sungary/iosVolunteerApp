//
//  AddListingView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 3/4/23.
//

import SwiftUI

struct AddListingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State var userID: String
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    
    @State private var showAlert = false
    enum AlertType {
        case success
        case error
    }
    @State private var alertType: AlertType?
    @State private var buttonDisabled = false
    
    var body: some View {
        VStack() {
            VStack(){
                Text("Create New Listing")
                    .font(.largeTitle)
                    .bold()
                
                TextField(text: $name, prompt: Text("Name")) {
                    Text("Event Name")
                }
                .padding()
                .background(Color(red: 220/256, green: 220/256, blue: 220/256))
                .cornerRadius(25)
                
                
                TextField(text: $location, prompt: Text("Location")) {
                    Text("Ex. 111 First St, Los Angeles, CA 90007")
                }
                .padding()
                .background(Color(red: 220/256, green: 220/256, blue: 220/256))
                .cornerRadius(25)
                
                TextField(text: $description, prompt: Text("Description")) {
                    Text("Event Description")
                }
                .padding()
                .background(Color(red: 220/256, green: 220/256, blue: 220/256))
                .cornerRadius(25)
                
                Button(action: {
                    buttonDisabled = true
                    var temp = ""
                    //DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        Task {
                            await firestoreManager.createNewListing(createdBy: userID, name: name, location: location, description: description)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                                let _ = print("test3 " + temp)
                                if(temp == "success"){
                                    showAlert = true
                                    alertType = .success
                                } else if(temp != ""){
                                    showAlert = true
                                    alertType = .error
                                }
                                buttonDisabled = false
                            }
                            
                        }
                    //}
                }) {
                    Text("Add Listing")
                }
                .disabled(buttonDisabled)
                .padding()
                .buttonStyle(.bordered)
                .cornerRadius(25)
                .tint(.green)
                .alert(isPresented: $showAlert){
                    getPresentAlert()
                }
            }
            .padding()
        }
    }
    
    func getPresentAlert() -> Alert {
        switch alertType {
        case .success:
            return Alert(
                title: Text("Listing Created"),
                dismissButton: Alert.Button.default(
                    Text("Back to my Listings"),
                    action: {
                        showAlert = false
                        dismiss()
                    })
            )
        case .error:
            return Alert(
                title: Text("Error"),
                message: Text("Please check all fields and try again"),
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

struct AddListingView_Previews: PreviewProvider {
    static var previews: some View {
        AddListingView(userID: "test")
    }
}
