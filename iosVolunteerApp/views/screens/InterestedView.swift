//
//  InterestedView.swift
//  iosVolunteer
//
//  Created by Gary Sun on 5/7/23.
//

import SwiftUI

struct InterestedView: View {
    
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State var listingID: String
    
    
    var body: some View {
        VStack {
            List(firestoreManager.interestList) { user in
                VStack(alignment: .leading) {
                    HStack {
                        Text(user.fname)
                            .font(.headline)
                            .fontWeight(.regular)
                        Text(user.lname)
                            .font(.body)
                            .fontWeight(.regular)
                    }
                    Text(user.email)
                        .font(.body)
                        .fontWeight(.regular)
                }
                .padding()
            }
        }
        .onAppear(){
            firestoreManager.getInterestedUsers(listingID: listingID)
        }
        .navigationTitle("Interested Users")
    }
}

struct InterestedView_Previews: PreviewProvider {
    static var previews: some View {
        InterestedView(listingID: "")
    }
}
