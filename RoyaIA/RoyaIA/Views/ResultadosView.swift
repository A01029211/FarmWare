//
//  ResultadosView.swift
//  RoyaIA
//
//  Created by Santiago Cordova on 10/09/25.
//

import SwiftUI

struct ResultadosView: View {
    var image: UIImage?
    
    var body: some View {
        VStack {
            Text("Resultados del análisis")
                .font(.title)
                .bold()
                .padding()
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(10)
            } else {
                Text("No se encontró imagen")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("Aquí irán los resultados del modelo IA")
                .foregroundColor(.secondary)
                .padding()
        }
        .navigationTitle("Resultados")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ResultadosView(image: UIImage(systemName: "leaf"))
}
