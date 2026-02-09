# Guía de Contribución - AppShey

## 🤝 Contribuyendo al Proyecto

Gracias por tu interés en mejorar AppShey. Este documento proporciona lineamientos para contribuir al proyecto de manera efectiva.

---

## 📋 Tabla de Contenidos

1. [Código de Conducta](#código-de-conducta)
2. [¿Cómo Puedo Contribuir?](#cómo-puedo-contribuir)
3. [Reportar Errores](#reportar-errores)
4. [Sugerir Mejoras](#sugerir-mejoras)
5. [Pull Requests](#pull-requests)
6. [Estándares de Código](#estándares-de-código)
7. [Proceso de Revisión](#proceso-de-revisión)

---

## 📜 Código de Conducta

### Nuestro Compromiso

Este proyecto está dedicado a proporcionar una experiencia libre de acoso para todos, independientemente de:
- Edad
- Tamaño corporal
- Discapacidad
- Etnicidad
- Identidad y expresión de género
- Nivel de experiencia
- Nacionalidad
- Apariencia personal
- Raza
- Religión
- Identidad y orientación sexual

### Comportamiento Esperado

✅ Usar lenguaje acogedor e inclusivo  
✅ Ser respetuoso con diferentes puntos de vista  
✅ Aceptar críticas constructivas con gracia  
✅ Enfocarse en lo mejor para la comunidad  
✅ Mostrar empatía hacia otros miembros  

### Comportamiento Inaceptable

❌ Lenguaje o imágenes sexualizadas  
❌ Comentarios insultantes o despectivos  
❌ Acoso público o privado  
❌ Publicar información privada sin permiso  
❌ Conducta inapropiada en contexto profesional  

---

## 🔧 ¿Cómo Puedo Contribuir?

### Tipos de Contribuciones

1. **Reportar Errores** 🐛
   - Identificar y documentar bugs
   - Proporcionar información de reproducción

2. **Sugerir Mejoras** 💡
   - Proponer nuevas funcionalidades
   - Sugerir optimizaciones

3. **Documentación** 📚
   - Mejorar documentación existente
   - Traducir contenido
   - Escribir tutoriales

4. **Código** 💻
   - Corregir bugs
   - Implementar nuevas funcionalidades
   - Optimizar rendimiento

---

## 🐛 Reportar Errores

### Antes de Reportar

1. **Verificar** si ya existe un reporte similar
2. **Actualizar** a la última versión
3. **Reproducir** el error de manera consistente
4. **Recopilar** información relevante

### Información Requerida

Al reportar un error, incluir:

```markdown
**Descripción del Error**
Una descripción clara y concisa del problema.

**Pasos para Reproducir**
1. Ir a '...'
2. Hacer clic en '...'
3. Desplazarse hasta '...'
4. Ver error

**Comportamiento Esperado**
Qué esperabas que sucediera.

**Comportamiento Actual**
Qué sucedió en realidad.

**Capturas de Pantalla**
Si aplica, agregar capturas.

**Entorno**
- Dispositivo: iPhone 14 Pro Max
- iOS: 15.4
- Versión de AppShey: 1.0.0

**Información Adicional**
Cualquier contexto adicional sobre el problema.
```

### Severidad del Error

- 🔴 **Crítico**: La app se cierra o pierde datos
- 🟠 **Alto**: Funcionalidad principal no funciona
- 🟡 **Medio**: Funcionalidad secundaria afectada
- 🟢 **Bajo**: Problema cosmético o menor

---

## 💡 Sugerir Mejoras

### Plantilla de Sugerencia

```markdown
**¿Está relacionada con un problema?**
Descripción clara del problema. Ej: "Es frustrante cuando..."

**Describe la solución que te gustaría**
Una descripción clara y concisa de lo que quieres que suceda.

**Describe alternativas que has considerado**
Otras soluciones o funcionalidades consideradas.

**Contexto adicional**
Cualquier otro contexto o capturas sobre la sugerencia.

**Beneficios**
- Beneficio 1
- Beneficio 2

**Complejidad Estimada**
Baja / Media / Alta

**Prioridad Sugerida**
Baja / Media / Alta / Crítica
```

### Funcionalidades Deseables

Para v1.1.0:
- [ ] Estadísticas de asistencia
- [ ] Búsqueda avanzada
- [ ] Edición de registros
- [ ] Modo oscuro

Para v1.2.0:
- [ ] Exportación a Excel
- [ ] Widget iOS
- [ ] Notificaciones

---

## 🔀 Pull Requests

### Antes de Enviar un PR

1. **Fork** el repositorio
2. **Crear** una rama descriptiva: `feature/nueva-funcionalidad` o `fix/correccion-error`
3. **Implementar** cambios con commits claros
4. **Probar** exhaustivamente
5. **Actualizar** documentación si es necesario

### Proceso de PR

1. **Descripción Clara**
   - ¿Qué hace este PR?
   - ¿Por qué es necesario?
   - ¿Qué problemas resuelve?

2. **Referencias**
   - Número de issue relacionado
   - Enlaces a discusiones relevantes

3. **Checklist**
   ```markdown
   - [ ] Código sigue los estándares del proyecto
   - [ ] Se agregaron/actualizaron tests
   - [ ] Documentación actualizada
   - [ ] Sin conflictos con la rama principal
   - [ ] Tests pasan exitosamente
   - [ ] Build exitoso sin warnings
   ```

### Plantilla de PR

```markdown
## Descripción
[Descripción breve de los cambios]

## Tipo de Cambio
- [ ] Bug fix (cambio que corrige un problema)
- [ ] Nueva funcionalidad (cambio que agrega funcionalidad)
- [ ] Breaking change (fix o feature que causa cambios no compatibles)
- [ ] Documentación

## ¿Cómo se ha probado?
[Describe las pruebas realizadas]

## Checklist
- [ ] Mi código sigue el estilo de este proyecto
- [ ] He realizado una auto-revisión de mi código
- [ ] He comentado mi código, particularmente en áreas complejas
- [ ] He hecho cambios correspondientes en la documentación
- [ ] Mis cambios no generan nuevas advertencias
- [ ] He agregado tests que prueban que mi fix es efectivo o que mi feature funciona
- [ ] Tests unitarios nuevos y existentes pasan localmente con mis cambios

## Capturas de Pantalla (si aplica)
[Agregar capturas]
```

---

## 📝 Estándares de Código

### Swift Style Guide

Seguir las convenciones de:
- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Nombrado claro y descriptivo
- Comentarios en español para este proyecto

### Estructura de Archivos

```swift
//
//  NombreArchivo.swift
//  AppShey
//
//  Breve descripción del propósito del archivo
//

import UIKit
import SwiftUI

// MARK: - Clase/Struct Principal

/// Documentación de la clase
class MiClase {
    
    // MARK: - Properties
    
    var propiedad: String
    
    // MARK: - Initialization
    
    init(propiedad: String) {
        self.propiedad = propiedad
    }
    
    // MARK: - Methods
    
    func metodo() {
        // Implementación
    }
}

// MARK: - Extensions

extension MiClase {
    // Extensiones organizadas por funcionalidad
}
```

### Convenciones de Nombrado

- **Variables y funciones**: camelCase
  ```swift
  var nombreCompleto: String
  func obtenerAsistencias() -> [Asistencia]
  ```

- **Clases y Structs**: PascalCase
  ```swift
  class DataController
  struct GrupoAsistencia
  ```

- **Constantes**: camelCase
  ```swift
  let maximoAsistentes = 50
  ```

### Comentarios

```swift
// Comentario de una línea

/// Documentación de función
/// - Parameter parametro: Descripción del parámetro
/// - Returns: Descripción del retorno
func miFuncion(parametro: String) -> Bool {
    // Implementación
}

// MARK: - Sección
// MARK: Subsección
// TODO: Tarea pendiente
// FIXME: Corregir esto
```

### SwiftUI Views

```swift
struct MiVista: View {
    
    // MARK: - Properties
    
    @State private var texto = ""
    @ObservedObject var viewModel: MiViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // Contenido
        }
    }
    
    // MARK: - Private Methods
    
    private func metodoAuxiliar() {
        // Implementación
    }
}

// MARK: - Preview

#Preview {
    MiVista(viewModel: MiViewModel())
}
```

---

## 🔍 Proceso de Revisión

### Criterios de Aceptación

Un PR será aceptado si:

✅ **Funcionalidad**
- Resuelve el problema descrito
- No introduce nuevos bugs
- Mejora o mantiene el rendimiento

✅ **Código**
- Sigue los estándares establecidos
- Está bien documentado
- Es mantenible y legible

✅ **Tests**
- Incluye tests apropiados
- Todos los tests pasan
- Cobertura de código adecuada

✅ **Documentación**
- README actualizado si es necesario
- Comentarios de código claros
- CHANGELOG.md actualizado

### Tiempo de Revisión

- PRs pequeños: 1-2 días
- PRs medianos: 3-5 días
- PRs grandes: 1-2 semanas

### Feedback

El equipo de revisión puede:
- ✅ Aprobar el PR
- 🔄 Solicitar cambios
- ❌ Rechazar si no cumple requisitos

---

## 🛠️ Configuración del Entorno de Desarrollo

### Requisitos

- macOS Monterey o superior
- Xcode 14.0 o superior
- iOS 15.0+ SDK
- Git

### Setup Inicial

```bash
# Clonar el repositorio
git clone https://github.com/indercultura/appshey.git

# Navegar al directorio
cd appshey

# Abrir en Xcode
open AppShey.xcodeproj

# Instalar dependencias (si hay)
# [Comando de instalación]
```

### Branches

- `main`: Producción estable
- `develop`: Desarrollo activo
- `feature/*`: Nuevas funcionalidades
- `fix/*`: Correcciones de bugs
- `hotfix/*`: Correcciones urgentes

### Commits

Formato de commits:
```
tipo(alcance): descripción breve

Descripción detallada (opcional)

Refs: #123
```

Tipos:
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Documentación
- `style`: Formato de código
- `refactor`: Refactorización
- `test`: Tests
- `chore`: Tareas de mantenimiento

Ejemplos:
```
feat(asistencia): agregar filtro por fecha

fix(reportes): corregir generación de PDF

docs(readme): actualizar guía de instalación
```

---

## 📞 Contacto

**Preguntas sobre contribuciones:**
- [Correo del equipo]
- [Canal de comunicación]

**Discusiones técnicas:**
- [Foro o plataforma de discusión]

**Reportar problemas de seguridad:**
- [Correo de seguridad]

---

## 🙏 Agradecimientos

Gracias a todos los que contribuyen a mejorar AppShey. Cada contribución, sin importar su tamaño, es valiosa y apreciada.

### Contribuidores

- [Lista de contribuidores]

---

**Última actualización**: 8 de febrero de 2026  
**Versión**: 1.0

---

*Al contribuir a este proyecto, aceptas cumplir con este código de conducta y los lineamientos establecidos.*
