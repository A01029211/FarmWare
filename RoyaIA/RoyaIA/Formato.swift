//
//  Formato.swift
//  RoyaIA
//
//  Created by Alumno on 10/09/25.
//

import SwiftUI

extension Color{
    static let appBg = Color(red: 0.89, green: 0.93, blue: 0.88)
    static let cardFill = Color.white.opacity(0.65)
    static let stroke = Color.black.opacity(0.06)
    static let accent = Color(red: 0.25, green: 0.45, blue: 0.30)
}

struct format_map<Content: View>: View{
    let content: Content
    init (@ViewBuilder content: () -> Content) {self.content = content()}
        var body: some View {
            content
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.ultraThinMaterial)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .stroke(Color.stroke, lineWidth: 1)
                        )
                )
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 6)
        }
}
