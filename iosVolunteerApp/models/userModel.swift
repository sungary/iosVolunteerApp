import Foundation

struct User: Identifiable {
    
    var id: String = ""
    var email: String = ""
    var fname: String = ""
    var lname: String = ""
    var type: String = ""
    var myListings: Array = [] as [String]
    var isSignedIn: Bool = false

}
