//
//  PhotoLibraryViewModel.swift
//  TestGround
//
//  Created by User on 22/07/2024.
//

import SwiftUI
import Photos

class PhotoLibraryViewModel: ObservableObject {
    @Published var assets: [PHAsset] = []
    @Published var prefetchedImages: [String: UIImage] = [:]

    func fetchAssets() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        fetchResult.enumerateObjects { (asset, _, _) in
            self.assets.append(asset)
        }

        prefetchImages()
    }

    private func prefetchImages() {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false

        DispatchQueue.global(qos: .userInitiated).async {
            for asset in self.assets {
                manager.requestImage(for: asset,
                                     targetSize: CGSize(width: UIScreen.main.bounds.width * 0.88, height: UIScreen.main.bounds.height * 0.4),
                                     contentMode: .aspectFit,
                                     options: options) { (result, info) in
                    if let result = result {
                        DispatchQueue.main.async {
                            self.prefetchedImages[asset.localIdentifier] = result
                            print("Prefetched image for asset: \(asset.localIdentifier)")
                        }
                    }
                }
            }
        }
    }
}


