import SwiftUI

struct ContentView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State private var isSideBarVisible = false
    @ObservedObject var navigationManager: SideBarNavigationManager =  SideBarNavigationManager()
    
    @State private var user: User = User(id: "", email: "", fname: "", lname: "", type: "", isSignedIn: false)
    
    var body: some View {
        
        ZStack {
            NavigationView{
                switch user.isSignedIn {
                case false:
                    LoginView(user: $user)
                case true:
                    VStack {
                        switch navigationManager.viewType{
                        case .home:
                            HomeView()
                        case .myListing:
                            switch user.type {
                            case "V":
                                MyListingVolunteerView()
                            case "O":
                                MyListingOrganizationView()
                            default:
                                ErrorView()
                            }
                            
                        case .settings:
                            Text("test")
                        case .signOut:
                            SignOutView(user: $user, isSideBarVisible: self.$isSideBarVisible, navigationManager: self.navigationManager)
                        }
                    }
                    .navigationBarItems(
                        trailing:
                            Button {
                                isSideBarVisible.toggle()
                            } label: {
                                Label("Toggle SideBar", systemImage: "line.3.horizontal")
                            }
                    )
                }
            }
            SideBar(isSideBarVisible: self.$isSideBarVisible, navigationManager: self.navigationManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FirestoreManager())
    }
}
