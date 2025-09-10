//
//  HIstorialView.swift
//  RoyaIA
//
//  Created by Alumno on 04/09/25.
//


import SwiftUI

struct HistoryView: View {
    // Mock data
    let data: [String: [String]] = [
        "Apr 1, 2025": ["Roya1", "Roya2"],
        "Apr 2, 2025": ["Roya2", "Roya3", "Roya1"],
        "Apr 3, 2025": ["Roya3", "Roya1", "Roya2"]
    ]
    
    // State variables
    @State private var showCalendar = false
    @State private var selectedDate: Date? = nil
    
    // Formatter for date strings
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy" // matches your keys
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 40) {
                        ForEach(
                            data.keys.sorted().filter { key in
                                guard let selected = selectedDate else { return true }
                                guard let date = dateFormatter.date(from: key) else { return false }
                                return Calendar.current.isDate(date, inSameDayAs: selected)
                            },
                            id: \.self
                        ) { date in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(date)
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(data[date]!, id: \.self) { imageName in
                                            NavigationLink(destination: AnalysisView(imageName: imageName)) {
                                                Image(imageName)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 110, height: 90)
                                                    .clipped()
                                                    .cornerRadius(8)
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                
                // Export button
                Button(action: {
                    print("Export PDF tapped")
                }) {
                    Text("Exportar PDF")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                // Bottom tab bar
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "camera.viewfinder")
                        Text("Escanear")
                            .font(.caption)
                    }
                    .foregroundColor(.green)
                    Spacer()
                    VStack {
                        Image(systemName: "clock")
                        Text("Historial")
                            .font(.caption)
                    }
                    Spacer()
                    VStack {
                        Image(systemName: "person.fill")
                        Text("Cuenta")
                            .font(.caption)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(radius: 5)
            }
            .navigationTitle("Historial & Compartir")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCalendar.toggle()
                    }) {
                        Image(systemName: "calendar")
                    }
                }
            }
            .sheet(isPresented: $showCalendar) {
                VStack {
                    DatePicker(
                        "Selecciona una fecha",
                        selection: Binding(
                            get: { selectedDate ?? Date() },
                            set: { selectedDate = $0 }
                        ),
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .padding()
                    
                    HStack {
                        Button("Cerrar") {
                            showCalendar = false
                        }
                        .padding()
                        
                        Button("Mostrar todas") {
                            selectedDate = nil
                            showCalendar = false
                        }
                        .padding()
                    }
                }
            }
            .background(Color(red: 0.93, green: 0.96, blue: 0.91).ignoresSafeArea()) // light green background
        }
    }
}

struct AnalysisView: View {
    let imageName: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 300)
            
            Text("Aquí va el análisis de la imagen...")
                .padding()
            
            Spacer()
        }
        .navigationTitle("Análisis")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
