//
//  FirestoreManager.swift
//  iosVolunteer
//
//  Created by Gary Sun on 1/23/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

class FirestoreManager: ObservableObject {
    
    @Published var listings = [Listing]()
    
    func fetchListings() {
        let db = Firestore.firestore()
        
        db.collection("listings").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            self.listings = documents.map{ (queryDocumentSnapshot) -> Listing in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let sDescription = data["sDescription"] as? String ?? ""
                let lDescription = data["lDescription"] as? String ?? ""
                
                return Listing(name: name, sDescription: sDescription, lDescription: lDescription)
            }
        }
    }
    
    @MainActor
    func createNewUser(email: String, password: String, fname: String, lname: String, type: String) async -> String {
        var result = ""
        
        // check if user has inputed requried fields
        if(email != "" && password != "" && fname != "" && lname != "" && type != ""){
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                let tempUser = authResult.user
                
                if(tempUser.uid != ""){
                    let user = User(id: tempUser.uid, email: tempUser.email ?? "", fname: fname, lname: lname, type: type, isSignedIn: false)
                    Task {
                        createNewUserInfo(user: user)
                    }
                    result = "success"
                } else {
                    result = "error"
                }
            }
            catch {
                //print("error with creating user")
                result = "error"
            }
        } else {
            return "error"
        }
        return result
    }
    
    //create a new document for the new user
    func createNewUserInfo(user: User) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(user.id)
        docRef.setData(["email": user.email, "fname": user.fname, "lname": user.lname, "type": user.type]) { error in
            if(error != nil){
                //print("error")
            } else {
                //print("success")
            }
        }
        
        
    }
    
    @MainActor
    func signIn(email: String, password: String) async -> User {
        
        var user = User(id: "", email: "", fname: "", lname: "", type: "", isSignedIn: false)
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            do {
                let document = try await Firestore.firestore().collection("users").document(authResult.user.uid).getDocument()
                let data = document.data()
                if(data != nil){
                    user = User(
                        id: authResult.user.uid,
                        email: data?["email"] as? String ?? "",
                        fname: data?["fname"] as? String ?? "",
                        lname: data?["lname"] as? String ?? "",
                        type: data?["type"] as? String ?? "",
                        isSignedIn: true
                    )
                }
            }
            catch {
                print("Error Getting User Data", error.localizedDescription)
            }
        }
        catch {
            print("Error Signing In", error.localizedDescription)
        }
        return user
    }
    
    func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
