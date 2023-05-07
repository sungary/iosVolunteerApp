import SwiftUI

enum ViewTypes {
    case home
    case myListing
    case settings
    case profile
    case signOut
    case error
}

struct SideBarNavigationManager {
    var viewType: ViewTypes = .home
    var isSideBarVisable: Bool = false
}

