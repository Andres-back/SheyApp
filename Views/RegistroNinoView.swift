//
//  RegistroNinoView.swift
//  AppShey
//
//  Vista para registrar nuevos menores
//

import SwiftUI

struct RegistroNinoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var nombreCompleto = ""
    @State private var documento = ""
    @State private var sector = ""
    @State private var formador = ""
    
    // Información de padres
    @State private var padres: [PadreTemp] = []
    @State private var mostrarFormularioPadre = false
    
    @State private var mostrarAlerta = false
    @State private var mensajeAlerta = ""
    @State private var registroExitoso = false
    
    @FocusState private var campoEnfocado: Campo?
    
    enum Campo: Hashable {
        case nombreCompleto, documento, sector, formador
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Encabezado informativo
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color("PrimaryColor"), Color("PrimaryColor").opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: Color("PrimaryColor").opacity(0.3), radius: 15, x: 0, y: 8)
                            
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 35))
                                .foregroundColor(.white)
                        }
                        
                        Text("Registrar Nuevo Menor")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Complete todos los campos requeridos")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Sección de información del menor
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(Color("PrimaryColor"))
                            Text("Información del Menor")
                                .font(.headline)
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 16) {
                            CampoTextoMejorado(
                                titulo: "Nombre Completo",
                                placeholder: "Ingrese el nombre completo",
                                texto: $nombreCompleto,
                                icono: "person.fill",
                                esValido: !nombreCompleto.isEmpty
                            )
                            .focused($campoEnfocado, equals: .nombreCompleto)
                            
                            CampoTextoMejorado(
                                titulo: "Documento de Identidad",
                                placeholder: "Número de documento",
                                texto: $documento,
                                icono: "doc.text.fill",
                                teclado: .numberPad,
                                esValido: !documento.isEmpty && documento.count >= 6
                            )
                            .focused($campoEnfocado, equals: .documento)
                            
                            CampoTextoMejorado(
                                titulo: "Sector",
                                placeholder: "Ej: Centro, Norte, Sur",
                                texto: $sector,
                                icono: "map.fill",
                                esValido: !sector.isEmpty
                            )
                            .focused($campoEnfocado, equals: .sector)
                            
                            CampoTextoMejorado(
                                titulo: "Formador a Cargo",
                                placeholder: "Nombre del formador",
                                texto: $formador,
                                icono: "person.badge.shield.checkmark.fill",
                                esValido: !formador.isEmpty
                            )
                            .focused($campoEnfocado, equals: .formador)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal)
                    
                    // Sección de padres/acudientes
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "person.2.circle.fill")
                                .foregroundColor(.blue)
                            Text("Padres/Acudientes")
                                .font(.headline)
                            
                            Spacer()
                            
                            Circle()
                                .fill(padres.isEmpty ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                                .frame(width: 8, height: 8)
                        }
                        .padding(.horizontal)
                        
                        if padres.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "person.2.slash")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondary)
                                
                                Text("No hay padres/acudientes registrados")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Text("Agregue al menos un padre o acudiente")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 30)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(padres) { padre in
                                    TarjetaPadre(padre: padre, eliminarAction: {
                                        eliminarPadre(padre: padre)
                                    })
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Button(action: {
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                            mostrarFormularioPadre = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Agregar Padre/Acudiente")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal)
                    
                    // Indicador de progreso
                    if !formularioValido {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text("Faltan campos por completar")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.orange)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                if nombreCompleto.isEmpty {
                                    Label("Nombre completo del menor", systemImage: "circle")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                if documento.isEmpty {
                                    Label("Documento de identidad", systemImage: "circle")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                if sector.isEmpty {
                                    Label("Sector de residencia", systemImage: "circle")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                if formador.isEmpty {
                                    Label("Formador a cargo", systemImage: "circle")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                if padres.isEmpty {
                                    Label("Al menos un padre/acudiente", systemImage: "circle")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                    
                    // Botón de registro
                    Button(action: guardarNino) {
                        HStack(spacing: 12) {
                            Image(systemName: formularioValido ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.title3)
                            Text("Registrar Menor")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: formularioValido ?
                                    [Color.green, Color.green.opacity(0.8)] :
                                    [Color.gray.opacity(0.5), Color.gray.opacity(0.3)]
                                ),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: formularioValido ? Color.green.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
                    }
                    .disabled(!formularioValido)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Registro")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $mostrarFormularioPadre) {
                FormularioPadreView(padres: $padres)
            }
            .alert(isPresented: $mostrarAlerta) {
                Alert(
                    title: Text(registroExitoso ? "✅ Éxito" : "❌ Error"),
                    message: Text(mensajeAlerta),
                    dismissButton: .default(Text("OK")) {
                        if registroExitoso {
                            limpiarFormulario()
                        }
                    }
                )
            }
        }
    }
    
    private var formularioValido: Bool {
        !nombreCompleto.isEmpty &&
        !documento.isEmpty &&
        !sector.isEmpty &&
        !formador.isEmpty &&
        !padres.isEmpty
    }
    
    private func guardarNino() {
        let nino = DataController.shared.crearNino(
            nombreCompleto: nombreCompleto.trimmingCharacters(in: .whitespaces),
            documento: documento.trimmingCharacters(in: .whitespaces),
            sector: sector.trimmingCharacters(in: .whitespaces),
            formador: formador.trimmingCharacters(in: .whitespaces)
        )
        
        // Agregar padres
        for padre in padres {
            _ = DataController.shared.agregarPadre(
                aNino: nino,
                nombreCompleto: padre.nombreCompleto,
                documento: padre.documento,
                telefono: padre.telefono,
                parentesco: padre.parentesco
            )
        }
        
        registroExitoso = true
        mensajeAlerta = "El menor \(nombreCompleto) ha sido registrado exitosamente."
        mostrarAlerta = true
    }
    
    private func limpiarFormulario() {
        nombreCompleto = ""
        documento = ""
        sector = ""
        formador = ""
        padres = []
    }
    
    private func eliminarPadre(padre: PadreTemp) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        if let index = padres.firstIndex(where: { $0.id == padre.id }) {
            withAnimation {
                padres.remove(at: index)
            }
        }
    }
}

// Componente de campo de texto mejorado
struct CampoTextoMejorado: View {
    let titulo: String
    let placeholder: String
    @Binding var texto: String
    let icono: String
    var teclado: UIKeyboardType = .default
    var esValido: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(titulo)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if !texto.isEmpty {
                    Image(systemName: esValido ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .foregroundColor(esValido ? .green : .orange)
                        .font(.caption)
                }
            }
            
            HStack(spacing: 12) {
                Image(systemName: icono)
                    .foregroundColor(Color("PrimaryColor"))
                    .frame(width: 20)
                
                TextField(placeholder, text: $texto)
                    .keyboardType(teclado)
                    .autocapitalization(.words)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        !texto.isEmpty && esValido ? Color.green.opacity(0.5) : Color.clear,
                        lineWidth: 1.5
                    )
            )
        }
    }
}

// Tarjeta de padre mejorada
struct TarjetaPadre: View {
    let padre: PadreTemp
    let eliminarAction: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: iconoParentesco(padre.parentesco))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(padre.nombreCompleto)
                    .font(.headline)
                
                HStack(spacing: 8) {
                    Label(padre.parentesco, systemImage: "person.fill")
                    Label(padre.documento, systemImage: "doc.text")
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                Label(padre.telefono, systemImage: "phone.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: eliminarAction) {
                Image(systemName: "trash.circle.fill")
                    .font(.title2)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
    
    private func iconoParentesco(_ parentesco: String) -> String {
        switch parentesco {
        case "Padre": return "person.fill"
        case "Madre": return "heart.fill"
        case "Acudiente": return "person.badge.shield.checkmark"
        case "Abuelo/a": return "figure.walk"
        case "Tío/a": return "person.2.fill"
        default: return "person.fill"
        }
    }
}

// Estructura temporal para manejar padres antes de guardar
struct PadreTemp: Identifiable {
    let id = UUID()
    var nombreCompleto: String
    var documento: String
    var telefono: String
    var parentesco: String
}

struct FormularioPadreView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var padres: [PadreTemp]
    
    @State private var nombreCompleto = ""
    @State private var documento = ""
    @State private var telefono = ""
    @State private var parentesco = "Padre"
    
    @FocusState private var campoEnfocado: CampoForm?
    
    enum CampoForm: Hashable {
        case nombre, documento, telefono
    }
    
    let parentescos = ["Padre", "Madre", "Acudiente", "Abuelo/a", "Tío/a", "Otro"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Encabezado
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: Color.blue.opacity(0.3), radius: 15, x: 0, y: 8)
                            
                            Image(systemName: "person.badge.plus.fill")
                                .font(.system(size: 35))
                                .foregroundColor(.white)
                        }
                        
                        Text("Agregar Padre/Acudiente")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Ingrese la información del responsable")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Campos del formulario
                    VStack(spacing: 16) {
                        CampoTextoMejorado(
                            titulo: "Nombre Completo",
                            placeholder: "Ingrese el nombre completo",
                            texto: $nombreCompleto,
                            icono: "person.fill",
                            esValido: !nombreCompleto.isEmpty && nombreCompleto.count >= 3
                        )
                        .focused($campoEnfocado, equals: .nombre)
                        
                        CampoTextoMejorado(
                            titulo: "Documento de Identidad",
                            placeholder: "Número de documento",
                            texto: $documento,
                            icono: "doc.text.fill",
                            teclado: .numberPad,
                            esValido: !documento.isEmpty && documento.count >= 6
                        )
                        .focused($campoEnfocado, equals: .documento)
                        
                        CampoTextoMejorado(
                            titulo: "Teléfono",
                            placeholder: "Número de contacto",
                            texto: $telefono,
                            icono: "phone.fill",
                            teclado: .phonePad,
                            esValido: !telefono.isEmpty && telefono.count >= 7
                        )
                        .focused($campoEnfocado, equals: .telefono)
                        
                        // Selector de parentesco mejorado
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Parentesco")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 8) {
                                ForEach(parentescos, id: \.self) { tipo in
                                    Button(action: {
                                        let generator = UIImpactFeedbackGenerator(style: .light)
                                        generator.impactOccurred()
                                        parentesco = tipo
                                    }) {
                                        HStack(spacing: 12) {
                                            Image(systemName: iconoParentesco(tipo))
                                                .foregroundColor(parentesco == tipo ? .white : Color("PrimaryColor"))
                                                .frame(width: 30)
                                            
                                            Text(tipo)
                                                .font(.body)
                                                .fontWeight(parentesco == tipo ? .semibold : .regular)
                                            
                                            Spacer()
                                            
                                            if parentesco == tipo {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(.white)
                                            }
                                        }
                                        .foregroundColor(parentesco == tipo ? .white : .primary)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(
                                                    parentesco == tipo ?
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    ) :
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color(.systemGray6), Color(.systemGray6)]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                        )
                                        .shadow(
                                            color: parentesco == tipo ? Color.blue.opacity(0.3) : Color.clear,
                                            radius: 8, x: 0, y: 4
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 4)
                    )
                    .padding(.horizontal)
                    
                    // Botón de agregar
                    Button(action: {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        guardarPadre()
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: formularioValido ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.title3)
                            Text("Agregar Responsable")
                                .fontWeight(.bold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: formularioValido ?
                                    [Color.blue, Color.blue.opacity(0.8)] :
                                    [Color.gray.opacity(0.5), Color.gray.opacity(0.3)]
                                ),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: formularioValido ? Color.blue.opacity(0.3) : Color.clear, radius: 10, x: 0, y: 5)
                    }
                    .disabled(!formularioValido)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Nuevo Responsable")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle.fill")
                            Text("Cancelar")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    private var formularioValido: Bool {
        !nombreCompleto.isEmpty &&
        nombreCompleto.count >= 3 &&
        !documento.isEmpty &&
        documento.count >= 6 &&
        !telefono.isEmpty &&
        telefono.count >= 7
    }
    
    private func guardarPadre() {
        let nuevoPadre = PadreTemp(
            nombreCompleto: nombreCompleto.trimmingCharacters(in: .whitespaces),
            documento: documento.trimmingCharacters(in: .whitespaces),
            telefono: telefono.trimmingCharacters(in: .whitespaces),
            parentesco: parentesco
        )
        
        padres.append(nuevoPadre)
        dismiss()
    }
    
    private func iconoParentesco(_ parentesco: String) -> String {
        switch parentesco {
        case "Padre": return "person.fill"
        case "Madre": return "heart.fill"
        case "Acudiente": return "person.badge.shield.checkmark"
        case "Abuelo/a": return "figure.walk"
        case "Tío/a": return "person.2.fill"
        default: return "person.fill"
        }
    }
}

#Preview {
    RegistroNinoView()
        .environment(\.managedObjectContext, DataController.shared.container.viewContext)
}
