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
            TrendingView()
                .environmentObject(productViewModel)
                .tabItem {
                    Label("Trending", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            SearchView()
                .environmentObject(productViewModel)
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            CreateOptionsView()
                .environmentObject(productViewModel)
                .tabItem {
                    Label("Create", systemImage: "plus.circle.fill")
                }
            
            FavoriteView()
                .environmentObject(productViewModel)
                .tabItem {
                    Label("Favorite", systemImage: "heart")
                }
            
            ProfileView()
                .environmentObject(productViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
