//
//  CameraView.swift
//  TestGround
//
//  Created by User on 20/07/2024.
//

import SwiftUI
import AVFoundation
import Photos

struct CameraView: View {
    @Binding var foodQualityRating: CGFloat
    @Binding var ambianceRating: CGFloat
    @Binding var serviceRating: CGFloat
    @Binding var valueRating: CGFloat
    @State private var isFlashOn = false
    @State private var isUsingFrontCamera = false
    @State private var selectedOption: String = "Photo"
    @State private var mostRecentPhoto: UIImage?
    @State private var navigateToGallery = false
    var returnToReview: (() -> Void)?

    var body: some View {
        NavigationStack {
            ZStack {
                CameraPreview(isUsingFrontCamera: $isUsingFrontCamera)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    HStack {
                        Button(action: {
                            returnToReview?()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 24))
                                Text("Back")
                                    .font(.system(size: 18))
                            }
                            .foregroundColor(.white)
                            .padding()
                            .padding(.top, -100)
                        }
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
                        Button(action: {
                            navigateToGallery = true
                        }) {
                            if let recentPhoto = mostRecentPhoto {
                                Image(uiImage: recentPhoto)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Rectangle())
                                    .cornerRadius(10)
                                    .padding(.bottom, -400)
                                    .padding(.top, 20)
                                    .padding(.leading, 20)
                            } else {
                                Rectangle()
                                    .foregroundStyle(.black)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Rectangle())
                                    .cornerRadius(10)
                                    .padding(.bottom, -400)
                                    .padding(.top, 20)
                                    .padding(.leading, 20)
                            }
                        }
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
                                    .padding(.trailing, 70)
                            }
                            .padding(.bottom, 80)
                        }
                        Spacer()
                    }
                }
                .navigationDestination(isPresented: $navigateToGallery) {
                    GalleryView()
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
//
//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraView(
//            foodQualityRating: .constant(0.0),
//            ambianceRating: .constant(0.0),
//            serviceRating: .constant(0.0),
//            valueRating: .constant(0.0)
//        )
//    }
//}






