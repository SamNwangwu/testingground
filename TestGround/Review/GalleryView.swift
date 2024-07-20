import SwiftUI
import Photos

struct GalleryView: View {
    @State private var recentAssets: [PHAsset] = []
    @State private var selectedPhoto: UIImage? = nil
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                // Fixed top navigation bar
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24))
                            Text("Back")
                                .font(.system(size: 18))
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                    Spacer()
                    Text("New review")
                        .font(.system(size: 17.5))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.trailing, -2)
                        .padding(.leading, -20)
                    Spacer()
                    Button(action: {
                        // Placeholder for future functionality
                    }) {
                        Image(systemName: "rectangle.stack")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding(.bottom, -10)
                .background(Color.black.opacity(0.7))
                
                // Scrollable content
                ScrollView {
                    VStack(spacing: 0) {
                        if let selectedPhoto = selectedPhoto {
                            Image(uiImage: selectedPhoto)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: UIScreen.main.bounds.height * 0.55)
                                .aspectRatio(1, contentMode: .fit)
                                .clipped()
                        } else {
                            Rectangle()
                                .foregroundColor(.gray)
                                .frame(maxHeight: UIScreen.main.bounds.height * 0.55)
                                .aspectRatio(1, contentMode: .fit)
                        }
                        
                        HStack {
                            Text("Recents")
                                .font(.system(size: 17))
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                                .padding(.leading, 20)
                                .padding(.bottom, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Image(systemName: "square.stack.3d.up")
                                .resizable()
                                .frame(width: 22, height: 20)
                                .foregroundStyle(.white)
                                .padding(.horizontal)
                                .padding(.top, 3)
                                .padding(.trailing, 7)
                                .padding(.bottom, 9)
                        }
                        .padding(.top, 7)
                        .background(Color.black)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
                            ForEach(recentAssets, id: \.self) { asset in
                                AssetImageView(asset: asset)
                                    .frame(height: 120)
                                    .overlay(Rectangle().stroke(Color.black, lineWidth: 0.5))
                                    .onTapGesture {
                                        loadImage(for: asset) { image in
                                            self.selectedPhoto = image
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal, 1)
                    }
                    .onAppear(perform: fetchRecentAssets)
                }
            }
            .background(Color.black)
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
            loadImage(for: firstAsset) { image in
                self.selectedPhoto = image
            }
        }
    }
    
    private func loadImage(for asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        let targetSize = CGSize(width: 500, height: 500)
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            completion(image)
        }
    }
}

struct AssetImageView: View {
    let asset: PHAsset
    
    @State private var image: UIImage? = nil
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .onAppear {
                        loadImage(for: asset)
                    }
            }
        }
    }
    
    private func loadImage(for asset: PHAsset) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = true
        let targetSize = CGSize(width: 120, height: 120)
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            self.image = image
        }
    }
}

extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
