//
//  Asistencia.swift
//  AppShey
//
//  Modelo de datos para registro de asistencia
//

import Foundation
import CoreData

@objc(Asistencia)
public class Asistencia: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var fecha: Date
    @NSManaged public var sector: String
    @NSManaged public var semana: Int16
    @NSManaged public var tema: String
    @NSManaged public var entidades: String
    @NSManaged public var presente: Bool
    @NSManaged public var firmaNino: Data? // Imagen de la firma
    @NSManaged public var firmaPadre: Data? // Imagen de la firma del padre (opcional)
    @NSManaged public var observaciones: String?
    
    // Relación
    @NSManaged public var nino: Nino?
}
