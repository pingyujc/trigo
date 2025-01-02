//
//  AccountView.swift
//  PurchasingAgent
//
//  Created by Jonathan Chen on 12/26/2024
//

import SwiftUI

struct AccountView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Log in or create an account to manage your bids, asks, and order history.")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)

                NavigationLink(destination: LoginView()) {
                    Text("Log In")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()

                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .navigationBarTitle("Account", displayMode: .inline)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}

