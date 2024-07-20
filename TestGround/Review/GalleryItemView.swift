import SwiftUI
import Photos

struct GalleryItemView: View {
    let asset: PHAsset
    let onSelect: (UIImage?) -> Void

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let image = loadImage() {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipped()
                    .onTapGesture {
                        onSelect(image)
                    }
            } else {
                // Placeholder for when the image is not available
                Image("Burger")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipped()
                    .background(Color.gray.opacity(0.2))
                    .onTapGesture {
                        onSelect(nil)
                    }
            }
            
            if asset.mediaType == .video {
                Text(formatDuration(asset.duration))
                    .font(.caption)
                    .padding(4)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .padding([.leading, .bottom], 4)
            }
        }
    }

    private func loadImage() -> UIImage? {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        let targetSize = CGSize(width: 120, height: 120)

        var image: UIImage?
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { img, _ in
            image = img
        }
        return image
    }

    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct GalleryItemView_Previews: PreviewProvider {
    static var previews: some View {
        // Use a placeholder image and a mock PHAsset for the preview
        let mockAsset = PHAsset()
        
        GalleryItemView(asset: mockAsset) { selectedImage in
            // Handle the selected image in the preview
        }
        .previewLayout(.sizeThatFits)
        .frame(width: 120, height: 120)
    }
}
