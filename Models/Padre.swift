//
//  Padre.swift
//  AppShey
//
//  Modelo de datos para Padre/Madre/Acudiente
//

import Foundation
import CoreData

@objc(Padre)
public class Padre: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var nombreCompleto: String
    @NSManaged public var documento: String
    @NSManaged public var telefono: String
    @NSManaged public var parentesco: String // Padre, Madre, Acudiente
    
    // Relación
    @NSManaged public var nino: Nino?
}
