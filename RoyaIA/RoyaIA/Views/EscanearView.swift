//
//  EscanearView.swift
//  RoyaIA
//
//  Created by Santiago Cordova on 10/09/25.
//

import SwiftUI

struct EscanearView: View {
    @StateObject private var camera = CamaraManager()
    @State private var showImagePicker = false
    @State private var navigateToResults = false
    
    var body: some View{
        VStack{
            Text("Escanear Cosecha")
                .font(.title)
                .bold()
                .padding()
            
            ZStack{
                CamaraPreview(session: camera.getSession())
                    .frame(width: 300, height: 400)
                    .cornerRadius(10)
                
                
                if let image = camera.capturedImage{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 400)
                        .cornerRadius(10)
                    
                }
            }
            
            Text("Por favor asegurate que los cultivos estan enfocados y bien iluminados")
                .font(.footnote)
                .padding()
            
            HStack{
                Button{
                    camera.takePhoto()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        navigateToResults = true
                    }
                } label: {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 80, height: 80)
                        .shadow(radius: 5)
                        .overlay(Circle().stroke(Color.black, lineWidth: 3))
                }
                
                Spacer().frame(width: 40)
                
                Button {
                    showImagePicker = true
                } label: {
                    Image(systemName: "photo.on.rectangle")
                        .resizable()
                        .frame(width: 50, height: 40)
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            NavigationLink(destination: ResultadosView(image: camera.capturedImage),    isActive: $navigateToResults) {
                EmptyView()
            }
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
            if camera.capturedImage != nil {
                navigateToResults = true
            }
            }) {
                ImagePicker(selectedImage: $camera.capturedImage,
                            sourceType: .photoLibrary)
            }
        }
    }


#Preview {
    EscanearView()
}
