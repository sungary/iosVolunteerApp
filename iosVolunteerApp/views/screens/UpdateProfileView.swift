//
//  UpdateProfileView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 5/7/23.
//

import SwiftUI

struct UpdateProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreManager: FirestoreManager

    @Binding var user: User
    @State var fname: String = ""
    @State var lname: String = ""
    @State var email: String = ""
    
    enum AlertType {
        case successDelete
        case successUpdate
        case error
    }
    @State private var alertType: AlertType?
    @State private var buttonDisabled = false
    @State var showAlert = false
    
    var body: some View {
        VStack() {
            Text("Update Profile")
                .font(.largeTitle)
                .bold()
            
            HStack(alignment: .center, spacing: nil){
                TextField(text: $fname, prompt: Text("First Name")) {
                    Text("First Name")
                }
                .padding()
                .background(Color(red: 220/256, green: 220/256, blue: 220/256))
                .cornerRadius(25)
                .onAppear() {
                    self.fname = user.fname
                }
                TextField(text: $lname, prompt: Text("Last Name")) {
                    Text("Last Name")
                }
                .padding()
                .background(Color(red: 220/256, green: 220/256, blue: 220/256))
                .cornerRadius(25)
                .onAppear() {
                    self.lname = user.lname
                }
            }
            
            TextField(text: $email, prompt: Text("Email")) {
                Text("Email")
            }
            .padding()
            .background(Color(red: 220/256, green: 220/256, blue: 220/256))
            .cornerRadius(25)
            .onAppear() {
                self.email = user.email
            }
            
            Button {
                print("test")
                //                let results: (String) -> Void = { result in
                //                    if(result == "success"){
                //                        showAlert = true
                //                        alertType = .successUpdate
                //                    } else if(result != ""){
                //                        showAlert = true
                //                        alertType = .error
                //                    }
                //                    buttonDisabled = false
                //                }
                
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
                        //isEditing = false
                        dismiss()
                    })
            )
        case .successUpdate:
            return Alert(
                title: Text("Listing Updated"),
                dismissButton: Alert.Button.default(
                    Text("OK"),
                    action: {
                        //isEditing = false
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

struct UpdateProfileView_Previews: PreviewProvider {
    @State static var user = User(id: "", email: "", fname: "", lname: "", type: "", myListings: [] as [String], isSignedIn: false)
    @State static var test3: Bool = true
    static var previews: some View {
        UpdateProfileView(user: $user)
            .environmentObject(FirestoreManager())
        
    }
}
