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
    
    var body: some View {
        ZStack {
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges: .all)
            if camera.isTaken {
                Color.clear.overlay(
                    Image(uiImage: camera.image!)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea(.all, edges: .all)
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
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .clipShape(Capsule())
                        }
                        .padding(.leading, 10)
                        Spacer()
                        Button {
                            camera.retake()
                        } label: {
                            HStack {
                                Text("Retake")
                                Image(systemName: "arrow.triangle.2.circlepath.camera")
                            }
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .clipShape(Capsule())
                        }
                        .padding(.trailing, 10)
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
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .clipShape(Capsule())
                        }
                        .padding(.leading, 10)
                        Spacer()
                    }
                }
                Spacer()
                HStack {
                    if camera.isTaken {
                        Button {
                            showCamera.toggle()
                        } label: {
                            Text("Continue")
                                .frame(maxWidth: Double.infinity)
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                        .padding(.leading)
                        
                        Spacer()

                    } else {
                        Button {
                            camera.capture()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75, height: 75)
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
        
        self.image = UIImage(data: imageData)
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
