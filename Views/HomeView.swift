//
//  HomeView.swift
//  AppShey
//
//  Vista principal de inicio
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Nino.nombreCompleto, ascending: true)],
        predicate: NSPredicate(format: "activo == true"),
        animation: .default)
    private var ninos: FetchedResults<Nino>
    
    @State private var animarEncabezado = false
    @State private var animarEstadisticas = false
    @State private var animarAcciones = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Encabezado mejorado con gradiente
                    VStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color("PrimaryColor"), Color("PrimaryColor").opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .shadow(color: Color("PrimaryColor").opacity(0.3), radius: 20, x: 0, y: 10)
                            
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                        .scaleEffect(animarEncabezado ? 1.0 : 0.8)
                        .opacity(animarEncabezado ? 1.0 : 0)
                        
                        Text("INDERCULTURA")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Text("Control de Asistencia")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 6) {
                            Image(systemName: "person.badge.shield.checkmark.fill")
                                .foregroundColor(Color("PrimaryColor"))
                            Text("Sheynner Correa Jaramillo")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color("PrimaryColor").opacity(0.1))
                        .cornerRadius(20)
                        .padding(.top, 8)
                    }
                    .padding(.top, 30)
                    
                    // Estadísticas mejoradas con animación
                    VStack(spacing: 16) {
                        HStack {
                            Text("Estadísticas")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            StatCard(
                                title: "Menores Registrados",
                                value: "\(ninos.count)",
                                icon: "person.fill",
                                color: .blue,
                                delay: 0.1
                            )
                            .opacity(animarEstadisticas ? 1 : 0)
                            .offset(x: animarEstadisticas ? 0 : -50)
                            
                            StatCard(
                                title: "Sectores Activos",
                                value: "\(sectoresUnicos.count)",
                                icon: "map.fill",
                                color: .green,
                                delay: 0.2
                            )
                            .opacity(animarEstadisticas ? 1 : 0)
                            .offset(x: animarEstadisticas ? 0 : -50)
                            
                            StatCard(
                                title: "Fecha de Hoy",
                                value: fechaHoy,
                                icon: "calendar",
                                color: .orange,
                                delay: 0.3
                            )
                            .opacity(animarEstadisticas ? 1 : 0)
                            .offset(x: animarEstadisticas ? 0 : -50)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Accesos rápidos mejorados
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Accesos Rápidos")
                                .font(.title3)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            QuickActionButton(
                                title: "Registrar Nuevo Menor",
                                subtitle: "Agregar menor al sistema",
                                icon: "person.badge.plus",
                                color: .blue,
                                delay: 0.1
                            )
                            .opacity(animarAcciones ? 1 : 0)
                            .offset(y: animarAcciones ? 0 : 20)
                            
                            QuickActionButton(
                                title: "Tomar Asistencia",
                                subtitle: "Registrar firma de asistencia",
                                icon: "checklist",
                                color: .green,
                                delay: 0.2
                            )
                            .opacity(animarAcciones ? 1 : 0)
                            .offset(y: animarAcciones ? 0 : 20)
                            
                            QuickActionButton(
                                title: "Ver Reportes",
                                subtitle: "Consultar reportes y exportar PDF",
                                icon: "doc.text.magnifyingglass",
                                color: .purple,
                                delay: 0.3
                            )
                            .opacity(animarAcciones ? 1 : 0)
                            .offset(y: animarAcciones ? 0 : 20)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer(minLength: 30)
                }
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Inicio")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    animarEncabezado = true
                }
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                    animarEstadisticas = true
                }
                
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4)) {
                    animarAcciones = true
                }
            }
        }
    }
    
    private var sectoresUnicos: [String] {
        let sectores = Set(ninos.map { $0.sector })
        return Array(sectores).sorted()
    }
    
    private var fechaHoy: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: Date())
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    let delay: Double
    
    @State private var aparecer = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 65, height: 65)
                    .shadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
                
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
        )
    }
}

struct QuickActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let delay: Double
    
    @State private var presionado = false
    
    var body: some View {
        Button(action: {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                presionado = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    presionado = false
                }
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [color, color.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundColor(color)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
            )
            .scaleEffect(presionado ? 0.96 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HomeView()
        .environment(\.managedObjectContext, DataController.shared.container.viewContext)
}
