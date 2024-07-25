//
//  CustomSearchBar.swift
//  TestGround
//
//  Created by User on 24/07/2024.
//

import SwiftUI

struct CustomSearchBar: View {
    @Binding var text: String
    var textPadding: CGFloat = 0 // Default value for text padding
    var onCommit: () -> Void = {}
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search", text: $text, onCommit: onCommit)
                .padding(.leading, textPadding) // Adjust text padding here
            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .opacity(text.isEmpty ? 0 : 1)
            }
        }
        .frame(height: 10)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(40)
    }
}

struct CustomSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomSearchBar(text: .constant(""))
    }
}
