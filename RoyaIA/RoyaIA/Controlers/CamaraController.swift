//
//  CamaraController.swift
//  RoyaIA
//
//  Created by Santiago Cordova on 09/09/25.
//

import Foundation
import AVFoundation
import UIKit
import Combine

class CamaraController: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var capturedImage: UIImage?
    @Published var isSessionRunning = false
    @Published var configurationError: String?
    
    let session = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private(set) var previewLayer: AVCaptureVideoPreviewLayer?
    private var isConfigured = false
    
    func checkAndRequestPermissions(completion: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async { completion(granted) }
            }
        default:
            completion(false)
        }
    }
    
    func configuredSession() {
        guard !isConfigured else{ return }
        session.beginConfiguration()
        session.sessionPreset = .photo
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            configurationError = "No se encontró cámara trasera."
            session.commitConfiguration()
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input){
                session.addInput(input)
            }  else {
                configurationError = "Error creando el input de la camara"
                session.commitConfiguration()
                return
            }
        } catch {
            configurationError = "Error creando input de camara"
            session.commitConfiguration()
            return
        }
        
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        } else {
            configurationError = "No se pudo añadir salida de foto"
            session.commitConfiguration()
            return
        }
        
        session.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = .resizeAspectFill
        
        isConfigured = true
    }
    
    func startSession() {
        guard isConfigured else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.session.isRunning {
                self.session.startRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = true
                }
            }
        }
    }
    
    func stopSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.session.isRunning {
                self.session.stopRunning()
                DispatchQueue.main.async {
                    self.isSessionRunning = false
                }
            }
        }
    }
    
    func takePhoto() {
        let setting = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: setting, delegate: self)
    }
    
    func PhotoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error al procesar foto: \(error.localizedDescription)")
            return
        }
        guard let data = photo.fileDataRepresentation(),
              let uiImage = UIImage(data:data) else {
            print("No se pudo convertir datos a UIImage")
            return
        }
        
        DispatchQueue.main.async {
            self.capturedImage = uiImage
        }
    }
    
}
    

