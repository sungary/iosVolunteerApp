//
//  iosVolunteerAppApp.swift
//  iosVolunteerApp
//
//  Created by Gary Sun on 1/14/23.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

@main
struct iosVolunteerAppApp: App {
    @StateObject var firestoreManager = FirestoreManager()
    //@ObservedObject var navigationManager: SideBarNavigationManager =  SideBarNavigationManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firestoreManager)
        }
    }
}
