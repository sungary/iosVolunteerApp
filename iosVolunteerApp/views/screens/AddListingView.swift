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
    @State private var timeStart: Date = Date()
    @State private var timeEnd: Date = Date()
    
    @State private var showAlert = false
    enum AlertType {
        case success
        case error
        case errorTime
    }
    @State private var alertType: AlertType?
    @State private var buttonDisabled = false
    
    var body: some View {
        
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
            
            DatePicker(
                "Start Date & Time",
                selection: $timeStart,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.automatic)
            
            DatePicker(
                "End Date & Time",
                selection: $timeEnd,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.automatic)
            
            TextField(text: $description, prompt: Text("Description")) {
                Text("Event Description")
            }
            .padding()
            .background(Color(red: 220/256, green: 220/256, blue: 220/256))
            .cornerRadius(25)
            
            Button(action: {
                
                // check time start and end logic
                if(timeStart < timeEnd){
                    buttonDisabled = true
                    // completion handler: once the createNewListing is done, run the below
                    let results: (String) -> Void = { result in
                        if(result == "success"){
                            showAlert = true
                            alertType = .success
                        } else if(result != ""){
                            showAlert = true
                            alertType = .error
                        }
                        buttonDisabled = false
                    }
                    // calls createNewListing function to add new listing the results of this will be in completion Handler results
                    firestoreManager.createNewListing(createdBy: userID, name: name, location: location, description: description, timeStart: timeStart, timeEnd: timeEnd, completionHandler: results)
                } else {
                    showAlert = true
                    alertType = .errorTime
                }
                
                
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
        .navigationBarBackButtonHidden(buttonDisabled)
        
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
        case .errorTime:
            return Alert(
                title: Text("Error"),
                message: Text("Please check your Start/End Times"),
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
