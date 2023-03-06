import SwiftUI

struct ContentView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State var navigationManager: SideBarNavigationManager = SideBarNavigationManager()
    
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
                            HomeView(user: $user, navigationManager: $navigationManager)
                        case .myListing:
                            switch user.type {
                            case "V":
                                MyListingVolunteerView()
                            case "O":
                                MyListingOrganizationView(user: $user, navigationManager: $navigationManager)
                            default:
                                ErrorView()
                            }
                        case .settings:
                            Text("test")
                        case .signOut:
                            SignOutView(user: $user, navigationManager: self.$navigationManager)
                        case .error:
                            ErrorView()
                        }
                    }
                }
            }
            SideBar(navigationManager: self.$navigationManager)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FirestoreManager())
    }
}
