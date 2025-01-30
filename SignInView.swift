import SwiftUI
import FirebaseAuth
import AuthenticationServices
import FirebaseRemoteConfig

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    var onSignIn: (() -> Void)?
    @RemoteConfigProperty(key: "text", fallback: "Welcome to SharedTab 👋")
    private var text: String

    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 250)
                    .padding(.top, 50)
                
                Text(text)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
            
        
                TextField("Email", text: $email)
                    .padding()
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                SecureField("Password", text: $password)
                    .padding()
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Button(action: {
                    signIn()
                }) {
                    Text("Sign In")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.top, 20)
                }
                
                NavigationLink(destination: SignUpView(onSignUp: onSignIn)) {
                    Text("Don't have an account? Sign Up")
                        .padding()
                        .foregroundColor(.blue)
                }
                
                Spacer()
            }
            .padding()
        }
    }

    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = "Please enter correctly formatted email (with @) and password (6 characters)"
            } else {
                self.errorMessage = nil
                onSignIn?()
            }
        }
    }
}
