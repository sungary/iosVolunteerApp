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
                let createdBy = data["createdBy"] as? String ?? ""
                let createdOn = data["createdOn"] as? String ?? ""
                let location = data["location"] as? String ?? ""
                
                return Listing(id: id, name: name, description: description, createdBy: createdBy, createdOn: createdOn, location: location)
                
            }
        }
    }
    
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
                                    let createdBy = lisingData["createdBy"] as? String ?? ""
                                    let createdOn = lisingData["createdOn"] as? String ?? ""
                                    let location = lisingData["location"] as? String ?? ""

                                    return Listing(id: id, name: name, description: description, createdBy: createdBy, createdOn: createdOn, location: location)
                                })
                            }
                        }
                    }
                } else {
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
                                let createdBy = lisingData["createdBy"] as? String ?? ""
                                let createdOn = lisingData["createdOn"] as? String ?? ""
                                let location = lisingData["location"] as? String ?? ""

                                return Listing(id: id, name: name, description: description, createdBy: createdBy, createdOn: createdOn, location: location)
                            }
                        }
                    }
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
    
    //create a new document for the new user in the users collection
    func createNewUserInfo(user: User, authResultUID: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(authResultUID)
        docRef.setData([
            "id": user.id,
            "email": user.email,
            "fname": user.fname,
            "lname": user.lname,
            "myListings": [],
            "type": user.type])
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
                }
            }
            catch {
                print("Error Getting User Data", error.localizedDescription)
            }
        }
        catch {
            print("Error Signing In", error.localizedDescription)
        }
        if(user.id != ""){
            fetchListingsAll()
            fetchListingsUser()
        }
        
        return user
    }
    
    func signOut() async -> User{
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        return User()
        
    }
    
    func createNewListing(createdBy: String, name: String, location: String, description: String, completionHandler: @escaping (String) -> Void) {
        if(name != "" && location != "" && description != "") {
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            
            ref = db.collection("listings").addDocument(data: [
                "name": name,
                "location": location,
                "description": description,
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
                self.fetchListingsUser()
                completionHandler("success")
            }
        }
    }
}
