//
//  SignUpView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 2/4/23.
//

import SwiftUI

struct SignUpView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var fname: String = ""
    @State private var lname: String = ""
    @State private var type: String = ""
    
    @State private var showAlert = false
    enum AlertType {
        case success
        case error
    }
    @State private var alertType: AlertType?
    @State private var buttonDisabled = false

    var body: some View {
        VStack(){
            Text("Sign Up")
                .font(.largeTitle)
                .bold()
            
            TextField(text: $email, prompt: Text("Email")) {
                Text("Email")
            }
                .padding()
                .background(Color(red: 220/256, green: 220/256, blue: 220/256))
                .cornerRadius(25)
            SecureField(text: $password, prompt: Text("Password")) {
                Text("Password")
            }
                .padding()
                .background(Color(red: 220/256, green: 220/256, blue: 220/256))
                .cornerRadius(25)
            
            HStack(alignment: .center, spacing: nil){
                TextField(text: $fname) {
                    Text("First Name")
                }
                    .padding()
                    .background(Color(red: 220/256, green: 220/256, blue: 220/256))
                    .cornerRadius(25)
                TextField(text: $lname) {
                    Text("Last Name")
                }
                    .padding()
                    .background(Color(red: 220/256, green: 220/256, blue: 220/256))
                    .cornerRadius(25)
                
            }
            
            Picker("Type", selection: $type){
                Text("Volunteer").tag("V")
                Text("Organization").tag("N")
            }
            .padding()
            .pickerStyle(.segmented)
            
            Button(action: {
                buttonDisabled = true
                var temp = ""
                Task {
                    temp = await firestoreManager.createNewUser(email: email, password: password, fname: fname, lname: lname, type: type)

                    if(temp == "success"){
                        showAlert = true
                        alertType = .success
                    } else if(temp != ""){
                        showAlert = true
                        alertType = .error
                    }
                    buttonDisabled = false
                }
            }) {
                Text("Sign Up")
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
    
    func getPresentAlert() -> Alert {
        switch alertType {
        case .success:
            return Alert(
                title: Text("Account Created"),
                dismissButton: Alert.Button.default(
                    Text("Back to Sign In"),
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



struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(FirestoreManager())
    }
}
