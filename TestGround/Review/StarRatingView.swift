//
//  StarRatingBarVIew.swift
//  EatOut
//
//  Created by User on 18/07/2024.
//

import SwiftUI

struct StarRatingView: View {
    @Binding var dragOffset: CGFloat
    let starWidth: CGFloat
    var symbol: String = "star.square.fill" // Default symbol is star
    var spacing: CGFloat // Add spacing parameter
    var onEnded: (() -> Void)? = nil // Optional onEnded closure

    var body: some View {
        GeometryReader { geometry in
            let iconCount = 10
            let totalWidth = CGFloat(iconCount) * starWidth
            HStack(spacing: spacing) {
                ForEach(0..<iconCount) { index in
                    Image(systemName: symbol)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: starWidth, height: starWidth)
                        .foregroundColor(.gray)
                        .overlay(
                            Image(systemName: symbol)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: starWidth, height: starWidth)
                                .foregroundColor(.black)
                                .opacity(min(max((dragOffset - CGFloat(index) * (starWidth + spacing)) / (starWidth + spacing), 0), 1))
                        )
                }
            }
            .frame(width: totalWidth + spacing * CGFloat(iconCount - 1))
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let offset = min(max(value.location.x, 0), totalWidth + spacing * CGFloat(iconCount - 1))
                        dragOffset = offset
                    }
                    .onEnded { _ in
                        onEnded?()
                    }
            )
        }
        .frame(height: starWidth)
    }
}

struct PoundRatingView: View {
    @Binding var dragOffset: CGFloat
    let starWidth: CGFloat
    var spacing: CGFloat // Add spacing parameter
    var onEnded: (() -> Void)? = nil // Optional onEnded closure

    var body: some View {
        GeometryReader { geometry in
            let iconCount = 5
            let totalWidth = (CGFloat(iconCount) * 2) * starWidth
            HStack(spacing: spacing + 2) {
                ForEach(0..<iconCount) { index in
                    Image(systemName: "sterlingsign.circle.fill")
                        .font(.system(size: starWidth))
                        .frame(width: starWidth, height: starWidth)
                        .foregroundColor(.gray)
                        .overlay(
                            Image(systemName: "sterlingsign.circle.fill")
                                .font(.system(size: starWidth * 1.1))
                                .foregroundColor(.black)
                                .opacity(min(max((dragOffset - CGFloat(index) * (starWidth + spacing)) / (starWidth + spacing), 0), 1))
                        )
                }
            }
            .frame(width: totalWidth + spacing * CGFloat(iconCount - 1))
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let offset = min(max(value.location.x, 0), totalWidth + spacing * CGFloat(iconCount - 1))
                        dragOffset = offset
                    }
                    .onEnded { _ in
                        onEnded?()
                    }
            )
        }
        .frame(height: starWidth)
    }
}

//#Preview {
//    StarRatingView()
//}
