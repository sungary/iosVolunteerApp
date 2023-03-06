//
//  SignOutView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 2/26/23.
//

import SwiftUI

struct SignOutView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Binding var user: User
    @Binding var navigationManager: SideBarNavigationManager
    
    var body: some View {
        VStack() {
            Text("Signning Out")
        }
        .onAppear {
            signOut()
        }
    }
    
    func signOut(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            Task {
                user = await firestoreManager.signOut()
                navigationManager.viewType = .home
            }
        }
    }
}

struct SignOutView_Previews: PreviewProvider {
    @State static var testUser: User = User()
    @State static var navigationManager: SideBarNavigationManager = SideBarNavigationManager()
    static var previews: some View {
        SignOutView(user: $testUser, navigationManager: $navigationManager)
            .environmentObject(FirestoreManager())
    }
}
