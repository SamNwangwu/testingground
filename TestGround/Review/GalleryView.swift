import SwiftUI
import Photos
import AVKit

struct GalleryView: View {
    @State private var recentAssets: [PHAsset] = []
    @State private var selectedPhoto: UIImage? = nil
    @State private var selectedAsset: PHAsset? = nil
    @State private var selectedAssets: [PHAsset] = []
    @State private var isMultiSelectMode: Bool = false
    @State private var showCameraView: Bool = false
    @State private var player: AVPlayer? = nil
    @State private var isVideoPaused: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    headerView
                    VStack(spacing: 0) {
                        selectedMediaView
                        actionsBar
                        recentAssetsGrid
                    }
                    .onAppear(perform: fetchRecentAssets)
                }
            }
            .background(Color.black)
            .navigationDestination(isPresented: $showCameraView) {
                CameraView()
            }
        }
        .background(Color.black)
    }

    private var headerView: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22))
                    Text("Back")
                        .font(.system(size: 17))
                }
                .foregroundColor(.white)
                .padding()
            }
            Spacer()
            Text("New review")
                .font(.system(size: 16.5))
                .font(.headline)
                .foregroundColor(.white)
                .padding(.trailing, -2)
                .padding(.leading, -18)
            Spacer()
            NavigationLink(destination: TagItemView(selectedAssets: $selectedAssets)) {
                HStack {
                    Text("Next")
                        .font(.system(size: 17))
                    Image(systemName: "chevron.right")
                        .font(.system(size: 22))
                }
                .foregroundStyle(.white)
                .padding()
            }
        }
        .padding(.bottom, -13)
        .background(Color.black.opacity(0.9))
    }

    private var selectedMediaView: some View {
        VStack {
            if let selectedAsset = selectedAsset {
                if selectedAsset.mediaType == .video {
                    videoPlayerView(for: selectedAsset)
                } else if let selectedPhoto = selectedPhoto {
                    Image(uiImage: selectedPhoto)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: UIScreen.main.bounds.height * 0.55)
                        .aspectRatio(1, contentMode: .fit)
                        .clipped()
                }
            }
        }
    }

    private var actionsBar: some View {
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
                showCameraView = true
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
    }

    private var recentAssetsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 1) {
            ForEach(recentAssets, id: \.self) { asset in
                AssetImageView(asset: asset, isSelected: selectedAssets.contains(asset) || selectedAsset == asset, isMultiSelectMode: isMultiSelectMode, selectionNumber: selectedAssets.firstIndex(of: asset))
                    .frame(height: 130)
                    .background(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        handleSelection(for: asset)
                    }
            }
        }
        .padding(.horizontal, 0)
    }

    private func videoPlayerView(for asset: PHAsset) -> some View {
        ZStack {
            VideoPlayerView(asset: asset, player: $player)
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
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                    .onTapGesture {
                        player?.play()
                        isVideoPaused = false
                    }
            }
        }
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
