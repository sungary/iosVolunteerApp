import SwiftUI

struct MyListingOrganizationView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    List(firestoreManager.myListings) { listing in
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
                .navigationBarTitle("My Listings O", displayMode: .large)
                
            }
            .buttonStyle(.bordered)
            .font(.headline.bold())
            
        }
        
    }
}
struct MyListingOrganizationView_Previews: PreviewProvider {
    static var previews: some View {
        MyListingOrganizationView()
            .environmentObject(FirestoreManager())
    }
}
