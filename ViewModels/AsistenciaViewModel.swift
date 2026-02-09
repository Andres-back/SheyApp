//
//  AsistenciaViewModel.swift
//  AppShey
//
//  ViewModel para gestionar el control de asistencia
//

import SwiftUI
import CoreData

class AsistenciaViewModel: ObservableObject {
    @Published var fecha = Date()
    @Published var semana = 1
    @Published var tema = ""
    @Published var entidades = ""
    @Published var sectorSeleccionado: String?
    @Published var sectoresDisponibles: [String] = []
    @Published var ninos: [Nino] = []
    
    // Almacenamiento temporal de firmas
    @Published var firmasNinos: [UUID: Data] = [:]
    @Published var firmasPadres: [UUID: Data] = [:]
    
    // Alertas
    @Published var mostrarAlerta = false
    @Published var tituloAlerta = ""
    @Published var mensajeAlerta = ""
    @Published var registroExitoso = false
    
    var formularioValido: Bool {
        !tema.isEmpty &&
        !entidades.isEmpty &&
        firmasNinos.count == ninos.count
    }
    
    func cargarSectores() {
        sectoresDisponibles = DataController.shared.obtenerSectoresUnicos()
    }
    
    func seleccionarSector(_ sector: String) {
        sectorSeleccionado = sector
        ninos = DataController.shared.obtenerNinosPorSector(sector)
    }
    
    func contarNinosPorSector(_ sector: String) -> Int {
        DataController.shared.obtenerNinosPorSector(sector).count
    }
    
    func guardarFirmaNino(nino: Nino, firma: Data) {
        firmasNinos[nino.id] = firma
    }
    
    func guardarFirmaPadre(nino: Nino, firma: Data) {
        firmasPadres[nino.id] = firma
    }
    
    func tieneFirmaNino(_ nino: Nino) -> Bool {
        firmasNinos[nino.id] != nil
    }
    
    func tieneFirmaPadre(_ nino: Nino) -> Bool {
        firmasPadres[nino.id] != nil
    }
    
    func finalizarAsistencia() {
        guard let sector = sectorSeleccionado else { return }
        
        // Guardar asistencias
        for nino in ninos {
            _ = DataController.shared.registrarAsistencia(
                nino: nino,
                fecha: fecha,
                sector: sector,
                semana: semana,
                tema: tema,
                entidades: entidades,
                firmaNino: firmasNinos[nino.id],
                firmaPadre: firmasPadres[nino.id]
            )
        }
        
        registroExitoso = true
        tituloAlerta = "Asistencia Registrada"
        mensajeAlerta = "Se ha registrado la asistencia de \(ninos.count) menores exitosamente."
        mostrarAlerta = true
    }
    
    func resetear() {
        sectorSeleccionado = nil
        tema = ""
        entidades = ""
        firmasNinos.removeAll()
        firmasPadres.removeAll()
        ninos = []
    }
}
