//
//  CameraView.swift
//  TestGround
//
//  Created by User on 21/07/2024.
//

import SwiftUI
import AVFoundation
import Photos

struct CameraView: View {
    @State private var isFlashOn = false
    @State private var isUsingFrontCamera = false
    @State private var selectedOption: String = "Photo"
    @State private var mostRecentPhoto: UIImage?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                CameraPreview(isUsingFrontCamera: $isUsingFrontCamera)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: {
                                // Handle flash
                                isFlashOn.toggle()
                            }) {
                                Image(systemName: isFlashOn ? "bolt.fill" : "bolt")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            Button(action: {
                                // Handle camera flip
                                isUsingFrontCamera.toggle()
                            }) {
                                Image(systemName: "camera.rotate")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            Button(action: {
                                // Handle timer
                            }) {
                                Image(systemName: "timer")
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            HStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(["Photo", "15s", "60s", "5m"], id: \.self) { option in
                                            Text(option)
                                                .foregroundStyle(.white)
                                                .fontWeight(selectedOption == option ? .bold : .regular)
                                                .onTapGesture {
                                                    selectedOption = option
                                                }
                                        }
                                    }
                                }
                            }
                            .padding(.leading, 92)

                            Button(action: {
                                // Action for taking photo/video
                            }) {
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 4)
                                    .background(Circle().foregroundColor(Color.red))
                                    .frame(width: 70, height: 70)
                            }
                            .padding(.bottom, 80)
                        }
                        Spacer()
                    }
                }
                
                VStack {
                    HStack {
                        ZStack {
                            Button(action: {
                                dismiss()
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
                        }
                        .background(Color.clear)
                        .frame(width: 100, height: 100)
                        .padding(.top, -25)
                        .padding(.leading, 2)
                        Spacer()
                    }
                    Spacer()
                }
            }
            .onAppear {
                fetchMostRecentPhoto()
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func fetchMostRecentPhoto() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1

        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        if let asset = fetchResult.firstObject {
            let imageManager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isSynchronous = true

            imageManager.requestImage(for: asset, targetSize: CGSize(width: 50, height: 50), contentMode: .aspectFill, options: options) { image, _ in
                DispatchQueue.main.async {
                    self.mostRecentPhoto = image
                }
            }
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    @Binding var isUsingFrontCamera: Bool

    class Coordinator: NSObject, AVCapturePhotoCaptureDelegate {
        var parent: CameraPreview

        init(parent: CameraPreview) {
            self.parent = parent
        }

        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            guard let imageData = photo.fileDataRepresentation() else { return }
            let image = UIImage(data: imageData)
            // Handle captured photo
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        let videoCaptureDevice = isUsingFrontCamera ? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) : AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
        guard let videoCaptureDevice = videoCaptureDevice else {
            print("Failed to get the camera device")
            return view
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            print("Failed to create video input")
            return view
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }

        let photoOutput = AVCapturePhotoOutput()
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
            captureSession.startRunning()
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let captureSession = (uiView.layer.sublayers?.first { $0 is AVCaptureVideoPreviewLayer } as? AVCaptureVideoPreviewLayer)?.session else {
            return
        }
        
        captureSession.beginConfiguration()

        let currentInputs = captureSession.inputs as? [AVCaptureDeviceInput]
        for input in currentInputs ?? [] {
            captureSession.removeInput(input)
        }

        let videoCaptureDevice = isUsingFrontCamera ? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) : AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        
        guard let videoCaptureDevice = videoCaptureDevice else {
            print("Failed to get the camera device")
            return
        }
        
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else {
            print("Failed to create video input")
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }

        captureSession.commitConfiguration()
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
