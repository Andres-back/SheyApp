//
//  ContentView.swift
//  AppShey
//
//  Vista principal de la aplicación
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
                .tag(0)
            
            RegistroNinoView()
                .tabItem {
                    Label("Registro", systemImage: "person.badge.plus")
                }
                .tag(1)
            
            AsistenciaView()
                .tabItem {
                    Label("Asistencia", systemImage: "list.clipboard.fill")
                }
                .tag(2)
            
            ReportesView()
                .tabItem {
                    Label("Reportes", systemImage: "doc.text.fill")
                }
                .tag(3)
        }
        .accentColor(Color("PrimaryColor"))
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, DataController.shared.container.viewContext)
}
