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
    
    var body: some View {
        
        ZStack {
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
//            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
//                .onEnded({ value in
//                    if(value.translation.width > 0){
//                        isSideBarOpen.toggle()
//                    }
//                }))
            SideBar(isSideBarVisible: self.$isSideBarOpen, navigationManager: self.navigationManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FirestoreManager())
    }
}
