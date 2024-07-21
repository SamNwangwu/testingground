import SwiftUI
import Photos
import AVKit

struct GalleryView: View {
    @State private var recentAssets: [PHAsset] = []
    @State private var selectedPhoto: UIImage? = nil
    @State private var selectedAsset: PHAsset? = nil
    @State private var selectedAssets: [PHAsset] = []
    @State private var isMultiSelectMode: Bool = false
    @State private var player: AVPlayer? = nil
    @State private var isVideoPaused: Bool = false
    @State private var navigateToCamera: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            VStack {
                // Fixed top navigation bar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                            Text("Back")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                    Spacer()
                    Text("New review")
                        .font(.system(size: 17))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.trailing, -2)
                        .padding(.leading, -20)
                    Spacer()
                    Button(action: {
                        // Placeholder for future functionality
                    }) {
                        HStack {
                            Text("Next")
                                .font(.system(size: 16))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20))
                        }
                        .foregroundStyle(.white)
                        .padding()
                    }
                }
                .padding(.bottom, -13)
                .background(Color.black.opacity(0.9))

                ScrollView {
                    VStack(spacing: 0) {
                        if let selectedAsset = selectedAsset {
                            if selectedAsset.mediaType == .video {
                                ZStack {
                                    VideoPlayerView(asset: selectedAsset, player: $player)
                                        .frame(maxHeight: UIScreen.main.bounds.height * 0.55)
                                        .aspectRatio(1, contentMode: .fit)
                                        .clipped()
                                        .onTapGesture {
                                            if player?.rate == 0 {
                                                player?.play()
                                                isVideoPaused = false
                                            } else {
                                                player?.pause()
                                                isVideoPaused = true
                                            }
                                        }

                                    if isVideoPaused {
                                        Image(systemName: "play.fill")
                                            .resizable()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.white)
                                            .shadow(color: .black, radius: 20, x: 0, y: 2)
                                    }
                                }
                            } else if let selectedPhoto = selectedPhoto {
                                Image(uiImage: selectedPhoto)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: UIScreen.main.bounds.height * 0.55)
                                    .aspectRatio(1, contentMode: .fit)
                                    .clipped()
                            }
                        }

                        HStack {
                            Text("Recents")
                                .font(.system(size: 17))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.leading, 15)
                                .padding(.bottom, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Button(action: {
                                isMultiSelectMode.toggle()
                                if isMultiSelectMode {
                                    if let selectedAsset = selectedAsset {
                                        selectedAssets = [selectedAsset]
                                    }
                                } else {
                                    selectedAssets.removeAll()
                                }
                            }) {
                                Image(systemName: "square.stack.3d.up")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(isMultiSelectMode ? Color.blue.opacity(0.7) : .white)
                                    .padding(.horizontal)
                                    .padding(.top, 3)
                                    .padding(.bottom, 13)
                                    .padding(.trailing, -26)
                            }

                            Button(action: {
                                navigateToCamera = true
                            }) {
                                Image(systemName: "camera.circle.fill")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundStyle(.white)
                                    .padding(.horizontal)
                                    .padding(.top, 3)
                                    .padding(.bottom, 13)
                            }
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 1)
                        .background(Color.black)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 1) {
                            ForEach(recentAssets, id: \.self) { asset in
                                AssetImageView(asset: asset, isSelected: selectedAssets.contains(asset) || selectedAsset == asset, isMultiSelectMode: isMultiSelectMode, selectionNumber: selectedAssets.firstIndex(of: asset))
                                    .frame(height: 130)
                                    .background(Color.clear)
                                    .contentShape(Rectangle()) // Ensures entire frame is tappable
                                    .onTapGesture {
                                        handleSelection(for: asset)
                                    }
                            }
                        }
                        .padding(.horizontal, 0)
                    }
                    .onAppear(perform: fetchRecentAssets)
                }
            }
            .background(Color.black)
            .navigationDestination(isPresented: $navigateToCamera) {
                CameraView()
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .background(Color.black)
    }

    private func fetchRecentAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)

        fetchResult.enumerateObjects { asset, _, _ in
            self.recentAssets.append(asset)
        }

        if let firstAsset = recentAssets.first {
            loadImage(for: firstAsset, targetSize: UIScreen.main.bounds.size) { image in
                self.selectedPhoto = image
                self.selectedAsset = firstAsset
            }
        }
    }

    private func loadImage(for asset: PHAsset, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat

        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            completion(image)
        }
    }

    private func handleSelection(for asset: PHAsset) {
        if isMultiSelectMode {
            if let index = selectedAssets.firstIndex(of: asset) {
                selectedAssets.remove(at: index)
            } else {
                selectedAssets.append(asset)
            }
        } else {
            self.selectedAssets = []
            self.selectedAsset = asset
            if asset.mediaType == .video {
                playVideo(for: asset)
            } else {
                loadImage(for: asset, targetSize: UIScreen.main.bounds.size) { image in
                    self.selectedPhoto = image
                }
            }
        }
    }

    private func playVideo(for asset: PHAsset) {
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestPlayerItem(forVideo: asset, options: options) { playerItem, _ in
            if let playerItem = playerItem {
                DispatchQueue.main.async {
                    self.player = AVPlayer(playerItem: playerItem)
                    self.player?.play()
                    self.isVideoPaused = false
                }
            }
        }
    }
}

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

struct VideoPlayerView: UIViewRepresentable {
    let asset: PHAsset
    @Binding var player: AVPlayer?

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        playVideo(for: asset, on: view)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private func playVideo(for asset: PHAsset, on view: UIView) {
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        PHImageManager.default().requestPlayerItem(forVideo: asset, options: options) { playerItem, _ in
            if let playerItem = playerItem {
                DispatchQueue.main.async {
                    let player = AVPlayer(playerItem: playerItem)
                    let playerLayer = AVPlayerLayer(player: player)
                    playerLayer.frame = view.bounds
                    playerLayer.videoGravity = .resizeAspect
                    view.layer.addSublayer(playerLayer)
                    self.player = player
                    self.player?.play()
                }
            }
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
