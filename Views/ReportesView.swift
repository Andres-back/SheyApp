//
//  ReportesView.swift
//  AppShey
//
//  Vista para generar y visualizar reportes de asistencia
//

import SwiftUI

struct ReportesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = ReportesViewModel()
    @State private var mostrarFiltros = true
    @State private var animarBusqueda = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Panel de filtros mejorado
                if mostrarFiltros {
                    VStack(spacing: 0) {
                        filtrosSection
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                
                // Resultados
                resultadosSection
            }
            .navigationTitle("Reportes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            mostrarFiltros.toggle()
                        }
                    }) {
                        Image(systemName: mostrarFiltros ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                            .foregroundColor(Color("PrimaryColor"))
                            .imageScale(.large)
                    }
                }
            }
            .onAppear {
                viewModel.inicializar()
            }
            .sheet(isPresented: $viewModel.mostrarVistaPreviaReporte) {
                if let grupo = viewModel.grupoSeleccionado {
                    VistaPreviewReporteView(grupo: grupo, viewModel: viewModel)
                }
            }
        }
    }
    
    // MARK: - Filtros Section
    
    private var filtrosSection: some View {
        VStack(spacing: 16) {
            // Título de filtros
            HStack {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(Color("PrimaryColor"))
                Text("Filtros de Búsqueda")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 16)
            
            VStack(spacing: 12) {
                // Filtro de fecha con diseño mejorado
                VStack(alignment: .leading, spacing: 8) {
                    Label("Fecha", systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    DatePicker("", selection: $viewModel.fechaSeleccionada, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                        )
                }
                .padding(.horizontal)
                
                // Filtro de sector con diseño mejorado
                if !viewModel.sectoresDisponibles.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Sector", systemImage: "mappin.and.ellipse")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Menu {
                            Button("Todos los sectores", action: {
                                viewModel.sectorSeleccionado = nil
                            })
                            
                            Divider()
                            
                            ForEach(viewModel.sectoresDisponibles, id: \.self) { sector in
                                Button(action: {
                                    viewModel.sectorSeleccionado = sector
                                }) {
                                    HStack {
                                        Text(sector)
                                        if viewModel.sectorSeleccionado == sector {
                                            Spacer()
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.sectorSeleccionado ?? "Todos los sectores")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Filtro de semana
                VStack(alignment: .leading, spacing: 8) {
                    Label("Semana", systemImage: "number.circle")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 12) {
                        ForEach([nil, 1, 2, 3, 4] as [Int?], id: \.self) { semana in
                            Button(action: {
                                viewModel.semanaSeleccionada = semana
                            }) {
                                Text(semana == nil ? "Todas" : "\(semana!)")
                                    .font(.subheadline)
                                    .fontWeight(viewModel.semanaSeleccionada == semana ? .bold : .regular)
                                    .foregroundColor(viewModel.semanaSeleccionada == semana ? .white : .primary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(viewModel.semanaSeleccionada == semana ? Color.blue : Color(.systemGray6))
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Botón de búsqueda mejorado
                Button(action: {
                    withAnimation {
                        animarBusqueda = true
                    }
                    viewModel.cargarReportes()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        animarBusqueda = false
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: animarBusqueda ? "arrow.clockwise" : "magnifyingglass")
                            .rotationEffect(.degrees(animarBusqueda ? 360 : 0))
                            .animation(animarBusqueda ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: animarBusqueda)
                        Text("Buscar Reportes")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.bottom, 16)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemGray6),
                    Color(.systemGray6).opacity(0.8)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // MARK: - Resultados Section
    
    private var resultadosSection: some View {
        Group {
            if viewModel.reportesAgrupados.isEmpty {
                emptyStateView
            } else {
                reportesListView
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 50))
                    .foregroundColor(Color.blue.opacity(0.6))
            }
            
            VStack(spacing: 12) {
                Text("No hay reportes disponibles")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Ajusta los filtros para encontrar reportes\no genera uno nuevo tomando asistencia")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
    }
    
    private var reportesListView: some View {
        ScrollView {
            LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                ForEach(Array(viewModel.reportesAgrupados.keys.sorted(by: >)), id: \.self) { fecha in
                    Section {
                        ForEach(viewModel.reportesAgrupados[fecha] ?? [], id: \.sector) { grupo in
                            ReporteCardView(grupo: grupo, viewModel: viewModel)
                                .transition(.scale.combined(with: .opacity))
                        }
                    } header: {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(Color("PrimaryColor"))
                            Text(formatearFecha(fecha))
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Text("\(viewModel.reportesAgrupados[fecha]?.count ?? 0) reportes")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.systemBackground).opacity(0.95))
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
    }
    
    private func formatearFecha(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: fecha)
    }
}

struct ReporteCardView: View {
    let grupo: GrupoAsistencia
    @ObservedObject var viewModel: ReportesViewModel
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            viewModel.seleccionarGrupo(grupo)
        }) {
            VStack(alignment: .leading, spacing: 14) {
                // Encabezado con sector
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.white)
                            .font(.title3)
                        Text(grupo.sector)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.7)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    // Badge de semana
                    VStack(spacing: 2) {
                        Text("Semana")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text("\(grupo.semana)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.15))
                    .cornerRadius(10)
                }
                
                // Tema
                VStack(alignment: .leading, spacing: 4) {
                    Text("Tema")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                    Text(grupo.tema)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }
                
                // Información adicional
                HStack(spacing: 20) {
                    // Asistentes
                    HStack(spacing: 6) {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.green)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(grupo.asistencias.count)")
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("Asistentes")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                        .frame(height: 30)
                    
                    // Entidades
                    HStack(spacing: 6) {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.purple)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(grupo.entidades)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                            Text("Entidades")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                
                // Acciones
                HStack(spacing: 12) {
                    HStack(spacing: 6) {
                        Image(systemName: "eye.fill")
                        Text("Ver")
                            .fontWeight(.medium)
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Exportar")
                            .fontWeight(.medium)
                    }
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(isPressed ? 0.1 : 0.15), radius: isPressed ? 5 : 10, x: 0, y: isPressed ? 2 : 5)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}

#Preview {
    ReportesView()
        .environment(\.managedObjectContext, DataController.shared.container.viewContext)
}
