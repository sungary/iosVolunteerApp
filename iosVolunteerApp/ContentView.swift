//
//  ContentView.swift
//  iosVolunteerApp
//
//  Created by Gary Sun on 1/14/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State private var isSideBarOpen = false
    @ObservedObject var navigationManager: SideBarNavigationManager =  SideBarNavigationManager()
    
    @State var isLoggedIn: Bool = false
    
    var body: some View {
        
        ZStack {
            if(!isLoggedIn){
                LoginView()
            } else {
                NavigationView {
                    VStack {
                        switch navigationManager.viewType{
                        case .home:
                            HomeView()
                        case .myTemp:
                            Text("test 1")
                        case .settings:
                            Text("test")
                        }
                    }
                    .navigationBarItems(
                        trailing:
                            Button {
                                isSideBarOpen.toggle()
                            } label: {
                                Label("Toggle SideBar", systemImage: "line.3.horizontal")
                            }
                    )
                }
                SideBar(isSideBarVisible: self.$isSideBarOpen, navigationManager: self.navigationManager)
            }
        }
            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FirestoreManager())
    }
}
