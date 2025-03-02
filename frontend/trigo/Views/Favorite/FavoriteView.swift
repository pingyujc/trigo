//
//  FavoriteView.swift
//  trigo
//
//  Created by Jonathan Chen on 12/26/24.
//

import Foundation
import SwiftUI

struct FavoriteView: View {
    var body: some View {
        Group {
            LoggedInFavoriteView()
//            if userManager.user != nil {
//                LoggedInFavoriteView()
//            } else {
//                LoginPromptView(destination: .favorites)
////                LoginView()
//
//            }
        }
    }
}

struct LoggedInFavoriteView: View {
    var body: some View {
        // Your actual favorites content for logged-in users
        Text("Your favorites")
            .font(.largeTitle)
            .padding()
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FavoriteView()
                
        }
    }
}
