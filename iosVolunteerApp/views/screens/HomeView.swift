//
//  HomeView.swift
//  CollectorApp
//
//  Created by Gary Sun on 1/15/23.
//

import SwiftUI

struct HomeView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Listing>
    
    @State private var isAddOverlay = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    List(items){ item in
                        HStack(alignment: .center, spacing: nil) {
                            Image(systemName: "star")
                                .padding(.leading,10)
                            VStack(alignment: .leading, spacing: nil) {
                                Text(item.name ?? "default name")
                                    .font(.headline)
                            }
                            .padding()
                            
                        }
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
    }
}
