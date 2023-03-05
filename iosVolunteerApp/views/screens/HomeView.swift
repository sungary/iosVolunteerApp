import SwiftUI

struct HomeView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @State var user: User
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
                                    Text(listing.description)
                                }
                                .padding()
                            }
                        }
                        
                    }
//                    .onAppear(){
//                        self.firestoreManager.fetchListingsAll()
//                        //self.firestoreManager.fetchListingsUser(currentUserID: user.id)
//                    }
                    .refreshable {
                        self.firestoreManager.fetchListingsAll()
                    }
                }
                
            }
            .navigationBarTitle("Home", displayMode: .automatic)
            .buttonStyle(.bordered)
            .font(.headline.bold())
            
        }
        
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var testUser: User = User()
    static var previews: some View {
        HomeView(user: testUser)
            .environmentObject(FirestoreManager())
    }
}
