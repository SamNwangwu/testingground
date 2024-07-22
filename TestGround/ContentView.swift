import SwiftUI
import Photos

struct ContentView: View {
    @StateObject private var viewModel = PhotoLibraryViewModel()
    @State private var currentAsset: PHAsset?
    @State private var currentAssetID: String?

    var body: some View {
        VStack {
            if !viewModel.assets.isEmpty {
                TabView(selection: $currentAsset) {
                    ForEach(viewModel.assets, id: \.self) { asset in
                        TestAssetImageView(asset: asset, currentAssetID: $currentAssetID)
                            .tag(asset)
                            .onAppear {
                                if currentAssetID != asset.localIdentifier {
                                    currentAssetID = asset.localIdentifier
                                    print("Asset in view (onAppear): \(asset.localIdentifier)")
                                }
                            }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 400)
                .onChange(of: currentAsset) { asset in
                    if let asset = asset {
                        print("Current asset selected (onChange): \(asset.localIdentifier)")
                    }
                }
                
                if let asset = currentAsset {
                    Text("Current Asset: \(asset.localIdentifier)")
                        .foregroundColor(.black)
                        .padding()
                }
            } else {
                Text("No assets available")
            }
        }
        .onAppear {
            viewModel.fetchAssets()
        }
    }
}

struct TestAssetImageView: View {
    var asset: PHAsset
    @Binding var currentAssetID: String?
    @State private var image: UIImage? = nil

    var body: some View {
        VStack {
            ZStack {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                } else {
                    Color.gray
                    Text("Loading...")
                        .foregroundColor(.white)
                        .onAppear {
                            if currentAssetID == asset.localIdentifier {
                                loadImage()
                                print("Loading image for asset: \(asset.localIdentifier)")
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(15)
            .padding()
            
            Text(asset.localIdentifier)
                .foregroundColor(.black)
                .padding()
        }
    }

    private func loadImage() {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false

        DispatchQueue.global(qos: .userInitiated).async {
            manager.requestImage(for: asset,
                                 targetSize: CGSize(width: UIScreen.main.bounds.width * 0.88, height: UIScreen.main.bounds.height * 0.4),
                                 contentMode: .aspectFit,
                                 options: options) { (result, info) in
                DispatchQueue.main.async {
                    self.image = result
                    if let result = result {
                        print("Loaded image for asset: \(asset.localIdentifier)")
                    } else {
                        print("Failed to load image for asset: \(asset.localIdentifier)")
                    }
                }
            }
        }
    }
}



