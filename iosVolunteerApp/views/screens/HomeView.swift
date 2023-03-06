import SwiftUI

struct HomeView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Binding var user: User
    @Binding var navigationManager: SideBarNavigationManager
    
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
                    .onAppear() {
                        firestoreManager.fetchListingsAll()
                    }
                    .refreshable {
                        firestoreManager.fetchListingsAll()
                    }
                }
                .navigationBarTitle("Home", displayMode: .automatic)
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
    }
}

struct HomeView_Previews: PreviewProvider {
    @State static var testUser: User = User()
    @State static var navigationManager: SideBarNavigationManager = SideBarNavigationManager()
    static var previews: some View {
        HomeView(user: $testUser, navigationManager: $navigationManager)
            .environmentObject(FirestoreManager())
    }
}
