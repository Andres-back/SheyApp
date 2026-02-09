//
//  FirmaView.swift
//  AppShey
//
//  Vista para capturar firmas digitales
//

import SwiftUI
import PencilKit

struct FirmaView: View {
    @Environment(\.dismiss) private var dismiss
    let titulo: String
    let onGuardar: (Data) -> Void
    
    @State private var canvasView = PKCanvasView()
    @State private var mostrarAlerta = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Instrucciones
                VStack(spacing: 8) {
                    Text("Por favor, firme en el espacio a continuación")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Use su dedo o Apple Pencil")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                
                // Canvas para dibujar
                SignatureCanvasView(canvasView: $canvasView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                    .border(Color.gray.opacity(0.3), width: 2)
                    .padding()
                
                // Botones
                HStack(spacing: 15) {
                    Button(action: limpiarFirma) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Limpiar")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    Button(action: guardarFirma) {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Guardar")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(canvasView.drawing.bounds.isEmpty)
                }
                .padding()
            }
            .navigationTitle(titulo)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .alert(isPresented: $mostrarAlerta) {
                Alert(
                    title: Text("Firma Requerida"),
                    message: Text("Por favor, dibuje una firma antes de guardar."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func limpiarFirma() {
        canvasView.drawing = PKDrawing()
    }
    
    private func guardarFirma() {
        if canvasView.drawing.bounds.isEmpty {
            mostrarAlerta = true
            return
        }
        
        // Convertir el dibujo a imagen
        let drawing = canvasView.drawing
        let image = drawing.image(from: drawing.bounds, scale: 2.0)
        
        if let imageData = image.pngData() {
            onGuardar(imageData)
            dismiss()
        }
    }
}

struct SignatureCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 3)
        canvasView.backgroundColor = .white
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {}
}

#Preview {
    FirmaView(titulo: "Firma del Estudiante") { _ in
        print("Firma guardada")
    }
}
