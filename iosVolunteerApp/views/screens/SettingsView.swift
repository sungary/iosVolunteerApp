//
//  SettingsView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 5/7/23.
//

import SwiftUI

struct SettingsView: View {
    @Binding var navigationManager: SideBarNavigationManager
    
    var body: some View {
        VStack(){
            Text("Settings")
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.automatic)
        .buttonStyle(.bordered)
        .font(.headline.bold())
        .toolbar {
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
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    @State static var navigationManager: SideBarNavigationManager = SideBarNavigationManager()
    static var previews: some View {
        SettingsView(navigationManager: $navigationManager)
    }
}
