//
//  CountryButton.swift
//  trigo
//
//  Created by Jonathan Chen on 2/9/25.
//

import Foundation
import SwiftUI
// Supporting Views
struct CountryButton: View {
    let country: Country
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(country.name)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

