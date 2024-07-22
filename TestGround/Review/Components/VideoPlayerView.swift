//
//  VideoPlayerView.swift
//  TestGround
//
//  Created by User on 22/07/2024.
//

import SwiftUI
import Photos

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
