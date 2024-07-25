//
//  HorizontalPlaceholderView.swift
//  TestGround
//
//  Created by User on 24/07/2024.
//

import SwiftUI

struct HorizontalPlaceholderView: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
                .foregroundStyle(.white)
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<6) { _ in
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct HorizontalPlaceholderView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalPlaceholderView(title: "Recommended for you")
    }
}
