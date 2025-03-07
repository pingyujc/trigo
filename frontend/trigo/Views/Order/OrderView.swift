
import Foundation
import SwiftUI

struct OrderView: View {
    var body: some View {
        Group {
            LoggedInOrderView()
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

struct LoggedInOrderView: View {
    var body: some View {
        // Your actual favorites content for logged-in users
        Text("Order History")
            .font(.largeTitle)
            .padding()
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OrderView()
                
        }
    }
}
