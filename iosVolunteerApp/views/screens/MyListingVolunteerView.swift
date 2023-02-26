import SwiftUI

struct MyListingVolunteerView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager

    var body: some View {
        ZStack {
            NavigationView {
                VStack {
                    Text("test")

                }
                .navigationBarTitle("My Listings V", displayMode: .large)
                
            }
            .buttonStyle(.bordered)
            .font(.headline.bold())
            
        }
        
    }
}

struct MyListingVolunteerView_Previews: PreviewProvider {
    static var previews: some View {
        MyListingVolunteerView()
            .environmentObject(FirestoreManager())
    }
}
