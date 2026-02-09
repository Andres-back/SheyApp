# Guía de Instalación - AppShey

## 📱 Requisitos Previos

### Hardware
- Mac con macOS Monterey (12.0) o superior
- iPhone 14 Pro Max con iOS 15.0 o superior
- Cable Lightning o USB-C para conectar el iPhone
- Al menos 2 GB de espacio libre en el Mac
- Al menos 50 MB de espacio libre en el iPhone

### Software
- Xcode 14.0 o superior
- Cuenta de Apple (Apple ID)
- Certificado de desarrollo de iOS (puede ser gratuito)

## 🔧 Pasos de Instalación

### Parte 1: Preparar el Entorno de Desarrollo

1. **Instalar Xcode**
   ```bash
   # Opción 1: Desde la Mac App Store
   # Buscar "Xcode" y hacer clic en "Obtener"
   
   # Opción 2: Desde el sitio de desarrolladores de Apple
   # https://developer.apple.com/xcode/
   ```

2. **Verificar la instalación de Xcode**
   ```bash
   xcode-select --version
   # Debería mostrar: xcode-select version 2396 o superior
   ```

3. **Instalar herramientas de línea de comandos**
   ```bash
   xcode-select --install
   ```

### Parte 2: Configurar el Proyecto

1. **Navegar al directorio del proyecto**
   ```bash
   cd "D:\DEV\AppShey"
   ```

2. **Abrir el proyecto en Xcode**
   ```bash
   open AppShey.xcodeproj
   ```

3. **Configurar el Bundle Identifier**
   - En Xcode, seleccionar el proyecto en el navegador
   - Ir a la pestaña "Signing & Capabilities"
   - Cambiar el Bundle Identifier a un identificador único:
     ```
     com.indercultura.appshey
     ```

4. **Configurar el equipo de desarrollo**
   - En "Signing & Capabilities"
   - En el campo "Team", seleccionar tu Apple ID
   - Si no tienes un equipo, hacer clic en "Add Account..." e iniciar sesión

### Parte 3: Preparar el Dispositivo

1. **Habilitar el modo de desarrollador en el iPhone**
   - En el iPhone, ir a **Ajustes → Privacidad y seguridad → Modo de desarrollador**
   - Activar "Modo de desarrollador"
   - Reiniciar el iPhone cuando se solicite

2. **Conectar el iPhone al Mac**
   - Conectar el iPhone con un cable
   - En el iPhone, confiar en la computadora cuando se solicite
   - Desbloquear el iPhone

3. **Verificar la conexión**
   - En Xcode, en la parte superior, debería aparecer el nombre de tu iPhone
   - Si no aparece, ir a **Window → Devices and Simulators**

### Parte 4: Compilar e Instalar la Aplicación

1. **Seleccionar el dispositivo objetivo**
   - En la esquina superior izquierda de Xcode
   - Hacer clic en el selector de dispositivo
   - Elegir tu iPhone 14 Pro Max

2. **Compilar el proyecto**
   ```
   Presionar ⌘ + B (Command + B)
   ```
   - Esperar a que la compilación termine sin errores

3. **Ejecutar en el dispositivo**
   ```
   Presionar ⌘ + R (Command + R)
   ```
   - Xcode instalará la aplicación en el iPhone
   - La primera vez puede tardar varios minutos

4. **Confiar en el desarrollador (solo la primera vez)**
   - En el iPhone, ir a **Ajustes → General → VPN y gestión de dispositivos**
   - Tocar tu Apple ID
   - Tocar "Confiar en..."
   - Confirmar

5. **Abrir la aplicación**
   - Buscar el icono de AppShey en el iPhone
   - Tocar para abrir

## 🎯 Verificación de la Instalación

### Prueba 1: Verificar la pantalla de inicio
- ✅ Debe mostrar el logo de INDERCULTURA
- ✅ Debe mostrar "Psicosocial: Sheynner Correa Jaramillo"
- ✅ Debe tener 4 pestañas: Inicio, Registro, Asistencia, Reportes

### Prueba 2: Registrar un menor de prueba
1. Ir a la pestaña "Registro"
2. Completar el formulario con datos de prueba:
   - Nombre: Juan Pérez
   - Documento: 123456789
   - Sector: Centro
   - Formador: María García
3. Agregar un padre:
   - Nombre: Carlos Pérez
   - Documento: 987654321
   - Teléfono: 3001234567
   - Parentesco: Padre
4. Tocar "Registrar Menor"
5. Debe aparecer un mensaje de éxito

### Prueba 3: Tomar asistencia
1. Ir a la pestaña "Asistencia"
2. Configurar la sesión:
   - Fecha: Hoy
   - Semana: 1
   - Tema: Prueba
   - Entidades: Test
3. Seleccionar el sector "Centro"
4. Debe aparecer el menor registrado
5. Firmar con el dedo
6. Guardar firma
7. Finalizar y generar reporte

### Prueba 4: Ver reportes
1. Ir a la pestaña "Reportes"
2. Debe aparecer el reporte recién generado
3. Tocar el reporte
4. Ver la vista previa
5. Exportar PDF
6. Compartir por WhatsApp o correo

## ⚠️ Solución de Problemas Comunes

### Error: "No se puede verificar el desarrollador"
**Solución:**
```
1. Ajustes → General → VPN y gestión de dispositivos
2. Tocar el perfil del desarrollador
3. Tocar "Confiar"
```

### Error: "No se puede instalar la aplicación"
**Solución:**
```
1. Verificar que el iPhone esté desbloqueado
2. Verificar que haya espacio suficiente
3. Reiniciar Xcode y el iPhone
4. Limpiar el proyecto: Product → Clean Build Folder (⇧⌘K)
```

### Error: "Certificado no válido"
**Solución:**
```
1. En Xcode, ir a Preferences → Accounts
2. Seleccionar tu Apple ID
3. Hacer clic en "Manage Certificates"
4. Crear un nuevo certificado de desarrollo
```

### Error: "Core Data no puede cargar"
**Solución:**
```
1. Eliminar la aplicación del iPhone
2. Limpiar el proyecto en Xcode
3. Reinstalar
```

### La aplicación se cierra inesperadamente
**Solución:**
```
1. Conectar el iPhone al Mac
2. En Xcode: Window → Devices and Simulators
3. Seleccionar el iPhone
4. Ver el registro de consola para errores
```

## 🔄 Actualizar la Aplicación

Para instalar una nueva versión:

1. Abrir el proyecto en Xcode
2. Incrementar el número de versión:
   - Seleccionar el proyecto
   - En "General", incrementar "Build"
3. Compilar y ejecutar (⌘ + R)
4. Xcode reemplazará la versión anterior

## 📱 Instalación sin Xcode (TestFlight - Futuro)

En el futuro, la aplicación puede distribuirse mediante TestFlight:

1. El administrador envía una invitación por correo
2. Instalar TestFlight desde la App Store
3. Abrir el enlace de invitación
4. Instalar AppShey desde TestFlight
5. La aplicación se actualizará automáticamente

## 🔐 Renovación de Certificados

Los certificados de desarrollo gratuitos expiran cada 7 días:

1. Reconectar el iPhone al Mac
2. Abrir el proyecto en Xcode
3. Xcode renovará automáticamente el certificado
4. Ejecutar la aplicación (⌘ + R)

## 📞 Soporte Técnico

Si encuentras problemas durante la instalación:

1. **Verificar la documentación oficial de Apple**
   - https://developer.apple.com/documentation/xcode

2. **Revisar los logs de Xcode**
   - View → Navigators → Report Navigator

3. **Contactar al equipo de desarrollo**
   - Proporcionar capturas de pantalla de los errores
   - Indicar el paso donde ocurrió el problema

## ✅ Checklist de Instalación

- [ ] Xcode 14+ instalado
- [ ] Proyecto abierto en Xcode
- [ ] Bundle Identifier configurado
- [ ] Apple ID agregado a Xcode
- [ ] iPhone en modo de desarrollador
- [ ] iPhone conectado y confiado
- [ ] Compilación exitosa
- [ ] Aplicación instalada en el iPhone
- [ ] Desarrollador confiado en ajustes
- [ ] Aplicación abierta exitosamente
- [ ] Pruebas básicas completadas

## 🎉 ¡Instalación Completada!

Una vez completados todos los pasos, AppShey estará lista para usar.

**Próximos pasos:**
1. Registrar todos los menores
2. Organizar por sectores
3. Comenzar a tomar asistencia
4. Generar reportes profesionales

---

**Nota**: Esta guía es específica para el entorno de desarrollo. Para despliegue en producción mediante la App Store, se requieren pasos adicionales de certificación y revisión por Apple.
