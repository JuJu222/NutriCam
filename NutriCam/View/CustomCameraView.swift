//
//  CustomCameraView.swift
//  NutriCam
//
//  Created by Yap Justin on 07/08/23.
//

import SwiftUI
import AVFoundation

struct CustomCameraView: View {
    @EnvironmentObject var camera: CameraModel
    @Environment(\.dismiss) var dismiss
    @Binding var showCamera: Bool
    @State var showShutter = false
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
                .overlay {
                    if showShutter {
                        Color.black
                        .onAppear {
                            withAnimation(.easeOut(duration: 0.3)) {
                                showShutter = false
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            if camera.isTaken {
                Color.black.overlay(
                    Image(uiImage: camera.image!)
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea(.all, edges: .all)
//                        .overlay {
//                            Rectangle()
//                                .stroke(Color.yellow, style: StrokeStyle(lineWidth: 5.0,lineCap: .round, lineJoin: .bevel, dash: [60]))
//                                .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 2)
//                        }
                )
            }
            VStack {
                if camera.isTaken {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Back")
                            }
                        }
                        .padding()
                        Spacer()
                        Button {
                            camera.retake()
                        } label: {
                            HStack {
                                Text("Retake")
                                Image(systemName: "arrow.triangle.2.circlepath.camera")
                            }
                        }
                        .padding()
                    }
                } else {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Back")
                            }
                        }
                        .padding()
                        Spacer()
                    }
                }
                Spacer()
                HStack {
                    if camera.isTaken {
                        Button {
//                            camera.image = camera.cropToPreviewLayer(originalImage: camera.image!)
                            showCamera.toggle()
                        } label: {
                            Text("Continue")
                                .frame(maxWidth: Double.infinity)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 20)
                                .background(.primary)
                                .clipShape(Capsule())
                        }
                        .padding(.leading)
                        
                        Spacer()

                    } else {
                        VStack(spacing: 20) {
                            HStack {
                                Text("Please make sure that the image of the food is clear and unobstructed")
                                    .font(.system(size: 15))
                                    .multilineTextAlignment(.center)
                            }
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color(UIColor.systemGray6))
                            .clipShape(Capsule())
                            Button {
                                camera.capture()
                                showShutter = true
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 65, height: 65)
                                    Circle()
                                        .stroke(.primary, lineWidth: 2)
                                        .frame(width: 75, height: 75)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            camera.check()
        }
        .onChange(of: camera.image) { newValue in
            DispatchQueue.global().async {
                camera.session.stopRunning()
                
                DispatchQueue.main.async {
                    withAnimation{
                        camera.isTaken.toggle()
                    }
                }
            }
        }
    }
}

struct CustomCameraView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCameraView(showCamera: .constant(true))
            .environmentObject(CameraModel())
    }
}

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview = AVCaptureVideoPreviewLayer()
    @Published var image: UIImage?
    
    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setup()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setup()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setup() {
        do {
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(for: .video)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
            DispatchQueue.global().async {
                self.session.startRunning()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func capture() {
        DispatchQueue.global().async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            //            DispatchQueue.main.async {
            //                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            //                    self.session.stopRunning()
            //                }
            //            }
        }
    }
    
    func retake() {
        DispatchQueue.global().async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{
                    self.isTaken.toggle()
                }
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        self.image = cropToPreviewLayer(originalImage: UIImage(data: imageData)!)
    }
    
    func cropToPreviewLayer(originalImage: UIImage) -> UIImage {
        let outputRect = preview.metadataOutputRectConverted(fromLayerRect: preview.bounds)
        var cgImage = originalImage.cgImage!
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        
        // Calculate the cropping rectangle based on the size and position of the preview layer
        let cropRect = CGRect(x: outputRect.origin.x * width,
                              y: outputRect.origin.y * height,
                              width: outputRect.size.width * width,
                              height: outputRect.size.height * height)
        
        cgImage = cgImage.cropping(to: cropRect)!
        let croppedUIImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: originalImage.imageOrientation)
        
        return croppedUIImage
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        let yOffset = (UIScreen.main.bounds.height - UIScreen.main.bounds.height / 2) / 2
        camera.preview.frame = CGRect(x: 0, y: yOffset, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
