import SwiftUI

struct LoginView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State var buttonDisabled = false
    
    var body: some View {
        NavigationView() {
            ZStack {
                GeometryReader { _ in
                    EmptyView()
                }
                .background(.black.opacity(0.75))
                .opacity(buttonDisabled ? 1 : 0)
                .animation(.easeInOut.delay(0.2), value: buttonDisabled)
                .disabled(buttonDisabled)
                
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
                            .disabled(buttonDisabled)

                        
                        Button(action: {
                            //var user = User(id: "", email: "", fname: "", lname: "", type: "")
                            buttonDisabled = true
                            
                            Task {
                                
                                let user = await firestoreManager.signIn(email: email, password: password)
                                if(user.type != "") {
                                    print(user.type)
                                    
                                }
                                buttonDisabled = false
                            }
                            
                        }) {
                            Text("Sign In")
                        }
                            .padding()
                            .buttonStyle(.bordered)
                            .cornerRadius(25)
                            .tint(.green)
                            .disabled(buttonDisabled)
                    }
                    Button(action: {print("button pressed")}) {
                        Text("Forgot Password")
                    }
                        .disabled(buttonDisabled)
                }
                .padding()
                .padding(.bottom, 200)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(FirestoreManager())
    }
}
