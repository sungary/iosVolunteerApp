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
    
    func fetchListingsUser(currentUserID: String) {
        let db = Firestore.firestore()
        
        
        
        db.collection("listings").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            self.myListings = documents.map{ (queryDocumentSnapshot) -> Listing in
                let data = queryDocumentSnapshot.data()
                
                if(data["createdBy"] as? String ?? "" == currentUserID){
                    let id = queryDocumentSnapshot.documentID
                    let name = data["name"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let createdBy = data["createdBy"] as? String ?? ""
                    let createdOn = data["createdOn"] as? String ?? ""
                    let location = data["location"] as? String ?? ""
                    
                    return Listing(id: id, name: name, description: description, createdBy: createdBy, createdOn: createdOn, location: location)
                }
                
                return Listing()
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
            fetchListingsUser(currentUserID: user.id)
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
    
    func createNewListing(createdBy: String, description: String, name: String, location: String) {
        let db = Firestore.firestore()
        
        let docRef = db.collection("listings").document()
        docRef.setData([
            "createdBy": createdBy,
            "createdOn": Timestamp(date: Date()),
            "description": description,
            "name": name,
            "Location": location])
        { error in
            if(error != nil){
                //print("error")
            } else {
                //print("success")
            }
        }
        
        
    }
}
