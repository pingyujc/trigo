import Foundation
import SwiftUI

struct OrderView: View {
    var body: some View {
        NavigationView {
            LoggedInOrderView()
//            if userManager.user != nil {
//                LoggedInOrderView()
//            } else {
//                LoginPromptView(destination: .favorites)
//            }
        }
    }
}

struct LoggedInOrderView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                Text("ORDERS")
                    .font(.system(size: 28, weight: .bold))
                    .tracking(2)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                
                // Tabs for Active/Completed
                HStack(spacing: 0) {
                    tabButton(title: "Active", isSelected: true) {
                        // Switch to active tab
                    }
                    
                    tabButton(title: "Completed", isSelected: false) {
                        // Switch to completed tab
                    }
                }
                .padding(.bottom, 24)
                
                // Empty state if no orders
                VStack(spacing: 24) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 64))
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(.top, 40)
                    
                    Text("No Active Orders")
                        .font(.system(size: 18, weight: .medium))
                    
                    Text("Your orders will appear here")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                    
                    // Shop button
                    NavigationLink(destination: HomeView()) {
                        Text("Shop Now")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.black)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                }
                .padding(.top, 40)
                
                Spacer()
            }
            .padding(.horizontal)
            .background(Color.white)
        }
    }
    
    private func tabButton(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? .black : .gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                if isSelected {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.black)
                } else {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.clear)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        OrderView()
    }
}
