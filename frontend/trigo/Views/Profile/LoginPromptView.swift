//
//  LoginPromptView.swift
//  trigo
//
//  Created by Jonathan Chen on 12/26/24.
//

import Foundation
import SwiftUI

enum LoginDestination {
    case favorites, profile
}

struct LoginPromptView: View {
    let destination: LoginDestination

    var body: some View {
        VStack(spacing: 24) {
            // Logo
            Text("TRIGO")
                .font(.system(size: 28, weight: .bold))
                .tracking(2)
                .padding(.top, 60)
            
            // Illustration
            Image(systemName: "person.crop.circle")
                .font(.system(size: 70))
                .foregroundColor(.gray.opacity(0.6))
                .padding(.vertical, 40)
            
            // Message
            Text("Please log in to access your \(destination == .favorites ? "favorites" : "profile")")
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
            
            // Login Button
            NavigationLink(destination: LoginView()) {
                Text("Log In")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(30)
            }
            .padding(.horizontal, 24)
            
            // Sign Up Button
            NavigationLink(destination: SignUpView()) {
                Text("Create Account")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color.white)
    }
}
