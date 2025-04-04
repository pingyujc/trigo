//
//  ContentView.swift
//  trigo
//
//  Created by Jonathan Chen on 12/26/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var productViewModel = ProductViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(productViewModel)
                .tabItem {
                    Label("HOME", systemImage: "house")
                }
            
            SearchView()
                .environmentObject(productViewModel)
                .tabItem {
                    Label("SEARCH", systemImage: "magnifyingglass")
                }
            
            CreateOptionsView()
                .environmentObject(productViewModel)
                .tabItem {
                    Label("CREATE", systemImage: "plus.circle.fill")
                }
            
//            FavoriteView()
//                .environmentObject(productViewModel)
//                .tabItem {
//                    Label("Favorite", systemImage: "heart")
//                }
            
            OrderView()
                .environmentObject(productViewModel)
                .tabItem {
                    Label("ORDERS", systemImage: "clock.arrow.circlepath")
                }
            
            ProfileView()
                .environmentObject(productViewModel)
                .tabItem {
                    Label("PROFILE", systemImage: "person")
                }
        }
        .onAppear {
            // Style the tab bar to match the reference design
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black
            
            // Style the tab bar items
            let itemAppearance = UITabBarItemAppearance()
            
            // Normal state
            itemAppearance.normal.iconColor = UIColor.lightGray
            itemAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.lightGray, 
                .font: UIFont.systemFont(ofSize: 10, weight: .medium)
            ]
            
            // Selected state
            itemAppearance.selected.iconColor = UIColor.white
            itemAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 10, weight: .medium)
            ]
            
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
