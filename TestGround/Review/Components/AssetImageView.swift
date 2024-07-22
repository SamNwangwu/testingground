//
//  AssetImageView.swift
//  TestGround
//
//  Created by User on 22/07/2024.
//

import SwiftUI
import Photos

struct AssetImageView: View {
    let asset: PHAsset
    let isSelected: Bool
    let isMultiSelectMode: Bool
    let selectionNumber: Int?

    @State private var image: UIImage? = nil

    var body: some View {
        ZStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    .clipped()
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 130, height: 130)
                    .onAppear {
                        loadImage(for: asset)
                    }
            }

            if asset.mediaType == .video {
                Text(formatDuration(asset.duration))
                    .font(.caption)
                    .padding(5)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding(5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }

            if isSelected && isMultiSelectMode {
                Color.black.opacity(0.3)
                    .frame(width: 130, height: 130)
            }

            if isMultiSelectMode, isSelected, let number = selectionNumber {
                Circle()
                    .fill(Color.blue.opacity(0.7))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Text("\(number + 1)")
                            .font(.caption)
                            .foregroundColor(.white)
                    )
                    .position(x: 110, y: 20)
            }
        }
        .contentShape(Rectangle()) // Ensures entire frame is tappable
    }

    private func loadImage(for asset: PHAsset) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        let targetSize = CGSize(width: 130, height: 130)

        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            self.image = image
        }
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
