//
//  ReportesViewModel.swift
//  AppShey
//
//  ViewModel para gestionar reportes
//

import SwiftUI
import CoreData

struct GrupoAsistencia: Identifiable {
    let id = UUID()
    let fecha: Date
    let sector: String
    let semana: Int
    let tema: String
    let entidades: String
    let asistencias: [Asistencia]
}

class ReportesViewModel: ObservableObject {
    @Published var fechaSeleccionada = Date()
    @Published var sectorSeleccionado: String?
    @Published var semanaSeleccionada: Int?
    @Published var sectoresDisponibles: [String] = []
    @Published var reportesAgrupados: [Date: [GrupoAsistencia]] = [:]
    @Published var mostrarVistaPreviaReporte = false
    @Published var grupoSeleccionado: GrupoAsistencia?
    
    func inicializar() {
        sectoresDisponibles = DataController.shared.obtenerSectoresUnicos()
        if let primerSector = sectoresDisponibles.first {
            sectorSeleccionado = primerSector
        }
        cargarReportes()
    }
    
    func cargarReportes() {
        let calendar = Calendar.current
        let inicio = calendar.startOfDay(for: fechaSeleccionada)
        let fin = calendar.date(byAdding: .day, value: 1, to: inicio)!
        
        let request: NSFetchRequest<Asistencia> = Asistencia.fetchRequest()
        
        // Construir predicado dinámico
        var predicates: [NSPredicate] = []
        
        // Filtro de fecha
        predicates.append(NSPredicate(format: "fecha >= %@ AND fecha < %@", inicio as NSDate, fin as NSDate))
        
        // Filtro de sector (opcional)
        if let sector = sectorSeleccionado {
            predicates.append(NSPredicate(format: "sector == %@", sector))
        }
        
        // Filtro de semana (opcional)
        if let semana = semanaSeleccionada {
            predicates.append(NSPredicate(format: "semana == %d", semana))
        }
        
        // Combinar predicados
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Asistencia.fecha, ascending: false)]
        
        do {
            let asistencias = try DataController.shared.container.viewContext.fetch(request)
            agruparAsistencias(asistencias)
        } catch {
            print("Error al cargar reportes: \(error)")
        }
    }
    
    private func agruparAsistencias(_ asistencias: [Asistencia]) {
        var grupos: [Date: [GrupoAsistencia]] = [:]
        
        // Agrupar por fecha, sector y semana
        let dictionary = Dictionary(grouping: asistencias) { asistencia -> String in
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return "\(formatter.string(from: asistencia.fecha))_\(asistencia.sector)_\(asistencia.semana)"
        }
        
        for (_, asistenciasGrupo) in dictionary {
            guard let primera = asistenciasGrupo.first else { continue }
            
            let grupo = GrupoAsistencia(
                fecha: primera.fecha,
                sector: primera.sector,
                semana: Int(primera.semana),
                tema: primera.tema,
                entidades: primera.entidades,
                asistencias: asistenciasGrupo
            )
            
            let fecha = Calendar.current.startOfDay(for: primera.fecha)
            if grupos[fecha] != nil {
                grupos[fecha]?.append(grupo)
            } else {
                grupos[fecha] = [grupo]
            }
        }
        
        reportesAgrupados = grupos
    }
    
    func seleccionarGrupo(_ grupo: GrupoAsistencia) {
        grupoSeleccionado = grupo
        mostrarVistaPreviaReporte = true
    }
}
