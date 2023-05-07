//
//  ProfileView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 5/7/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Binding var user: User
    @Binding var navigationManager: SideBarNavigationManager
    
    var body: some View {
        VStack() {
            
            HStack(alignment: .center, spacing: nil){
                Text(user.fname)
                Text(user.lname)
            }
            Text(user.email)

        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.automatic)
        .buttonStyle(.bordered)
        .font(.headline.bold())
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                NavigationLink(destination: UpdateProfileView(user: $user)){
                    Text("Edit")
                }
                .buttonStyle(.bordered)
                .cornerRadius(25)
                .tint(.blue)
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    navigationManager.isSideBarVisable.toggle()
                } label: {
                    Label("Toggle SideBar", systemImage: "line.3.horizontal")
                }
                .buttonStyle(.bordered)
                .cornerRadius(25)
                .tint(.blue)
            }
        }
        .padding()
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var testUser: User = User()
    @State static var navigationManager: SideBarNavigationManager = SideBarNavigationManager()
    static var previews: some View {
        ProfileView(user: $testUser, navigationManager: $navigationManager)
            .environmentObject(FirestoreManager())
    }
}
