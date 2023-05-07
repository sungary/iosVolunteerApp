//
//  ViewListingVolunteerView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 4/23/23.
//

import SwiftUI

struct ViewListingVolunteerView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    let listing: Listing
    let user: User
    
    @State private var showAlert = false
    enum AlertType {
        case success
        case error
    }
    @State private var alertType: AlertType?
    @State private var buttonDisabled = false
    @State private var isInterested = false
    
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
            
            Button(action: {
                buttonDisabled = true
                switch self.isInterested {
                case true:
                    let results: (String) -> Void = { result in
                        if(result == "success"){
                            isInterested = false
                        } else if(result != ""){
                            
                        }
                        buttonDisabled = false
                    }
                    firestoreManager.removeInterest(listingID: listing.id, userID: user.id, completionHandler: results)
                case false:
                    let results: (String) -> Void = { result in
                        if(result == "success"){
                            isInterested = true
                        } else if(result != ""){
                            
                        }
                        buttonDisabled = false
                    }
                    firestoreManager.sendInterest(listingID: listing.id, userID: user.id, completionHandler: results)
                    
                }
            }) {
                if (self.isInterested) {
                    Text("Remove Interest")
                } else {
                    Text("Send Interest")
                }
            }
            .disabled(buttonDisabled)
            .padding()
            .buttonStyle(.bordered)
            .cornerRadius(25)
            .tint(.green)
            .alert(isPresented: $showAlert){
                getPresentAlert()
            }
            .onAppear(){
                let results: (String) -> Void = { result in
                    if(result == "success"){
                        self.isInterested = true
                    } else if(result != ""){
                        self.isInterested = false
                    }
                }
                firestoreManager.checkInterest(listingID: listing.id, userID: user.id, completionHandler: results)
            }
        }
        
    }
    
    func getPresentAlert() -> Alert {
        switch alertType {
        case .success:
            return Alert(
                title: Text("Interest Sent"),
                dismissButton: Alert.Button.default(
                    Text("Back to my Listings"),
                    action: {
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
                message: Text("Please try again"),
                dismissButton: Alert.Button.default(
                    Text("OK"),
                    action: {
                        showAlert = false
                    })
            )
        }
    }
}

struct ViewListingVolunteerView_Previews: PreviewProvider {
    @State static var user: User = User()
    @State static var listing: Listing = Listing()
    static var previews: some View {
        ViewListingVolunteerView(listing: listing, user: user)
    }
}
