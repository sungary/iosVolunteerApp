import SwiftUI

struct MenuItem: Identifiable {
    var id: Int
    var icon: String
    var text: String
    var view: ViewTypes
}

var menuData: [MenuItem] = [
    MenuItem(id:0, icon: "house", text: "Home", view: .home),
    MenuItem(id:1, icon: "books.vertical", text: "My Listings", view: .myListing),
    MenuItem(id:2, icon: "gearshape", text: "Settings", view: .settings),
    MenuItem(id:3, icon: "gearshape", text: "Sign Out", view: .signOut)
]

struct SideBar: View {
    @Binding var navigationManager: SideBarNavigationManager
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.55
    var backgroundColor: Color = Color.blue
    
    var body: some View {
        let _ = print(navigationManager.isSideBarVisable)
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(.black.opacity(0.75))
            .opacity(navigationManager.isSideBarVisable ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: navigationManager.isSideBarVisable)
            .onTapGesture {
                navigationManager.isSideBarVisable.toggle()
            }
            displaySideBar
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var displaySideBar: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .top) {
                backgroundColor
                VStack(alignment: .leading, spacing: 20) {
                    sidebarContent
                }
            }
            .frame(width: sideBarWidth)
            .offset(x: navigationManager.isSideBarVisable ? 0 : -sideBarWidth)
            .animation(.default, value: navigationManager.isSideBarVisable)
            Spacer()
        }
    }
    
    var sidebarContent: some View {
        
        VStack(alignment: .leading, spacing: 25) {
            ForEach(menuData) { item in
                menuLink(icon: item.icon, text: item.text, view: item.view, navigationManager: $navigationManager)
            }
        }
        .padding(.top, 100)
        
    }
}


struct menuLink: View {
    var icon: String
    var text: String
    var view: ViewTypes
    @Binding var navigationManager: SideBarNavigationManager
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(Color.white)
                .padding(.trailing, 20)
            Text(text)
                .foregroundColor(Color.white)
                .font(.body)
        }
        .onTapGesture {
            navigationManager.viewType = view
            navigationManager.isSideBarVisable.toggle()
        }
    }
}


struct SideBar_Previews: PreviewProvider {
    @State static var navigationManager: SideBarNavigationManager = SideBarNavigationManager()
    static var previews: some View {
        SideBar(navigationManager: $navigationManager)
    }
}
