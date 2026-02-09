//
//  AsistenciaView.swift
//  AppShey
//
//  Vista para tomar asistencia por sector
//

import SwiftUI

struct AsistenciaView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = AsistenciaViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.sectorSeleccionado == nil {
                    // Vista de selección de sector
                    SeleccionSectorView(viewModel: viewModel)
                } else {
                    // Vista de lista de asistencia
                    ListaAsistenciaView(viewModel: viewModel)
                }
            }
            .navigationTitle("Control de Asistencia")
        }
    }
}

struct SeleccionSectorView: View {
    @ObservedObject var viewModel: AsistenciaViewModel
    @State private var animarEntrada = false
    @State private var mostrarConfiguracion = true
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Banner superior
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color("PrimaryColor"))
                        .shadow(color: Color("PrimaryColor").opacity(0.3), radius: 10)
                    
                    Text("Control de Asistencia")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Configure su sesión y seleccione el sector")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 20)
                .opacity(animarEntrada ? 1 : 0)
                .offset(y: animarEntrada ? 0 : -20)
                
                // Información de la sesión con diseño mejorado
                VStack(spacing: 0) {
                    // Header
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            mostrarConfiguracion.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(Color("PrimaryColor"))
                            Text("Configuración de Sesión")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: mostrarConfiguracion ? "chevron.up" : "chevron.down")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                    }
                    
                    // Campos de configuración
                    if mostrarConfiguracion {
                        VStack(spacing: 16) {
                            // Fecha con icono
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Fecha de la Sesión", systemImage: "calendar")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                DatePicker("", selection: $viewModel.fecha, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                                    .labelsHidden()
                            }
                            
                            Divider()
                            
                            // Semana con diseño mejorado
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Semana del Mes", systemImage: "calendar.badge.clock")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                HStack(spacing: 12) {
                                    ForEach(1...4, id: \.self) { semana in
                                        Button(action: {
                                            viewModel.semana = semana
                                        }) {
                                            VStack(spacing: 4) {
                                                Text("\(semana)")
                                                    .font(.title2)
                                                    .fontWeight(.bold)
                                                Text("Semana")
                                                    .font(.caption2)
                                            }
                                            .foregroundColor(viewModel.semana == semana ? .white : .primary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(viewModel.semana == semana ?
                                                         LinearGradient(gradient: Gradient(colors: [Color("PrimaryColor"), Color("PrimaryColor").opacity(0.7)]), startPoint: .topLeading, endPoint: .bottomTrailing) :
                                                         LinearGradient(gradient: Gradient(colors: [Color(.systemGray5), Color(.systemGray6)]), startPoint: .top, endPoint: .bottom)
                                                    )
                                                    .shadow(color: viewModel.semana == semana ? Color("PrimaryColor").opacity(0.3) : Color.clear, radius: 5)
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            
                            Divider()
                            
                            // Tema
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Tema de la Sesión", systemImage: "text.bubble.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                TextField("Ej: Valores y convivencia", text: $viewModel.tema)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                            }
                            
                            // Entidades
                            VStack(alignment: .leading, spacing: 8) {
                                Label("Entidades Participantes", systemImage: "building.2.fill")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                TextField("Ej: Alcaldía, ICBF", text: $viewModel.entidades)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                .padding(.horizontal)
                .opacity(animarEntrada ? 1 : 0)
                .offset(y: animarEntrada ? 0 : 20)
                
                // Selección de sector mejorado
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(Color("PrimaryColor"))
                        Text("Seleccione el Sector")
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                    
                    if viewModel.sectoresDisponibles.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.orange)
                            Text("No hay sectores disponibles")
                                .font(.headline)
                            Text("Registre menores primero para ver sectores")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    } else {
                        ForEach(Array(viewModel.sectoresDisponibles.enumerated()), id: \.element) { index, sector in
                            SectorCardView(
                                sector: sector,
                                numeroMenores: viewModel.contarNinosPorSector(sector),
                                accion: {
                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.impactOccurred()
                                    viewModel.seleccionarSector(sector)
                                }
                            )
                            .opacity(animarEntrada ? 1 : 0)
                            .offset(x: animarEntrada ? 0 : -20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animarEntrada)
                        }
                        .padding(.horizontal)
                    }
                }
                .opacity(animarEntrada ? 1 : 0)
                .offset(y: animarEntrada ? 0 : 30)
                
                Spacer(minLength: 20)
            }
            .padding(.vertical)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemGroupedBackground),
                    Color(.systemBackground)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onAppear {
            viewModel.cargarSectores()
            withAnimation(.easeOut(duration: 0.6)) {
                animarEntrada = true
            }
        }
    }
}

// Nuevo componente para tarjeta de sector
struct SectorCardView: View {
    let sector: String
    let numeroMenores: Int
    let accion: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: accion) {
            HStack(spacing: 16) {
                // Ícono con gradiente
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.blue.opacity(0.3), radius: 5)
                    
                    Image(systemName: "mappin.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(sector)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "person.3.fill")
                            .font(.caption)
                        Text("\(numeroMenores) menor\(numeroMenores != 1 ? "es" : "") registrado\(numeroMenores != 1 ? "s" : "")")
                            .font(.subheadline)
                    }
                    .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(Color("PrimaryColor"))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(isPressed ? 0.1 : 0.15), radius: isPressed ? 5 : 8, x: 0, y: isPressed ? 2 : 4)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                }
        )
    }
}

struct ListaAsistenciaView: View {
    @ObservedObject var viewModel: AsistenciaViewModel
    @State private var progreso: CGFloat = 0
    @State private var mostrarProgreso = true
    
    var firmasCompletadas: Int {
        viewModel.firmasNinos.count
    }
    
    var totalMenores: Int {
        viewModel.ninos.count
    }
    
    var progresoPorcentaje: Double {
        guard totalMenores > 0 else { return 0 }
        return Double(firmasCompletadas) / Double(totalMenores)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Encabezado mejorado con gradiente
            VStack(spacing: 0) {
                // Información de la sesión
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.white)
                            Text(viewModel.sectorSeleccionado ?? "")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        
                        HStack(spacing: 12) {
                            Label("Semana \(viewModel.semana)", systemImage: "calendar")
                            Label(formatearFecha(viewModel.fecha), systemImage: "clock")
                        }
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.sectorSeleccionado = nil
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.left")
                            Text("Cambiar")
                        }
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                    }
                }
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("PrimaryColor"), Color("PrimaryColor").opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                
                // Barra de progreso mejorada
                if mostrarProgreso {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Progreso de Firmas")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Spacer()
                            Text("\(firmasCompletadas)/\(totalMenores)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(firmasCompletadas == totalMenores ? .green : Color("PrimaryColor"))
                        }
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray5))
                                .frame(height: 12)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            firmasCompletadas == totalMenores ? Color.green : Color("PrimaryColor"),
                                            firmasCompletadas == totalMenores ? Color.green.opacity(0.7) : Color("PrimaryColor").opacity(0.7)
                                        ]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: progreso, height: 12)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: progreso)
                        }
                        
                        if firmasCompletadas == totalMenores && totalMenores > 0 {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("¡Todas las firmas completadas!")
                                    .font(.caption)
                            }
                            .foregroundColor(.green)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                }
            }
            
            // Lista de niños con mejor diseño
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(Array(viewModel.ninos.enumerated()), id: \.element.id) { index, nino in
                        NinoAsistenciaRow(
                            nino: nino,
                            numero: index + 1,
                            viewModel: viewModel
                        )
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .opacity
                        ))
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            
            // Botón para finalizar mejorado
            VStack(spacing: 0) {
                if !viewModel.formularioValido {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("Complete todas las firmas de menores antes de finalizar")
                            .font(.caption)
                    }
                    .foregroundColor(.orange)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .background(Color.orange.opacity(0.1))
                }
                
                Button(action: {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    viewModel.finalizarAsistencia()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: viewModel.formularioValido ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .font(.title3)
                        Text("Finalizar y Generar Reporte")
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: viewModel.formularioValido ?
                                [Color.green, Color.green.opacity(0.8)] :
                                [Color.gray.opacity(0.5), Color.gray.opacity(0.3)]
                            ),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(0)
                }
                .disabled(!viewModel.formularioValido)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $viewModel.mostrarAlerta) {
            Alert(
                title: Text(viewModel.tituloAlerta),
                message: Text(viewModel.mensajeAlerta),
                dismissButton: .default(Text("OK")) {
                    if viewModel.registroExitoso {
                        viewModel.resetear()
                    }
                }
            )
        }
        .onAppear {
            actualizarProgreso()
        }
        .onChange(of: firmasCompletadas) { _ in
            actualizarProgreso()
        }
    }
    
    private func actualizarProgreso() {
        guard totalMenores > 0 else { return }
        let anchoTotal = UIScreen.main.bounds.width - 32
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            progreso = anchoTotal * CGFloat(progresoPorcentaje)
        }
    }
    
    private func formatearFecha(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: fecha)
    }
}

struct NinoAsistenciaRow: View {
    let nino: Nino
    let numero: Int
    @ObservedObject var viewModel: AsistenciaViewModel
    @State private var mostrarFirmaNino = false
    @State private var mostrarFirmaPadre = false
    @State private var expandido = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    expandido.toggle()
                }
            }) {
                HStack(spacing: 12) {
                    // Número con badge
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("PrimaryColor"), Color("PrimaryColor").opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                        
                        Text("\(numero)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    
                    // Información del niño
                    VStack(alignment: .leading, spacing: 4) {
                        Text(nino.nombreCompleto)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        HStack(spacing: 12) {
                            Label(nino.documento, systemImage: "person.text.rectangle")
                            Label(nino.formadorACargo, systemImage: "person.fill")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // Indicador de estado
                    VStack(spacing: 4) {
                        if viewModel.tieneFirmaNino(nino) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "circle")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                        
                        if viewModel.tieneFirmaPadre(nino) {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Image(systemName: expandido ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .buttonStyle(PlainButtonStyle())
            
            // Botones de firma (expandible)
            if expandido {
                VStack(spacing: 12) {
                    Divider()
                    
                    // Firma del niño
                    Button(action: {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        mostrarFirmaNino = true
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(viewModel.tieneFirmaNino(nino) ? Color.green.opacity(0.2) : Color.blue.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: viewModel.tieneFirmaNino(nino) ? "checkmark" : "pencil")
                                    .foregroundColor(viewModel.tieneFirmaNino(nino) ? .green : .blue)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.tieneFirmaNino(nino) ? "Firma Registrada" : "Firmar Asistencia")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                
                                Text(viewModel.tieneFirmaNino(nino) ? "Toque para cambiar" : "Toque aquí para firmar")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if viewModel.tieneFirmaNino(nino) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title3)
                            } else {
                                Image(systemName: "arrow.right.circle")
                                    .foregroundColor(.blue)
                                    .font(.title3)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(viewModel.tieneFirmaNino(nino) ? Color.green.opacity(0.1) : Color.blue.opacity(0.1))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.tieneFirmaNino(nino) ? Color.green : Color.blue, lineWidth: 1.5)
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Firma del padre (opcional)
                    Button(action: {
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        mostrarFirmaPadre = true
                    }) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(viewModel.tieneFirmaPadre(nino) ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: viewModel.tieneFirmaPadre(nino) ? "checkmark" : "person.badge.plus")
                                    .foregroundColor(viewModel.tieneFirmaPadre(nino) ? .green : .orange)
                                    .font(.caption)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Text(viewModel.tieneFirmaPadre(nino) ? "Firma Padre Registrada" : "Firma Padre/Acudiente")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                    
                                    Text("(Opcional)")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(4)
                                }
                                
                                Text(viewModel.tieneFirmaPadre(nino) ? "Toque para cambiar" : "Toque si está presente")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if viewModel.tieneFirmaPadre(nino) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "arrow.right.circle")
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(viewModel.tieneFirmaPadre(nino) ? Color.green.opacity(0.1) : Color.orange.opacity(0.05))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(viewModel.tieneFirmaPadre(nino) ? Color.green : Color.orange.opacity(0.5), lineWidth: 1)
                                .strokeStyle(lineWidth: 1, dash: viewModel.tieneFirmaPadre(nino) ? [] : [5, 3])
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal)
                .padding(.bottom)
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .sheet(isPresented: $mostrarFirmaNino) {
            FirmaView(titulo: "Firma de \(nino.nombreCompleto)") { firmaData in
                viewModel.guardarFirmaNino(nino: nino, firma: firmaData)
            }
        }
        .sheet(isPresented: $mostrarFirmaPadre) {
            FirmaView(titulo: "Firma del Padre/Acudiente") { firmaData in
                viewModel.guardarFirmaPadre(nino: nino, firma: firmaData)
            }
        }
    }
}

#Preview {
    AsistenciaView()
        .environment(\.managedObjectContext, DataController.shared.container.viewContext)
}
