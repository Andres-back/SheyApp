//
//  VistaPreviewReporteView.swift
//  AppShey
//
//  Vista previa del reporte antes de exportar
//

import SwiftUI

struct VistaPreviewReporteView: View {
    @Environment(\.dismiss) private var dismiss
    let grupo: GrupoAsistencia
    @ObservedObject var viewModel: ReportesViewModel
    @State private var mostrarCompartir = false
    @State private var pdfURL: URL?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Contenido del reporte
                    ReporteContentView(grupo: grupo)
                        .padding()
                        .background(Color.white)
                }
            }
            .background(Color(.systemGray6))
            .navigationTitle("Vista Previa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button(action: generarYCompartirPDF) {
                        Label("Exportar", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $mostrarCompartir) {
                if let pdfURL = pdfURL {
                    ShareSheet(items: [pdfURL])
                }
            }
        }
    }
    
    private func generarYCompartirPDF() {
        let pdfGenerator = PDFGenerator()
        if let url = pdfGenerator.generarReportePDF(grupo: grupo) {
            pdfURL = url
            mostrarCompartir = true
        }
    }
}

struct ReporteContentView: View {
    let grupo: GrupoAsistencia
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Encabezado
            VStack(alignment: .center, spacing: 8) {
                Text("INDERCULTURA")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("CONTROL DE ASISTENCIA")
                    .font(.headline)
                
                Divider()
                    .padding(.vertical, 5)
            }
            
            // Información de la sesión
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(label: "TEMA:", valor: grupo.tema)
                InfoRow(label: "SEMANA:", valor: "\(grupo.semana)")
                InfoRow(label: "FECHA:", valor: formatearFecha(grupo.fecha))
                InfoRow(label: "PSICOSOCIAL:", valor: "SHEYNNER CORREA JARAMILLO")
                InfoRow(label: "ENTIDADES:", valor: grupo.entidades)
                InfoRow(label: "SECTOR:", valor: grupo.sector)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Título de la tabla
            Text("REGISTRO DE ASISTENCIA")
                .font(.headline)
                .padding(.top, 10)
            
            // Tabla de asistencias
            VStack(spacing: 0) {
                // Encabezado de la tabla
                HStack(spacing: 0) {
                    Text("N°")
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(width: 40)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray5))
                    
                    Divider()
                    
                    Text("NOMBRE COMPLETO")
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray5))
                    
                    Divider()
                    
                    Text("DOCUMENTO")
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(width: 100)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray5))
                    
                    Divider()
                    
                    Text("FIRMA")
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(width: 80)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray5))
                }
                .border(Color.gray, width: 1)
                
                // Filas de asistencia
                ForEach(Array(grupo.asistencias.enumerated()), id: \.element.id) { index, asistencia in
                    HStack(spacing: 0) {
                        Text("\(index + 1)")
                            .font(.caption)
                            .frame(width: 40)
                            .padding(.vertical, 15)
                        
                        Divider()
                        
                        Text(asistencia.nino?.nombreCompleto ?? "")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                            .padding(.vertical, 15)
                        
                        Divider()
                        
                        Text(asistencia.nino?.documento ?? "")
                            .font(.caption)
                            .frame(width: 100)
                            .padding(.vertical, 15)
                        
                        Divider()
                        
                        Group {
                            if let firmaData = asistencia.firmaNino,
                               let uiImage = UIImage(data: firmaData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 30)
                            } else {
                                Image(systemName: "xmark")
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(width: 80)
                        .padding(.vertical, 15)
                    }
                    .border(Color.gray, width: 0.5)
                }
            }
            .border(Color.gray, width: 1)
            
            // Resumen
            HStack {
                Spacer()
                Text("Total de asistentes: \(grupo.asistencias.count)")
                    .font(.headline)
                    .padding(.top, 15)
            }
            
            // Firma de la trabajadora social
            VStack(alignment: .center, spacing: 30) {
                Divider()
                    .padding(.top, 40)
                
                VStack(spacing: 5) {
                    Text("_________________________________")
                    Text("Sheynner Correa Jaramillo")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("Trabajadora Social")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("Área Psicosocial - INDERCULTURA")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 30)
        }
    }
    
    private func formatearFecha(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: fecha)
    }
}

struct InfoRow: View {
    let label: String
    let valor: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 120, alignment: .leading)
            
            Text(valor)
                .font(.subheadline)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
