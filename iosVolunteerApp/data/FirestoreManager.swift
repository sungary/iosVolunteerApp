import SwiftUI
import Firebase
import FirebaseAuth

class FirestoreManager: ObservableObject {
    
    @Published var allListings = [Listing]()
    @Published var myListings = [Listing]()
    
    func getCurrentUserID() async -> String {
        
        if(Auth.auth().currentUser != nil){
            return Auth.auth().currentUser?.uid ?? ""
        }
        
        return "Error"
    }
    
    func fetchListingsAll() {
        let db = Firestore.firestore()
        
        db.collection("listings").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            self.allListings = documents.map{ (queryDocumentSnapshot) -> Listing in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let tempTimeS = data["timeStart"] as? Timestamp
                let timeStart = tempTimeS?.dateValue() ?? Date()
                let tempTimeE = data["timeEnd"] as? Timestamp
                let timeEnd = tempTimeE?.dateValue() ?? Date()
                let createdBy = data["createdBy"] as? String ?? ""
                let createdOn = data["createdOn"] as? String ?? ""
                let location = data["location"] as? String ?? ""
                
                let favorited = self.myListings.contains(where: { $0.id == id })
                
                return Listing(id: id, name: name, description: description, timeStart: timeStart, timeEnd: timeEnd, createdBy: createdBy, createdOn: createdOn, location: location, favorited: favorited)
            }
        }
    }
    // to fetch user listings
    func fetchListingsUser() {
        let db = Firestore.firestore()
        let docRefUser = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        docRefUser.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                // resets array
                self.myListings.removeAll()
                
                // list of lisings that the user has
                let arr: [String] = data?["myListings"] as! [String]
                
                // using the above list, search through all listings and get the ones that below to the user
                if(arr.count > 10) {
                    // maxArr is the array size in sets of 10
                    let maxArr = arr.count/10
                    // goes through each set to fetch the data
                    for i in 0...maxArr {
                        let a = i*10
                        var b = 0
                        if(i == maxArr){
                            b = arr.count-1
                        } else {
                            b = ((i+1)*10)-1
                        }
                        let tempArr: [String] = Array(arr[a...b])
                        db.collection("listings").whereField(FieldPath.documentID(), in: tempArr).getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("error getting documents for my listing: \(err)")
                            } else {
                                let documentListing = querySnapshot!.documents
                                // stores the lisings into the myListings so that frontend can fetch it
                                self.myListings.append(contentsOf: documentListing.map{ (queryDocumentSnapshot) -> Listing in
                                    let lisingData = queryDocumentSnapshot.data()

                                    let id = queryDocumentSnapshot.documentID
                                    let name = lisingData["name"] as? String ?? ""
                                    let description = lisingData["description"] as? String ?? ""
                                    let tempTimeS = lisingData["timeStart"] as? Timestamp
                                    let timeStart = tempTimeS?.dateValue() ?? Date()
                                    let tempTimeE = lisingData["timeEnd"] as? Timestamp
                                    let timeEnd = tempTimeE?.dateValue() ?? Date()
                                    let createdBy = lisingData["createdBy"] as? String ?? ""
                                    let createdOn = lisingData["createdOn"] as? String ?? ""
                                    let location = lisingData["location"] as? String ?? ""
                                    
                                    let favorited = true
                                    
                                    return Listing(id: id, name: name, description: description, timeStart: timeStart, timeEnd: timeEnd, createdBy: createdBy, createdOn: createdOn, location: location, favorited: favorited)
                                })
                            }
                        }
                    }
                } else if (arr.count > 0){
                    db.collection("listings").whereField(FieldPath.documentID(), in: arr).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("error getting documents for my listing: \(err)")
                        } else {

                            let documentListing = querySnapshot!.documents

                            // stores the lisings into the myListings so that frontend can fetch it
                            self.myListings = documentListing.map{ (queryDocumentSnapshot) -> Listing in
                                let lisingData = queryDocumentSnapshot.data()

                                let id = queryDocumentSnapshot.documentID
                                let name = lisingData["name"] as? String ?? ""
                                let description = lisingData["description"] as? String ?? ""
                                let tempTimeS = lisingData["timeStart"] as? Timestamp
                                let timeStart = tempTimeS?.dateValue() ?? Date()
                                let tempTimeE = lisingData["timeEnd"] as? Timestamp
                                let timeEnd = tempTimeE?.dateValue() ?? Date()
                                let createdBy = lisingData["createdBy"] as? String ?? ""
                                let createdOn = lisingData["createdOn"] as? String ?? ""
                                let location = lisingData["location"] as? String ?? ""
                                let favorited = true
                                
                                return Listing(id: id, name: name, description: description, timeStart: timeStart, timeEnd: timeEnd, createdBy: createdBy, createdOn: createdOn, location: location, favorited: favorited)
                            }
                        }
                    }
                }
            }
        }
    }
    // to fetch user listing the first time in sign in
    func fetchListingsUser(completionHandler: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let docRefUser = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        docRefUser.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                // resets array
                self.myListings.removeAll()
                
                // list of lisings that the user has
                let arr: [String] = data?["myListings"] as! [String]
                
                // using the above list, search through all listings and get the ones that below to the user
                if(arr.count > 10) {
                    // maxArr is the array size in sets of 10
                    let maxArr = arr.count/10
                    // goes through each set to fetch the data
                    for i in 0...maxArr {
                        let a = i*10
                        var b = 0
                        if(i == maxArr){
                            b = arr.count-1
                        } else {
                            b = ((i+1)*10)-1
                        }
                        let tempArr: [String] = Array(arr[a...b])
                        db.collection("listings").whereField(FieldPath.documentID(), in: tempArr).getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("error getting documents for my listing: \(err)")
                            } else {
                                let documentListing = querySnapshot!.documents
                                // stores the lisings into the myListings so that frontend can fetch it
                                self.myListings.append(contentsOf: documentListing.map{ (queryDocumentSnapshot) -> Listing in
                                    let lisingData = queryDocumentSnapshot.data()

                                    let id = queryDocumentSnapshot.documentID
                                    let name = lisingData["name"] as? String ?? ""
                                    let description = lisingData["description"] as? String ?? ""
                                    let tempTimeS = lisingData["timeStart"] as? Timestamp
                                    let timeStart = tempTimeS?.dateValue() ?? Date()
                                    let tempTimeE = lisingData["timeEnd"] as? Timestamp
                                    let timeEnd = tempTimeE?.dateValue() ?? Date()
                                    let createdBy = lisingData["createdBy"] as? String ?? ""
                                    let createdOn = lisingData["createdOn"] as? String ?? ""
                                    let location = lisingData["location"] as? String ?? ""
                                    let favorited = true
                                    
                                    return Listing(id: id, name: name, description: description, timeStart: timeStart, timeEnd: timeEnd, createdBy: createdBy, createdOn: createdOn, location: location, favorited: favorited)
                                })
                            }
                        }
                    }
                    completionHandler("success")
                } else if (arr.count > 0){
                    db.collection("listings").whereField(FieldPath.documentID(), in: arr).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("error getting documents for my listing: \(err)")
                        } else {

                            let documentListing = querySnapshot!.documents

                            // stores the lisings into the myListings so that frontend can fetch it
                            self.myListings = documentListing.map{ (queryDocumentSnapshot) -> Listing in
                                let lisingData = queryDocumentSnapshot.data()

                                let id = queryDocumentSnapshot.documentID
                                let name = lisingData["name"] as? String ?? ""
                                let description = lisingData["description"] as? String ?? ""
                                let tempTimeS = lisingData["timeStart"] as? Timestamp
                                let timeStart = tempTimeS?.dateValue() ?? Date()
                                let tempTimeE = lisingData["timeEnd"] as? Timestamp
                                let timeEnd = tempTimeE?.dateValue() ?? Date()
                                let createdBy = lisingData["createdBy"] as? String ?? ""
                                let createdOn = lisingData["createdOn"] as? String ?? ""
                                let location = lisingData["location"] as? String ?? ""
                                let favorited = true
                                
                                return Listing(id: id, name: name, description: description, timeStart: timeStart, timeEnd: timeEnd, createdBy: createdBy, createdOn: createdOn, location: location, favorited: favorited)
                            }
                            completionHandler("success")
                        }
                    }
                } else if (arr.count == 0) {
                    completionHandler("empty")
                }
            }
        }
        
    }
    
    // create new user through Authentication
    @MainActor
    func createNewUser(email: String, password: String, fname: String, lname: String, type: String) async -> String {
        var result = ""
        
        // check if user has inputed requried fields
        if(email != "" && password != "" && fname != "" && lname != "" && type != ""){
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                let tempUser = authResult.user
                let uuid = UUID().uuidString
                
                if(tempUser.uid != ""){
                    let user = User(
                        id: uuid,
                        email: tempUser.email ?? "",
                        fname: fname,
                        lname: lname,
                        type: type,
                        myListings: [],
                        isSignedIn: false)
                    Task {
                        createNewUserInfo(user: user, authResultUID: tempUser.uid)
                    }
                    result = "success"
                } else {
                    result = "error"
                }
            }
            catch {
                //print("error with creating user")
                result = "error"
            }
        } else {
            return "error"
        }
        return result
    }
    
    //create a new document for the new user in the users & user_info collection
    func createNewUserInfo(user: User, authResultUID: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(authResultUID)
        docRef.setData([
            "id": user.id,
            "email": user.email,
            "fname": user.fname,
            "lname": user.lname,
            "myListings": [],
            "type": user.type
        ])
        { error in
            if(error != nil){
                //print("error")
            } else {
                //print("success")
            }
        }
        
        let docRef2 = db.collection("users_info").document(user.id)
        docRef2.setData([
            "email": user.email,
            "fname": user.fname,
            "lname": user.lname
        ])
        { error in
            if(error != nil){
                //print("error")
            } else {
                //print("success")
            }
        }
        
        
    }
    
    @MainActor
    func signIn(email: String, password: String) async -> User {
        
        var user = User(id: "", email: "", fname: "", lname: "", type: "", myListings: [] as [String], isSignedIn: false)
        
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            
            do {
                let document = try await Firestore.firestore().collection("users").document(authResult.user.uid).getDocument()
                let data = document.data()
                if(data != nil){
                    user = User(
                        id: data?["id"] as? String ?? "",
                        email: data?["email"] as? String ?? "",
                        fname: data?["fname"] as? String ?? "",
                        lname: data?["lname"] as? String ?? "",
                        type: data?["type"] as? String ?? "",
                        myListings: data?["myListings"] as? [String] ?? [],
                        isSignedIn: true
                    )
                    
                    let results: (String) -> Void = { result in
                        self.fetchListingsAll()
                    }
                    self.fetchListingsUser(completionHandler: results)
                    //self.fetchListingsAll()
                }
            }
            catch {
                print("Error Getting User Data", error.localizedDescription)
            }
        }
        catch {
            print("Error Signing In", error.localizedDescription)
        }
        
        return user
    }
    
    func signOut() async -> User{
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            //self.myListings.removeAll()
            //self.allListings.removeAll()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        return User()
        
    }
    
    func sendResetPasswordEmail(email: String, completionHandler: @escaping (String) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error sending password reset email: \(error)")
                completionHandler("error")
            } else {
                print("success sending password reset email")
                completionHandler("success")
            }
        }
    }
    
    func createNewListing(createdBy: String, name: String, location: String, description: String, timeStart: Date, timeEnd: Date, completionHandler: @escaping (String) -> Void) {
        if(name != "" && location != "" && description != "") {
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            
            ref = db.collection("listings").addDocument(data: [
                "name": name,
                "location": location,
                "description": description,
                "timeStart": timeStart,
                "timeEnd": timeEnd,
                "createdBy": createdBy,
                "createdOn": Timestamp(date: Date())
            ]) { err in
                if let err = err {
                    print("Error adding listing: \(err)")
                    completionHandler("error adding listing")
                } else {
                    // documented added sucessfully
                    // add document id to users listing array
                    let docID = ref?.documentID ?? ""
                    let tempRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                    tempRef.updateData([
                        "myListings": FieldValue.arrayUnion([docID])
                    ])
                    
                    // create new document in listing_interest to keep track of volunteer users
                    db.collection("listing_interest").document(docID).setData([
                        "interest_list": []
                    ])
                    
                    completionHandler("success")
                }
            }
        } else {
            completionHandler("Error: missing fields")
        }
    }
    
    func updateListing(myListing: Listing, completionHandler: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("listings").document(myListing.id)
        
        docRef.updateData([
            "name": myListing.name,
            "description": myListing.description,
            "timeStart": myListing.timeStart,
            "timeEnd": myListing.timeEnd,
            "location": myListing.location
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
                completionHandler("error")
            } else {
                //print("Listing successfully updated")
                self.fetchListingsUser()
                completionHandler("success")
            }
        }
    }
    
    func deleteListing(listingID: String, completionHandler: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        db.collection("listings").document(listingID).delete() { err in
            if let err = err {
                print("Error deleting listing \(err)")
                completionHandler("error")
            } else {
                //print("Listing successfully deleted")
                
                // removes listing from users myListings array
                let docRefUser = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                docRefUser.updateData([
                    "myListings": FieldValue.arrayRemove([listingID])
                ]) { err in
                    if let err = err {
                        print("Error adding my favorites \(err)")
                        completionHandler("error")
                    } else {
                        //print("Listing successfully deleted")
                        
                        // delete document from listing_interest
                        db.collection("listing_interest").document(listingID).delete() { err in
                            if let err = err {
                                print("Error removing document from listing_interest \(err)")
                            } else {
                                //print("document removed from listing_interest")
                                if let index = self.allListings.firstIndex(where: {$0.id == listingID}){
                                    self.allListings[index].favorited = false
                                }
                                self.fetchListingsUser()
                                completionHandler("success")
                            }
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    func addMyFavorites(listingID: String, completionHandler: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let docRefUser = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        
        docRefUser.updateData([
            "myListings": FieldValue.arrayUnion([listingID])
        ]) { err in
            if let err = err {
                print("Error adding my favorites \(err)")
                completionHandler("error")
            } else {
                //print("Listing successfully deleted")
                if let index = self.allListings.firstIndex(where: {$0.id == listingID}){
                    self.allListings[index].favorited = true
                }
                self.fetchListingsUser()
                completionHandler("success")
            }
        }
    }
    
    func removeMyFavorites(listingID: String, completionHandler: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let docRefUser = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        
        docRefUser.updateData([
            "myListings": FieldValue.arrayRemove([listingID])
        ]) { err in
            if let err = err {
                print("Error adding my favorites \(err)")
                completionHandler("error")
            } else {
                //print("Listing successfully deleted")
                if let index = self.allListings.firstIndex(where: {$0.id == listingID}){
                    self.allListings[index].favorited = false
                }
                self.fetchListingsUser()
                completionHandler("success")
            }
        }
    }
    
    func sendInterest(listingID: String, userID: String, completionHandler: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("listing_interest").document(listingID)
        docRef.updateData([
            "interest_list": FieldValue.arrayUnion([userID])
        ]) { err in
            if let err = err {
                print("Error adding to Interest \(err)")
                completionHandler("error")
            } else {
                let results: (String) -> Void = { result in
                    if(result == "success"){
                        completionHandler("success")
                    } else if(result != ""){
                        completionHandler("error")
                    }
                }
                // if interest is sent then add this listing to users favorites
                self.addMyFavorites(listingID: listingID, completionHandler: results)
            }
        }
    }
    
    func removeInterest(listingID: String, userID: String, completionHandler: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("listing_interest").document(listingID)
        
        docRef.updateData([
            "interest_list": FieldValue.arrayRemove([userID])
        ]) { err in
            if let err = err {
                print("Error removing from Interest \(err)")
                completionHandler("error")
            } else {
                let results: (String) -> Void = { result in
                    if(result == "success"){
                        completionHandler("success")
                    } else if(result != ""){
                        completionHandler("error")
                    }
                }
                // if interest is removed then remove this from users favorites
                self.removeMyFavorites(listingID: listingID, completionHandler: results)
            }
        }
    }
    
    func checkInterest(listingID: String, userID: String, completionHandler: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("listing_interest").document(listingID)
        
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let arr: [String] = data?["interest_list"] as! [String]

                if(arr.count > 0){
                    if(arr.contains(userID)){
                        completionHandler("success")
                    } else  {
                        completionHandler("none")
                    }
                } else {
                    completionHandler("error")
                }
            } else {
                print("Error getting document for checkInterest")
                completionHandler("error")
            }
        }
    }
}
