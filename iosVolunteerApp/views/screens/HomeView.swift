import SwiftUI

struct HomeView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Binding var user: User
    @Binding var navigationManager: SideBarNavigationManager
    @State private var buttonDisabled = false
    
    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    switch user.type {
                    case "O":
                        List(firestoreManager.allListings) { listing in
                            NavigationLink(destination: ViewListingView(listing: listing)) {
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
                            firestoreManager.fetchListingsAll()
                        }
                    case "V":
                        List(firestoreManager.allListings) { listing in
                            NavigationLink(destination: ViewListingVolunteerView(listing: listing, user: user)) {
                                HStack {
                                    Button {
                                        buttonDisabled = true
                                        
                                        switch listing.favorited {
                                        case true:
                                            let results: (String) -> Void = { result in
                                                if(result == "success"){
                                                    
                                                    let resultOfCheck: (String) -> Void = { result2 in
                                                        if (result2 == "success"){
                                                            let resultOfRemove: (String) -> Void = { result3 in
                                                                if (result3 == "success"){
                                                                    
                                                                } else {
                                                                    
                                                                }
                                                                
                                                            }
                                                            firestoreManager.removeInterest(listingID: listing.id, userID: user.id, completionHandler: resultOfRemove)
                                                        } else {
                                                            
                                                        }
                                                    }
                                                    
                                                    firestoreManager.checkInterest(listingID: listing.id, userID: user.id, completionHandler: resultOfCheck)
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
                            firestoreManager.fetchListingsAll()
                        }
                    default:
                        VStack {
                            Text("Error, shouldn't be here")
                        }
                        
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
