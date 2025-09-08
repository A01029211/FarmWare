//
//  imagePickerView.swift
//  RoyaIA
//
//  Created by Alumno on 08/09/25.
//

import SwiftUI

struct imagePickerView: View {
    
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var sourceType:UIImagePickerController.SourceType = .camera
    @State private var navigateToResult = false
    
    var body: some View {
        VStack{
            Text("Escanear Cosecha")
                .font(.title)
                .bold()
                .padding()
            
            ZStack{
                if let image  = selectedImage {
                    Image(uiImage : image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(10)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 300)
                        .overlay(
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 60))
                        .foregroundColor(.black)
                )
                }
            }
        }
        
    }
}

#Preview {
    imagePickerView()
}
