//
//  FirestoreManager.swift
//  iosVolunteer
//
//  Created by Gary Sun on 1/23/23.
//

import SwiftUI
import Firebase

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
}
