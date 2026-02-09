# AppShey - Control de Asistencia INDERCULTURA

<img src="https://img.shields.io/badge/iOS-15.0+-blue?style=flat-square&logo=apple" alt="iOS 15.0+"/>
<img src="https://img.shields.io/badge/Swift-5.5+-orange?style=flat-square&logo=swift" alt="Swift 5.5+"/>
<img src="https://img.shields.io/badge/SwiftUI-3.0+-green?style=flat-square" alt="SwiftUI 3.0+"/>

## 📱 Descripción

AppShey es una aplicación móvil diseñada específicamente para **Sheynner Correa Jaramillo**, Trabajadora Social del Área Psicosocial de INDERCULTURA, que facilita el registro y control de asistencia de menores en diferentes sectores y ciudades.

### ✨ Características Principales

- 📝 **Registro Completo de Menores**: Guarda información detallada de cada menor incluyendo nombre, documento, sector y formador a cargo
- 👨‍👩‍👧‍👦 **Gestión de Padres/Acudientes**: Almacena datos de contacto de padres con múltiples parentescos
- 📍 **Organización por Sectores**: Agrupa menores por sector para facilitar la toma de asistencia
- ✍️ **Firmas Digitales**: Captura firmas de menores y padres usando tecnología PencilKit
- 📊 **Reportes Profesionales en PDF**: Genera reportes formales con toda la información requerida
- 💾 **Almacenamiento Local**: Toda la información se guarda localmente usando Core Data para seguridad y privacidad
- 🔒 **Sin conexión a Internet**: Funciona completamente offline

## 🎯 Casos de Uso

1. **Registro Inicial**: La trabajadora social registra por única vez a cada menor con su información completa
2. **Toma de Asistencia**: En cada visita, selecciona el sector y toma asistencia con firmas digitales
3. **Generación de Reportes**: Crea reportes PDF profesionales para presentar a las autoridades

## 🛠 Tecnologías Utilizadas

- **SwiftUI**: Framework moderno de UI declarativa
- **Core Data**: Base de datos local para persistencia
- **PencilKit**: Captura de firmas digitales de alta calidad
- **PDFKit**: Generación de reportes en formato PDF
- **Combine**: Manejo reactivo de datos

## 📂 Estructura del Proyecto

```
AppShey/
├── AppSheyApp.swift                    # Punto de entrada de la aplicación
├── ContentView.swift                   # Vista principal con TabView
│
├── Models/                             # Modelos de datos
│   ├── Nino.swift                     # Entidad de menor
│   ├── Padre.swift                    # Entidad de padre/acudiente
│   ├── Asistencia.swift               # Entidad de registro de asistencia
│   └── DataController.swift           # Controlador de Core Data
│
├── Views/                              # Vistas de la aplicación
│   ├── HomeView.swift                 # Pantalla de inicio
│   ├── RegistroNinoView.swift         # Registro de nuevos menores
│   ├── AsistenciaView.swift           # Control de asistencia
│   ├── ReportesView.swift             # Listado de reportes
│   ├── FirmaView.swift                # Captura de firmas
│   └── VistaPreviewReporteView.swift  # Vista previa de reportes
│
├── ViewModels/                         # ViewModels (MVVM)
│   ├── AsistenciaViewModel.swift      # Lógica de asistencia
│   └── ReportesViewModel.swift        # Lógica de reportes
│
├── Utils/                              # Utilidades
│   └── PDFGenerator.swift             # Generación de PDFs
│
├── AppSheyModel.xcdatamodeld/         # Modelo de Core Data
└── Assets.xcassets/                    # Recursos visuales

```

## 📋 Requisitos del Sistema

- iOS 15.0 o superior
- iPhone 14 Pro Max (optimizado)
- Compatible con Apple Pencil
- 50 MB de espacio libre

## 🚀 Instalación

### Para desarrollo en Xcode:

1. Abrir el proyecto en Xcode 14 o superior
```bash
open AppShey.xcodeproj
```

2. Seleccionar el dispositivo objetivo (iPhone 14 Pro Max)

3. Compilar y ejecutar (⌘ + R)

### Para instalación en dispositivo:

1. Conectar el iPhone al Mac
2. En Xcode, seleccionar tu dispositivo
3. Configurar el equipo de desarrollo en "Signing & Capabilities"
4. Compilar e instalar

## 👥 Flujo de Trabajo

### 1️⃣ Registro de Menor

```
Abrir App → Tab "Registro" → Completar formulario → Agregar padres → Guardar
```

**Datos requeridos:**
- Nombre completo del menor
- Documento de identidad
- Sector al que pertenece
- Formador a cargo
- Información de al menos un padre/acudiente

### 2️⃣ Toma de Asistencia

```
Tab "Asistencia" → Configurar sesión (fecha, semana, tema, entidades) 
→ Seleccionar sector → Firmar cada menor → Firma opcional de padres 
→ Finalizar y generar reporte
```

**Información de sesión:**
- Fecha de la visita
- Semana (1-4)
- Tema de la sesión
- Entidades participantes
- Sector visitado

### 3️⃣ Generación de Reportes

```
Tab "Reportes" → Seleccionar fecha y sector → Ver listado 
→ Seleccionar reporte → Previsualizar → Exportar PDF
```

**El reporte incluye:**
- Encabezado con logo de INDERCULTURA
- Información de la trabajadora social
- Datos de la sesión (tema, semana, fecha, sector, entidades)
- Tabla con: N°, Nombre completo, Documento, Firma
- Total de asistentes
- Firma de la trabajadora social

## 📊 Modelo de Datos

### Entidad: Nino
- `id`: UUID
- `nombreCompleto`: String
- `documento`: String
- `sector`: String
- `formadorACargo`: String
- `fechaRegistro`: Date
- `activo`: Bool
- **Relaciones**: padres (1:N), asistencias (1:N)

### Entidad: Padre
- `id`: UUID
- `nombreCompleto`: String
- `documento`: String
- `telefono`: String
- `parentesco`: String
- **Relaciones**: nino (N:1)

### Entidad: Asistencia
- `id`: UUID
- `fecha`: Date
- `sector`: String
- `semana`: Int16
- `tema`: String
- `entidades`: String
- `presente`: Bool
- `firmaNino`: Data (imagen)
- `firmaPadre`: Data (imagen)
- **Relaciones**: nino (N:1)

## 🎨 Diseño UI/UX

- **Colores**: Esquema profesional con color primario #007AB3 (azul INDERCULTURA)
- **Tipografía**: San Francisco (sistema iOS)
- **Iconografía**: SF Symbols nativa de Apple
- **Navegación**: TabView con 4 secciones principales
- **Formularios**: Validación en tiempo real
- **Feedback**: Alertas y confirmaciones claras

## 🔐 Seguridad y Privacidad

- ✅ Todos los datos se almacenan localmente en el dispositivo
- ✅ No hay sincronización con servidores externos
- ✅ No requiere conexión a Internet
- ✅ Los PDFs se generan localmente
- ✅ Cumple con normativas de protección de datos de menores
- ✅ Información encriptada por iOS

## 📄 Exportación de Reportes

Los reportes se pueden compartir mediante:
- ✉️ Correo electrónico
- 💬 WhatsApp
- 📱 AirDrop
- ☁️ iCloud Drive
- 📂 Guardar en Archivos

## 🐛 Solución de Problemas

### La aplicación no guarda datos
- Verificar permisos de almacenamiento
- Reiniciar la aplicación
- Verificar espacio disponible en el dispositivo

### No se capturan las firmas
- Verificar que PencilKit esté habilitado
- Permitir el uso del lápiz o dedo
- Limpiar y volver a intentar

### Los PDFs no se generan
- Verificar permisos de escritura
- Liberar espacio en el dispositivo
- Comprobar que la sesión tenga todas las firmas

## 👤 Usuario Final

**Nombre**: Sheynner Correa Jaramillo  
**Cargo**: Trabajadora Social  
**Área**: Psicosocial  
**Entidad**: INDERCULTURA  

## 📝 Licencia

Este proyecto es de uso exclusivo para INDERCULTURA y está protegido por derechos de autor.

## 📞 Soporte

Para asistencia técnica o consultas sobre la aplicación, contactar al equipo de desarrollo.

---

**Versión**: 1.0  
**Última actualización**: Febrero 2026  
**Desarrollado para**: iPhone 14 Pro Max (iOS 15.0+)

---

## 🎓 Notas Importantes

1. **Primera vez**: Registrar a todos los menores antes de tomar asistencia
2. **Sectores**: Crear sectores claros y consistentes para facilitar la organización
3. **Firmas**: Las firmas de padres son opcionales pero recomendadas
4. **Reportes**: Generar reportes inmediatamente después de cada sesión
5. **Respaldo**: Exportar PDFs periódicamente como respaldo

## 🔄 Actualizaciones Futuras (Roadmap)

- [ ] Estadísticas y gráficos de asistencia
- [ ] Búsqueda avanzada de menores
- [ ] Exportación a Excel
- [ ] Modo oscuro
- [ ] Widget de iOS
- [ ] Sincronización opcional con iCloud
- [ ] Notificaciones de recordatorio
- [ ] Múltiples trabajadores sociales

---

**¡Gracias por usar AppShey!** 🎉
