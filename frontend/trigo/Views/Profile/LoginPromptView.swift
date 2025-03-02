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
        VStack {
            Text("Please log in to view your \(destination == .favorites ? "favorites" : "profile")")
                .padding()
            
            NavigationLink(destination: LoginView()) {
                Text("Log In")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            NavigationLink(destination: SignUpView()) {
                Text("Sign Up")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
