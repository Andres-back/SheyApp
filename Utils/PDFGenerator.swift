//
//  PDFGenerator.swift
//  AppShey
//
//  Generador de reportes en formato PDF
//

import UIKit
import PDFKit

class PDFGenerator {
    
    func generarReportePDF(grupo: GrupoAsistencia) -> URL? {
        let pdfMetaData = [
            kCGPDFContextCreator: "AppShey - INDERCULTURA",
            kCGPDFContextAuthor: "Sheynner Correa Jaramillo",
            kCGPDFContextTitle: "Reporte de Asistencia - \(grupo.sector)"
        ]
        
        let formato = UIGraphicsPDFRendererFormat()
        formato.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: formato)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            var yPosition: CGFloat = 50
            let margin: CGFloat = 50
            let contentWidth = pageWidth - (margin * 2)
            
            // Encabezado
            yPosition = dibujarEncabezado(context: context.cgContext, yPosition: yPosition, margin: margin, contentWidth: contentWidth)
            
            // Información de la sesión
            yPosition = dibujarInformacionSesion(context: context.cgContext, grupo: grupo, yPosition: yPosition, margin: margin, contentWidth: contentWidth)
            
            // Título de la tabla
            yPosition += 20
            let tituloTabla = "REGISTRO DE ASISTENCIA"
            let atributosTituloTabla: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 14)
            ]
            tituloTabla.draw(at: CGPoint(x: margin, y: yPosition), withAttributes: atributosTituloTabla)
            yPosition += 25
            
            // Tabla de asistencias
            yPosition = dibujarTablaAsistencias(context: context.cgContext, grupo: grupo, yPosition: yPosition, margin: margin, contentWidth: contentWidth)
            
            // Resumen
            yPosition += 20
            let resumen = "Total de asistentes: \(grupo.asistencias.count)"
            let atributosResumen: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 12)
            ]
            let resumenSize = resumen.size(withAttributes: atributosResumen)
            resumen.draw(at: CGPoint(x: pageWidth - margin - resumenSize.width, y: yPosition), withAttributes: atributosResumen)
            
            // Firma
            yPosition += 80
            dibujarFirma(context: context.cgContext, yPosition: yPosition, margin: margin, contentWidth: contentWidth)
        }
        
        // Guardar PDF
        let fileName = "Reporte_\(grupo.sector)_\(formatearFechaParaArchivo(grupo.fecha)).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try data.write(to: tempURL)
            return tempURL
        } catch {
            print("Error al guardar PDF: \(error)")
            return nil
        }
    }
    
    private func dibujarEncabezado(context: CGContext, yPosition: CGFloat, margin: CGFloat, contentWidth: CGFloat) -> CGFloat {
        var y = yPosition
        
        let titulo1 = "INDERCULTURA"
        let atributosTitulo1: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20)
        ]
        let titulo1Size = titulo1.size(withAttributes: atributosTitulo1)
        titulo1.draw(at: CGPoint(x: margin + (contentWidth - titulo1Size.width) / 2, y: y), withAttributes: atributosTitulo1)
        y += titulo1Size.height + 10
        
        let titulo2 = "CONTROL DE ASISTENCIA"
        let atributosTitulo2: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 14)
        ]
        let titulo2Size = titulo2.size(withAttributes: atributosTitulo2)
        titulo2.draw(at: CGPoint(x: margin + (contentWidth - titulo2Size.width) / 2, y: y), withAttributes: atributosTitulo2)
        y += titulo2Size.height + 15
        
        // Línea divisoria
        context.setStrokeColor(UIColor.gray.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: margin, y: y))
        context.addLine(to: CGPoint(x: margin + contentWidth, y: y))
        context.strokePath()
        
        return y + 20
    }
    
    private func dibujarInformacionSesion(context: CGContext, grupo: GrupoAsistencia, yPosition: CGFloat, margin: CGFloat, contentWidth: CGFloat) -> CGFloat {
        var y = yPosition
        
        let atributosLabel: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 11)
        ]
        let atributosValor: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11)
        ]
        
        let informacion = [
            ("TEMA:", grupo.tema),
            ("SEMANA:", "\(grupo.semana)"),
            ("FECHA:", formatearFecha(grupo.fecha)),
            ("PSICOSOCIAL:", "SHEYNNER CORREA JARAMILLO"),
            ("ENTIDADES:", grupo.entidades),
            ("SECTOR:", grupo.sector)
        ]
        
        for (label, valor) in informacion {
            label.draw(at: CGPoint(x: margin + 10, y: y), withAttributes: atributosLabel)
            valor.draw(at: CGPoint(x: margin + 150, y: y), withAttributes: atributosValor)
            y += 20
        }
        
        return y + 10
    }
    
    private func dibujarTablaAsistencias(context: CGContext, grupo: GrupoAsistencia, yPosition: CGFloat, margin: CGFloat, contentWidth: CGFloat) -> CGFloat {
        var y = yPosition
        
        let colNumero: CGFloat = 40
        let colDocumento: CGFloat = 100
        let colFirma: CGFloat = 80
        let colNombre = contentWidth - colNumero - colDocumento - colFirma
        
        // Encabezado de la tabla
        context.setFillColor(UIColor.systemGray5.cgColor)
        context.fill(CGRect(x: margin, y: y, width: contentWidth, height: 25))
        
        let atributosEncabezado: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 9)
        ]
        
        "N°".draw(at: CGPoint(x: margin + 10, y: y + 7), withAttributes: atributosEncabezado)
        "NOMBRE COMPLETO".draw(at: CGPoint(x: margin + colNumero + 10, y: y + 7), withAttributes: atributosEncabezado)
        "DOCUMENTO".draw(at: CGPoint(x: margin + colNumero + colNombre + 10, y: y + 7), withAttributes: atributosEncabezado)
        "FIRMA".draw(at: CGPoint(x: margin + colNumero + colNombre + colDocumento + 15, y: y + 7), withAttributes: atributosEncabezado)
        
        // Bordes del encabezado
        context.setStrokeColor(UIColor.gray.cgColor)
        context.setLineWidth(1)
        context.stroke(CGRect(x: margin, y: y, width: contentWidth, height: 25))
        
        y += 25
        
        // Filas de datos
        let atributosCelda: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 9)
        ]
        
        for (index, asistencia) in grupo.asistencias.enumerated() {
            let alturaFila: CGFloat = 40
            
            // Fondo alternado
            if index % 2 == 0 {
                context.setFillColor(UIColor.systemGray6.cgColor)
                context.fill(CGRect(x: margin, y: y, width: contentWidth, height: alturaFila))
            }
            
            // Número
            "\(index + 1)".draw(at: CGPoint(x: margin + 15, y: y + 15), withAttributes: atributosCelda)
            
            // Nombre
            let nombre = asistencia.nino?.nombreCompleto ?? ""
            nombre.draw(at: CGPoint(x: margin + colNumero + 10, y: y + 15), withAttributes: atributosCelda)
            
            // Documento
            let documento = asistencia.nino?.documento ?? ""
            documento.draw(at: CGPoint(x: margin + colNumero + colNombre + 10, y: y + 15), withAttributes: atributosCelda)
            
            // Firma
            if let firmaData = asistencia.firmaNino,
               let firma = UIImage(data: firmaData) {
                let firmaRect = CGRect(x: margin + colNumero + colNombre + colDocumento + 10, y: y + 5, width: 60, height: 30)
                firma.draw(in: firmaRect)
            }
            
            // Bordes de la fila
            context.setStrokeColor(UIColor.gray.cgColor)
            context.setLineWidth(0.5)
            context.stroke(CGRect(x: margin, y: y, width: contentWidth, height: alturaFila))
            
            y += alturaFila
        }
        
        return y
    }
    
    private func dibujarFirma(context: CGContext, yPosition: CGFloat, margin: CGFloat, contentWidth: CGFloat) {
        let atributos: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 10)
        ]
        let atributosNegrita: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 10)
        ]
        
        let lineaFirma = "_________________________________"
        let lineaSize = lineaFirma.size(withAttributes: atributos)
        let centroX = margin + (contentWidth - lineaSize.width) / 2
        
        lineaFirma.draw(at: CGPoint(x: centroX, y: yPosition), withAttributes: atributos)
        
        let nombre = "Sheynner Correa Jaramillo"
        let nombreSize = nombre.size(withAttributes: atributosNegrita)
        nombre.draw(at: CGPoint(x: centroX + (lineaSize.width - nombreSize.width) / 2, y: yPosition + 15), withAttributes: atributosNegrita)
        
        let cargo = "Trabajadora Social"
        let cargoSize = cargo.size(withAttributes: atributos)
        cargo.draw(at: CGPoint(x: centroX + (lineaSize.width - cargoSize.width) / 2, y: yPosition + 30), withAttributes: atributos)
        
        let area = "Área Psicosocial - INDERCULTURA"
        let areaSize = area.size(withAttributes: atributos)
        area.draw(at: CGPoint(x: centroX + (lineaSize.width - areaSize.width) / 2, y: yPosition + 45), withAttributes: atributos)
    }
    
    private func formatearFecha(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: fecha)
    }
    
    private func formatearFechaParaArchivo(_ fecha: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: fecha)
    }
}
