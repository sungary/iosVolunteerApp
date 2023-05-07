//
//  PasswordResetView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 5/7/23.
//

import SwiftUI

struct PasswordResetView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State private var email: String = ""
    
    @State private var showAlert = false
    enum AlertType {
        case success
        case error
    }
    @State private var alertType: AlertType?
    @State private var buttonDisabled = false
    
    
    var body: some View {
        VStack() {
            Text("Forgot Password")
                .font(.largeTitle)
                .bold()
            
            TextField(text: $email, prompt: Text("Email")) {
                Text("Email")
            }
            .padding()
            .background(Color(red: 220/256, green: 220/256, blue: 220/256))
            .cornerRadius(25)
            
            Button(action: {
                buttonDisabled = true
                
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
                
                firestoreManager.sendResetPasswordEmail(email: email, completionHandler: results)
            }) {
                Text("Send Reset Link")
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
        .padding(.bottom, 200)
    }
    
    func getPresentAlert() -> Alert {
        switch alertType {
        case .success:
            return Alert(
                title: Text("Email is sent"),
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
                message: Text("Please check your email and try again"),
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

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
