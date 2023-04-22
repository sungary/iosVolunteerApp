import SwiftUI

struct MyListingVolunteerView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Binding var user: User
    @Binding var navigationManager: SideBarNavigationManager
    @State private var buttonDisabled = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    List(firestoreManager.myListings) { listing in
                        NavigationLink(destination: ViewListingView(listing: listing)) {
                            HStack {
                                Button {
                                    buttonDisabled = true
                                    
                                    switch listing.favorited {
                                    case true:
                                        let results: (String) -> Void = { result in
                                            if(result == "success"){
                                                
                                            } else if(result != ""){
                                                
                                            }
                                            buttonDisabled = false
                                        }
                                        firestoreManager.removeMyFavorites(listingID: listing.id, completionHandler: results)
                                    case false:
                                        let results: (String) -> Void = { result in
                                            if(result == "success"){
                                                
                                            } else if(result != ""){
                                                
                                            }
                                            buttonDisabled = false
                                        }
                                        firestoreManager.addMyFavorites(listingID: listing.id, completionHandler: results)
                                    }
                                } label: {
                                    Label("Favorite", systemImage: listing.favorited ? "star.fill": "star")
                                        .labelStyle(.iconOnly)
                                }
                                .buttonStyle(.borderless)
                                .disabled(buttonDisabled)
                                
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
