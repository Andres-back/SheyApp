# Changelog - AppShey

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [1.0.0] - 2026-02-08

### 🎉 Lanzamiento Inicial

Primera versión completa de AppShey - Control de Asistencia para INDERCULTURA.

### ✨ Agregado

#### Funcionalidades Principales
- **Pantalla de Inicio**
  - Estadísticas de menores registrados
  - Contador de sectores activos
  - Fecha actual
  - Accesos rápidos a funciones principales

- **Registro de Menores**
  - Formulario completo para datos del menor
  - Campos: Nombre, documento, sector, formador
  - Registro de múltiples padres/acudientes
  - Información de contacto: documento, teléfono, parentesco
  - Validación de campos requeridos
  - Mensajes de confirmación

- **Control de Asistencia**
  - Configuración de sesión (fecha, semana, tema, entidades)
  - Selección de sector
  - Lista automática de menores por sector
  - Captura de firma digital del menor
  - Captura de firma digital del padre (opcional)
  - Indicadores visuales de firmas completadas
  - Generación automática de reporte al finalizar

- **Captura de Firmas Digitales**
  - Canvas de dibujo con PencilKit
  - Compatible con dedo y Apple Pencil
  - Botón para limpiar y repetir firma
  - Vista previa antes de guardar
  - Conversión a imagen PNG

- **Generación de Reportes**
  - Listado de reportes por fecha y sector
  - Filtros personalizables
  - Vista previa del reporte completo
  - Exportación a PDF profesional
  - Opción de compartir (correo, WhatsApp, AirDrop, etc.)

- **Formato de Reporte**
  - Encabezado con logo INDERCULTURA
  - Información de la trabajadora social (Sheynner Correa Jaramillo)
  - Datos de la sesión (tema, semana, fecha, entidades, sector)
  - Tabla numerada con: N°, Nombre completo, Documento, Firma
  - Total de asistentes
  - Firma de la trabajadora social

#### Componentes Técnicos
- **Base de Datos Local**
  - Core Data implementado
  - 3 entidades: Nino, Padre, Asistencia
  - Relaciones configuradas
  - Persistencia local segura
  - DataController con funciones helper

- **Arquitectura MVVM**
  - ViewModels para Asistencia y Reportes
  - Separación de lógica y vista
  - Código mantenible y escalable

- **UI/UX**
  - Diseño profesional con SwiftUI
  - Tema de colores INDERCULTURA
  - Iconografía SF Symbols
  - Navegación por pestañas (TabView)
  - Formularios con validación en tiempo real
  - Alertas y confirmaciones claras

#### Documentación
- **README.md**: Descripción completa del proyecto
- **INSTALACION.md**: Guía paso a paso de instalación
- **MANUAL_USUARIO.md**: Manual detallado para el usuario final
- **RESUMEN_PROYECTO.md**: Resumen ejecutivo del proyecto
- **CHANGELOG.md**: Este archivo de cambios

#### Configuración
- Info.plist configurado
- Assets con colores y iconos
- Modelo Core Data (.xcdatamodeld)
- Proyecto Xcode (.xcodeproj)
- .gitignore para control de versiones

### 🔐 Seguridad

- Almacenamiento completamente local (offline)
- Sin conexión a servidores externos
- Encriptación nativa de iOS
- Cumplimiento de normativas de protección de datos
- Privacidad de menores garantizada

### 📱 Compatibilidad

- iOS 15.0 o superior
- Optimizado para iPhone 14 Pro Max
- Compatible con todos los dispositivos iOS
- Soporte para Apple Pencil
- Modo portrait y landscape

### 🎨 Diseño

- Color primario: #007AB3 (azul INDERCULTURA)
- Tipografía: San Francisco (sistema iOS)
- Iconografía: SF Symbols
- Diseño adaptable (responsive)

### 📊 Rendimiento

- Carga rápida de datos
- Captura de firmas en tiempo real
- Generación de PDF optimizada
- Bajo consumo de batería
- Mínimo uso de almacenamiento

---

## [Futuras Versiones]

### 🔮 Planificado para v1.1.0

- [ ] Estadísticas y gráficos de asistencia
- [ ] Búsqueda avanzada de menores
- [ ] Filtros adicionales en reportes
- [ ] Edición de menores registrados
- [ ] Modo oscuro (Dark Mode)

### 🔮 Planificado para v1.2.0

- [ ] Exportación a Excel
- [ ] Widget de iOS
- [ ] Notificaciones de recordatorio
- [ ] Respaldo automático a iCloud (opcional)

### 🔮 Planificado para v2.0.0

- [ ] Múltiples trabajadores sociales
- [ ] Sincronización entre dispositivos
- [ ] Dashboard de administración
- [ ] Estadísticas avanzadas
- [ ] Integración con sistemas de INDERCULTURA

---

## Tipos de Cambios

Para versiones futuras, se usarán las siguientes categorías:

- **Agregado**: Para nuevas funcionalidades
- **Cambiado**: Para cambios en funcionalidades existentes
- **Obsoleto**: Para funcionalidades que se eliminarán pronto
- **Eliminado**: Para funcionalidades eliminadas
- **Corregido**: Para corrección de errores
- **Seguridad**: Para vulnerabilidades de seguridad

---

## Versionado

Este proyecto sigue Versionado Semántico: MAYOR.MENOR.PARCHE

- **MAYOR**: Cambios incompatibles en la API
- **MENOR**: Funcionalidades nuevas compatibles con versiones anteriores
- **PARCHE**: Correcciones de errores compatibles con versiones anteriores

---

**Última actualización**: 8 de febrero de 2026  
**Versión actual**: 1.0.0  
**Estado**: ✅ Producción
