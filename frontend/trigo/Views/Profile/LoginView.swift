//
//  LoginView.swift
//  trigo
//
//  Created by Jonathan Chen on 12/26/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var authService = AuthService.shared
    @State private var email = ""
    @State private var password = ""
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
                
                Text("LOGIN")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 8)
                    .padding(.bottom, 32)

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
                    
                    SecureField("Enter your password", text: $password)
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

                // Login Button
                Button(action: emailLogin) {
                    HStack {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
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

                // Divider
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                    
                    Text("OR")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 16)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray.opacity(0.3))
                }
                .padding(.vertical, 16)

                // Google login
                Button(action: googleLogin) {
                    HStack {
                        Image(systemName: "g.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.secondaryAccent)
                        
                        Text("Continue with Google")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .foregroundColor(.black)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
                .disabled(isLoading)

                // Sign up link
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account? Sign Up")
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
    }

    func emailLogin() {
        guard !email.isEmpty && !password.isEmpty else {
            errorMessage = "Please fill in all fields"
            return
        }

        isLoading = true
        Task {
            do {
                _ = try await authService.signIn(email: email, password: password)
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    func googleLogin() {
        isLoading = true
        Task {
            do {
                let user = try await authService.signInWithGoogle()
                print("Signed in with Google, userID: \(user.username)")
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
