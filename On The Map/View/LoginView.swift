//
//  LoginView.swift
//  On The Map
//
//  Created by KhuePM on 24/04/2024.
//

import SwiftUI

struct LoginView: View {
    
    // MARK:  Property
    @EnvironmentObject var userViewModel: UserViewModel
    @State var email: String = ""
    @State var password: String = ""
    @State var isLoading: Bool = false
    var loginButtonDisabled: Bool {
        self.email.isEmpty || self.password.isEmpty || isLoading
    }
    // MARK:  Body
    var body: some View {
        ZStack {
            VStack {
                Image("logo-u")
                    .frame(minHeight: 150)
                
                VStack {
                    TextField("Email", text: $email, onEditingChanged: {_ in }, onCommit: {})
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 10)
                    
                    
                    SecureField("Password", text: $password, onCommit: {})
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 10)
                    
                    Button(action: {
                        userViewModel.login(username: self.email, password: self.password)
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .frame( maxWidth: .infinity, minHeight: 40)
                            .background(Color(.bluecian))
                            .cornerRadius(5)
                    }
                    .opacity(loginButtonDisabled ? 0.5 : 1)
                    .disabled(loginButtonDisabled)
                }
                .padding(20)
                
                HStack {
                    Text("Don't have an account?").font(.subheadline)
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!)
                    }) {
                        Text("Sign Up")
                            .foregroundColor(Color(.bluecian))
                            .font(.subheadline)
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            
            
            if userViewModel.isLoading {
                LoadingView()
            }
        }
    }
}

#Preview {
    LoginView()
}
