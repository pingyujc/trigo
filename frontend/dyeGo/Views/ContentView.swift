//
//  ContentView.swift
//  dyeGo
//
//  Created by Jonathan Chen on 12/26/24.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            TrendingView()
                .tabItem {
                    Label("Trending", systemImage: "chart.line.uptrend.xyaxis")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            FavoriteView()
                .tabItem {
                    Label("Favorite", systemImage: "heart")
                }
            
            ProfileView()
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
