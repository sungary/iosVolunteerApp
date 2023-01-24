import SwiftUI

struct MenuItem: Identifiable {
    var id: Int
    var icon: String
    var text: String
    var view: ViewTypes
}

var menuData: [MenuItem] = [
    MenuItem(id:0, icon: "house", text: "Home", view: .home),
    MenuItem(id:1, icon: "books.vertical", text: "Collections", view: .myTemp),
    MenuItem(id:2, icon: "gearshape", text: "Settings", view: .settings)
]

struct SideBar: View {
    @Binding var isSideBarVisible: Bool
    var navigationManager: SideBarNavigationManager
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.7
    var backgroundColor: Color = Color.blue
    
    var body: some View {
        
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(.black.opacity(0.75))
            .opacity(isSideBarVisible ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: isSideBarVisible)
            .onTapGesture {
                isSideBarVisible.toggle()
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
            .offset(x: isSideBarVisible ? 0 : -sideBarWidth)
            .animation(.default, value: isSideBarVisible)
            Spacer()
        }
    }
    
    var sidebarContent: some View {
        
        VStack(alignment: .leading, spacing: 25) {
            ForEach(menuData) { item in
                menuLink(icon: item.icon, text: item.text, view: item.view, navigationManager: navigationManager, isSideBarVisible: self.$isSideBarVisible)
            }
        }
        .padding(.top, 100)
        
    }
}


struct menuLink: View {
    var icon: String
    var text: String
    var view: ViewTypes
    var navigationManager: SideBarNavigationManager
    @Binding var isSideBarVisible: Bool
    
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
            isSideBarVisible.toggle()
        }
    }
}


struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar(isSideBarVisible: .constant(true), navigationManager: SideBarNavigationManager())
    }
}
