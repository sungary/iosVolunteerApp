import SwiftUI

enum ViewTypes {
    case home
    case myListing
    case settings
    case signOut
}

class SideBarNavigationManager : ObservableObject {
    @Published var viewType: ViewTypes = .home
}

