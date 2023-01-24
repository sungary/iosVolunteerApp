//
//  HomeView.swift
//  CollectorApp
//
//  Created by Gary Sun on 1/15/23.
//

import SwiftUI


struct HomeView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager

    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    List(firestoreManager.listings) { listing in
                        HStack {
                            Image(systemName: "star")
                                .padding(.leading,15)
                            VStack(alignment: .leading) {
                                Text(listing.name)
                                Text(listing.sDescription)
                            }
                            .padding()
                        }
                    }
                    .onAppear(){
                        self.firestoreManager.fetchListings()
                    }
                    .refreshable {
                        self.firestoreManager.fetchListings()
                    }

                }
                .navigationBarTitle("Home", displayMode: .large)
                
            }
            .buttonStyle(.bordered)
            .font(.headline.bold())
            
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(FirestoreManager())
    }
}
