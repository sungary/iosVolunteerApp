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
        do {
            let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
            let user = authResult.user
            result = "success"
        }
        catch {
            //print("error with creating user")
            result = "error"
        }
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            if(error != nil){
//                //print(error?.localizedDescription ?? "")
//                result = error?.localizedDescription ?? ""
//            } else {
//                print("success")
//                result = "success"
//            }
//        }
        return result
    }
    
    func signIn(email: String, password: String) -> String {
        
        
        var result = ""
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
//            guard let strongSelf = self else { return }
            if(error != nil){
                //print(error?.localizedDescription ?? "")
                result = error?.localizedDescription ?? ""
            } else {
                //print("success")
                result = "success"
            }
        }
        
        return result
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
