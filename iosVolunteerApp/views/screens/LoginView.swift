import SwiftUI

struct LoginView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationView() {
            VStack(alignment: .center, spacing: nil) {
                Text("Welcome")
                    .bold()
                    .font(.largeTitle)
                
                TextField(text: $email, prompt: Text("Email")) {
                    Text("Email")
                }
                .padding()
                .background(Color(red: 220/256, green: 220/256, blue: 220/256))
                .cornerRadius(25)
                SecureField(text: $password, prompt: Text("Password")) {
                    Text("Password")
                }
                .padding()
                .background(Color(red: 220/256, green: 220/256, blue: 220/256))
                .cornerRadius(25)
                
                
                HStack(alignment: .center, spacing: 25){
                    NavigationLink(destination: SignUpView()){
                        Text("Sign Up")
                    }
                        .padding()
                        .buttonStyle(.bordered)
                        .cornerRadius(25)
                        .tint(.green)

                    
                    Button(action: {
                        //var user = User(id: "", email: "", fname: "", lname: "", type: "")
                        
                        Task {
                            let user = await firestoreManager.signIn(email: email, password: password)
                            if(user.email != "") {
                                print(user.email)
                            }
                        }
                        
                    }) {
                        Text("Sign In")
                    }
                        .padding()
                        .buttonStyle(.bordered)
                        .cornerRadius(25)
                        .tint(.green)
                }
                Button(action: {print("button pressed")}) {
                    Text("Forgot Password")
                }
            }
            .padding()
            .border(.green)
            .padding(.bottom, 200)
        }
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(FirestoreManager())
    }
}
