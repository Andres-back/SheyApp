//
//  DataController.swift
//  AppShey
//
//  Controlador de Core Data para persistencia local
//

import CoreData
import Foundation

class DataController: ObservableObject {
    static let shared = DataController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "AppSheyModel")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error al cargar Core Data: \(error.localizedDescription)")
                fatalError("Error al inicializar base de datos")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error al guardar: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Funciones de ayuda para Niños
    
    func crearNino(nombreCompleto: String, documento: String, sector: String, formador: String) -> Nino {
        let context = container.viewContext
        let nino = Nino(context: context)
        nino.id = UUID()
        nino.nombreCompleto = nombreCompleto
        nino.documento = documento
        nino.sector = sector
        nino.formadorACargo = formador
        nino.fechaRegistro = Date()
        nino.activo = true
        
        save()
        return nino
    }
    
    func obtenerNinosPorSector(_ sector: String) -> [Nino] {
        let request: NSFetchRequest<Nino> = Nino.fetchRequest()
        request.predicate = NSPredicate(format: "sector == %@ AND activo == true", sector)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Nino.nombreCompleto, ascending: true)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error al obtener niños: \(error)")
            return []
        }
    }
    
    func obtenerSectoresUnicos() -> [String] {
        let request: NSFetchRequest<Nino> = Nino.fetchRequest()
        request.predicate = NSPredicate(format: "activo == true")
        request.propertiesToFetch = ["sector"]
        request.returnsDistinctResults = true
        
        do {
            let ninos = try container.viewContext.fetch(request)
            let sectores = Set(ninos.map { $0.sector })
            return Array(sectores).sorted()
        } catch {
            print("Error al obtener sectores: \(error)")
            return []
        }
    }
    
    // MARK: - Funciones de ayuda para Padres
    
    func agregarPadre(aNino nino: Nino, nombreCompleto: String, documento: String, telefono: String, parentesco: String) -> Padre {
        let context = container.viewContext
        let padre = Padre(context: context)
        padre.id = UUID()
        padre.nombreCompleto = nombreCompleto
        padre.documento = documento
        padre.telefono = telefono
        padre.parentesco = parentesco
        padre.nino = nino
        
        save()
        return padre
    }
    
    // MARK: - Funciones de ayuda para Asistencia
    
    func registrarAsistencia(nino: Nino, fecha: Date, sector: String, semana: Int, tema: String, entidades: String, firmaNino: Data?, firmaPadre: Data?) -> Asistencia {
        let context = container.viewContext
        let asistencia = Asistencia(context: context)
        asistencia.id = UUID()
        asistencia.fecha = fecha
        asistencia.sector = sector
        asistencia.semana = Int16(semana)
        asistencia.tema = tema
        asistencia.entidades = entidades
        asistencia.presente = true
        asistencia.firmaNino = firmaNino
        asistencia.firmaPadre = firmaPadre
        asistencia.nino = nino
        
        save()
        return asistencia
    }
    
    func obtenerAsistencias(fecha: Date, sector: String) -> [Asistencia] {
        let calendar = Calendar.current
        let inicio = calendar.startOfDay(for: fecha)
        let fin = calendar.date(byAdding: .day, value: 1, to: inicio)!
        
        let request: NSFetchRequest<Asistencia> = Asistencia.fetchRequest()
        request.predicate = NSPredicate(format: "fecha >= %@ AND fecha < %@ AND sector == %@", inicio as NSDate, fin as NSDate, sector)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Asistencia.nino?.nombreCompleto, ascending: true)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error al obtener asistencias: \(error)")
            return []
        }
    }
}
