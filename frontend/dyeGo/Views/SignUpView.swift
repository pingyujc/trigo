//
//  SignUpView.swift
//  dyeGo
//
//  Created by Jonathan Chen on 12/26/24.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            SecureField("Password", text: $password)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)

            Button(action: emailSignUp) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign Up")
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green)
            .cornerRadius(10)
            .disabled(isLoading)
            .padding()

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }

    func emailSignUp() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        isLoading = true
//        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
//            isLoading = false
//            if let error = error {
//                errorMessage = error.localizedDescription
//            } else {
//                userManager.user = authResult?.user
//            }
//        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
