//
//  Nino.swift
//  AppShey
//
//  Modelo de datos para Menor
//

import Foundation
import CoreData

@objc(Nino)
public class Nino: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var nombreCompleto: String
    @NSManaged public var documento: String
    @NSManaged public var sector: String
    @NSManaged public var formadorACargo: String
    @NSManaged public var fechaRegistro: Date
    @NSManaged public var activo: Bool
    
    // Relaciones
    @NSManaged public var padres: NSSet?
    @NSManaged public var asistencias: NSSet?
}

// MARK: - Extensiones para relaciones
extension Nino {
    @objc(addPadresObject:)
    @NSManaged public func addToPadres(_ value: Padre)
    
    @objc(removePadresObject:)
    @NSManaged public func removeFromPadres(_ value: Padre)
    
    @objc(addPadres:)
    @NSManaged public func addToPadres(_ values: NSSet)
    
    @objc(removePadres:)
    @NSManaged public func removeFromPadres(_ values: NSSet)
    
    var padresArray: [Padre] {
        let set = padres as? Set<Padre> ?? []
        return set.sorted { $0.nombreCompleto < $1.nombreCompleto }
    }
    
    var asistenciasArray: [Asistencia] {
        let set = asistencias as? Set<Asistencia> ?? []
        return set.sorted { $0.fecha > $1.fecha }
    }
}
