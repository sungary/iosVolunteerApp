import SwiftUI

struct MyListingOrganizationView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Binding var user: User
    
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
                                    Text(listing.description)
                                }
                                .padding()
                            }
                        }
                    }
                    .refreshable {
                        self.firestoreManager.fetchListingsAll()
                    }
                }
                
            }
            .navigationTitle("My Listings")
            .navigationBarTitleDisplayMode(.automatic)
            .buttonStyle(.bordered)
            .font(.headline.bold())
            .toolbar {
                NavigationLink(destination: AddListingView()){
                    Text("Add Listing")
                }
                .buttonStyle(.bordered)
                .cornerRadius(25)
                .tint(.blue)
                
            }
        }
        
    }
}

struct MyListingOrganizationView_Previews: PreviewProvider {
    @State static var testUser: User = User()
    static var previews: some View {
        MyListingOrganizationView(user: $testUser)
            .environmentObject(FirestoreManager())
    }
}
