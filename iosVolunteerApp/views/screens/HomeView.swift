import SwiftUI

struct HomeView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    List(firestoreManager.allListings) { listing in
                        NavigationLink(destination: ViewListingView(listing: listing)) {
                            HStack {
                                Button {
                                } label: {
                                    Label("Favorite", systemImage: "star")
                                        .labelStyle(.iconOnly)
                                }
                                .buttonStyle(.borderless)

                                VStack(alignment: .leading) {
                                    Text(listing.name)
                                    Text(listing.sDescription)
                                }
                                .padding()
                            }
                        }
                        
                    }
                    .onAppear(){
                        self.firestoreManager.fetchListingsAll()
                    }
                    .refreshable {
                        self.firestoreManager.fetchListingsAll()
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
