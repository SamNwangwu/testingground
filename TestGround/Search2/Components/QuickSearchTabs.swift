//
//  QuickSearchTabs.swift
//  TestGround
//
//  Created by User on 24/07/2024.
//

import SwiftUI

struct QuickSearchTabs: View {
    let tabs = ["Italian", "Mexican", "Chinese", "Indian", "Thai", "Japanese", "French", "Greek", "Spanish", "American", "Pan Asian", "Korean", "Turkish", "Vietnamese", "Brazilian", "Moroccan", "Ethiopian", "Lebanese", "Caribbean", "Peruvian"]

    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tabs, id: \.self) { tab in
                    Text(tab)
                        .font(.system(size: 14))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 14)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal)
        }
    }
}

struct QuickSearchTabs_Previews: PreviewProvider {
    static var previews: some View {
        QuickSearchTabs()
    }
}
