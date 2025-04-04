//
//  SignUpView.swift
//  trigo
//
//  Created by Jonathan Chen on 12/26/24.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var authService = AuthService.shared
    
    @State private var name = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                Text("TRIGO")
                    .font(.system(size: 28, weight: .bold))
                    .tracking(2)
                    .padding(.top, 40)
                
                Text("CREATE ACCOUNT")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 8)
                    .padding(.bottom, 32)
                
                // Name field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Full Name")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    TextField("Enter your name", text: $name)
                        .font(.system(size: 16))
                        .padding()
                        .background(Color.customBackgroundSecondary)
                        .cornerRadius(8)
                }
                // Username field
                VStack(alignment: .leading, spacing: 8) {
                    Text("UserName")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    TextField("Enter your Username", text: $username)
                        .font(.system(size: 16))
                        .padding()
                        .background(Color.customBackgroundSecondary)
                        .cornerRadius(8)
                }
                
                // Email field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    TextField("Enter your email", text: $email)
                        .font(.system(size: 16))
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.customBackgroundSecondary)
                        .cornerRadius(8)
                }
                
                // Password field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Password")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    SecureField("Create password", text: $password)
                        .font(.system(size: 16))
                        .padding()
                        .background(Color.customBackgroundSecondary)
                        .cornerRadius(8)
                }
                
                // Confirm Password field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Confirm Password")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    SecureField("Confirm password", text: $confirmPassword)
                        .font(.system(size: 16))
                        .padding()
                        .background(Color.customBackgroundSecondary)
                        .cornerRadius(8)
                }
                
                // Error message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.system(size: 14))
                        .foregroundColor(.secondaryAccent)
                        .padding(.top, 8)
                }
                
                // Sign Up Button
                Button(action: signUp) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Create Account")
                                .font(.system(size: 16, weight: .bold))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
                .foregroundColor(.white)
                .background(Color.black)
                .cornerRadius(30)
                .disabled(isLoading)
                .padding(.top, 16)
                
                // Already have account link
                Button(action: {
                    dismiss()
                }) {
                    Text("Already have an account? Log In")
                        .font(.system(size: 16))
                        .underline()
                        .foregroundColor(.black)
                }
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
            Text("Back")
                .foregroundColor(.black)
        })
    }
    
    func signUp() {
        // Validate inputs
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        isLoading = true
        Task {
            do {
                _ = try await authService.signUp(email: email, password: password, name: name, username: username)
                
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
