import SwiftUI

struct MyListingOrganizationView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Binding var user: User
    @Binding var navigationManager: SideBarNavigationManager

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    List(firestoreManager.myListings) { listing in
                        NavigationLink(destination: ViewMyListingView(listing: listing)) {
                            HStack {
                                
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
                .navigationTitle("My Listings")
                .navigationBarTitleDisplayMode(.automatic)
                .buttonStyle(.bordered)
                .font(.headline.bold())
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading){
                        NavigationLink(destination: AddListingView(userID: user.id)){
                            Text("Add Listing")
                        }
                        .buttonStyle(.bordered)
                        .cornerRadius(25)
                        .tint(.blue)
                    }
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

struct MyListingOrganizationView_Previews: PreviewProvider {
    @State static var testUser: User = User()
    @State static var navigationManager: SideBarNavigationManager = SideBarNavigationManager()
    static var previews: some View {
        MyListingOrganizationView(user: $testUser, navigationManager: $navigationManager)
            .environmentObject(FirestoreManager())
    }
}
