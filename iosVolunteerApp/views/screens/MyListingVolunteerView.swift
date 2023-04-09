import SwiftUI

struct MyListingVolunteerView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Binding var user: User
    @Binding var navigationManager: SideBarNavigationManager

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
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Text(listing.description)
                                        .font(.body)
                                        .fontWeight(.regular)
                                }
                                .padding()
                            }
                        }
                        
                    }
                    .refreshable {
                        firestoreManager.fetchListingsUser()
                    }
                }
                .navigationTitle("Favorites")
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
    }
}

struct MyListingVolunteerView_Previews: PreviewProvider {
    @State static var testUser: User = User()
    @State static var navigationManager: SideBarNavigationManager = SideBarNavigationManager()
    static var previews: some View {
        MyListingVolunteerView(user: $testUser, navigationManager: $navigationManager)
            .environmentObject(FirestoreManager())
    }
}
