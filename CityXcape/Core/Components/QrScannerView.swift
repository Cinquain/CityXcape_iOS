//
//  QrScannerView.swift
//  CityXcape
//
//  Created by James Allan on 4/13/23.
//

import SwiftUI
import AVKit

struct QrScannerView: View {
    
    @Environment(\.openURL) private var openUrl
    @StateObject private var qrDelegate: QRScannerDelegae = QRScannerDelegae()
    @State private var isScanning: Bool = false
    @State private var session: AVCaptureSession = .init()
    @State private var cameraPermission: Permissions = .idle
    
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    @State private var scannedCode: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            
            Button {
                //
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.cx_orange)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            
            Text("Scan QR code to get stamped")
                .font(.title3)
                .fontWeight(.thin)
                .foregroundColor(.cx_orange.opacity(0.8))
                .padding(.top, 20)
            
            Text("Scanning will start automatically")
                .font(.callout)
                .fontWeight(.thin)
                .foregroundColor(.cx_orange)
            
            Spacer(minLength: 0)
            
            GeometryReader {
                let size = $0.size
                
                ZStack {
                    
                    CameraView(frameSize: CGSize(width: size.width, height: size.width), session: $session)
                        .scaleEffect(0.97)
                    ForEach(0...4, id: \.self) { index in
                        
                        let rotation = Double(index) * 90
                        
                        RoundedRectangle(cornerRadius: 2, style: .circular)
                            .trim(from: 0.61, to: 0.64)
                            .stroke(Color("cx_orange"), style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.init(degrees: rotation))
                                                
                        
                    }
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(Color("cx_orange"))
                            .frame(height: 2.5)
                            .shadow(color: .cx_orange.opacity(0.8),
                                    radius: 8, x: 0, y: isScanning ? 15 : -15)
                            .offset(y: isScanning ? size.width : 0)
                    }

                   
                    
                }
                .frame(width: size.width, height: size.width)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .padding(.horizontal, 15)
            .onAppear(perform: checkCameraPermission)
            .alert(errorMessage, isPresented: $showError) {
                //Do something
                if cameraPermission == .denied {
                    Button("Settings") {
                        let settingsString = UIApplication.openSettingsURLString
                        if let settingsUrl = URL(string: settingsString) {
                            openUrl(settingsUrl)
                        }
                    }
                }
                
                Button("Cancel", role: .cancel) {
                    //
                }
               
            }
            
            
            Spacer(minLength: 45)
            
            Button {
                //Load QR code
                if !session.isRunning && cameraPermission == .approved {
                    reactivateCamera()
                    activateScannerAnimation()
                }
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundColor(.cx_orange)
            }
            
            .padding(.horizontal, 45)


            
        }
        .padding(15)
        .background(.black)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.85).repeatForever()) {
                isScanning = true
            }
        }
        
    }
//    .onChange(of: qrDelegate.scannedCode, perform: { newValue in
//        if let code = newValue {
//            scannedCode = code
//            session.stopRunning()
//            deactivateScannerAnimation()
//            qrDelegate.scannedCode  = nil
//        }
//    })
//
    fileprivate func reactivateCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    fileprivate func activateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).repeatForever()) {
            isScanning = true
        }
    }
    
    fileprivate func deactivateScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }
    
    fileprivate func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized:
                    cameraPermission = .approved
                if session.inputs.isEmpty {
                    setupCamera()
                } else {
                    session.startRunning()
                }
                case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .approved
                    setupCamera()
                } else {
                    cameraPermission = .denied
                    presentError("Please Provide Access to Camera")
                }
                case .denied, .restricted:
                    cameraPermission = .denied
                    presentError("Please Provide Access to Camera")
            default: break
            }
        }
    }
    
    fileprivate func presentError(_ message: String) {
        errorMessage = message
        showError.toggle()
    }
    
    fileprivate func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else {
                presentError("Unknow Device Error")
                return
            }
            
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(qrOutput) else {
                presentError("Unknow Input/Output Error")
                return
            }
            
            //Adding input & output to camera session
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            qrOutput.metadataObjectTypes = [.qr]
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activateScannerAnimation()
            
        } catch {
            presentError(error.localizedDescription)
        }
    }
}

struct QrScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QrScannerView()
    }
}
