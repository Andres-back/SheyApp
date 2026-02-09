//
//  AppSheyApp.swift
//  AppShey - Control de Asistencia Indercultura
//
//  Aplicación para registro y control de asistencia de menores
//  Trabajadora Social: Sheynner Correa Jaramillo
//

import SwiftUI

@main
struct AppSheyApp: App {
    @StateObject private var dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
