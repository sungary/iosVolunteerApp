import SwiftUI

enum ViewTypes {
    case home
    case myTemp
    case settings
}

class SideBarNavigationManager : ObservableObject {
    @Published var viewType: ViewTypes = .home
}

