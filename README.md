
<p align="center">
  <img src="https://storage.googleapis.com/flutter-a-test-ഘ-prod/brand-assets/Cancha-Now-Banner-Small.png" alt="Cancha-Now Banner" width="800"/>
</p>

<h1 align="center">Cancha-Now: App de Reservas Deportivas</h1>

<p align="center">
  <!-- Badges -->
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter" alt="Flutter Version">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/badge/Platform-Android | iOS | Web-purple?style=for-the-badge" alt="Platforms">
</p>

> **Cancha-Now** es una aplicación moderna y completa construida con Flutter, diseñada para conectar a jugadores con propietarios de canchas deportivas. La plataforma ofrece una experiencia de usuario fluida y profesional, con interfaces separadas y optimizadas para cada tipo de usuario.

---

## ✨ Características Principales

| Módulo        | Funcionalidad                                                               | Estado      |
|---------------|-----------------------------------------------------------------------------|-------------|
| 🙍‍♂️ **Jugadores** | **Exploración de Canchas:** Descubre y filtra canchas.                       | ✅ Completo |
|               | **Reservas Fáciles:** Reserva tus canchas favoritas en pocos pasos.           | ✅ Completo |
|               | **Perfil de Usuario:** Gestiona tu información y tu historial.               | ✅ Completo |
| 💼 **Propietarios**| **Gestión de Canchas:** Añade, edita y elimina tus canchas.                   | ✅ Completo |
|               | **Calendario de Reservas:** Visualiza y gestiona todas tus reservas.        | in-progress 🚧 |
|               | **Panel de Control:** Obtén estadísticas y reportes.                         | in-progress 🚧 |

---

## 🎨 Diseño y Estilo Visual

La aplicación se ha desarrollado con un enfoque en el **diseño premium y la experiencia de usuario**.

- **Paleta de Colores:** Utilizamos un degradado de azul vibrante (`#007BFF` a `#0056B3`) como color principal, combinado con una base de grises neutros y blancos para una apariencia limpia y moderna.
- **Tipografía:** Empleamos la fuente **Poppins** de Google Fonts, que aporta un toque profesional y una excelente legibilidad en todas las pantallas.
- **Componentes Visuales:**
  - **Tarjetas con Elevación:** Las tarjetas de información tienen sombras sutiles y efectos de elevación para crear una sensación de profundidad.
  - **Iconografía Clara:** Usamos iconos de Material Design para una navegación intuitiva y una rápida comprensión de las acciones.
  - **Microinteracciones:** Animaciones suaves en los botones y al seleccionar elementos para una experiencia más dinámica.

---

## 📸 Vistazo a la App

<p align="center">
  <img src="https://storage.googleapis.com/flutter-a-test-ഘ-prod/screenshots/Cancha-Now-Owner.png" alt="Owner View" width="250"/>
  <img src="https://storage.googleapis.com/flutter-a-test-ഘ-prod/screenshots/Cancha-Now-Details.png" alt="Details View" width="250"/>
  <img src="https://storage.googleapis.com/flutter-a-test-ഘ-prod/screenshots/Cancha-Now-Login.png" alt="Login View" width="250"/>
</p>

---

## 🚀 Tecnologías Utilizadas

| Tecnología | Propósito |
|---|---|
| **Flutter 3** | Framework principal para el desarrollo multiplataforma. |
| **Dart** | Lenguaje de programación. |
| **`go_router`** | Gestión de rutas declarativa y robusta. |
| **`google_fonts`**| Tipografías elegantes y de alto rendimiento. |
| **`flutter_svg`** | Uso de gráficos vectoriales (SVG). |

---

<details>
<summary>🛠️ Guía de Inicio Rápido</summary>

Para ejecutar el proyecto en tu entorno de desarrollo, sigue estos pasos:

1.  **Clona el repositorio:**
    ```bash
    git clone https://github.com/tu-usuario/cancha-now.git
    cd cancha-now
    ```

2.  **Instala las dependencias:**
    Asegúrate de tener Flutter instalado y luego ejecuta:
    ```bash
    flutter pub get
    ```

3.  **Ejecuta la aplicación:**
    Puedes lanzar la aplicación en un emulador, un dispositivo físico o en la web con el siguiente comando:
    ```bash
    flutter run
    ```
</details>

<details>
<summary>📂 Estructura del Proyecto</summary>

El proyecto sigue una arquitectura limpia, separando la lógica de la interfaz de usuario.

```
lib/
├── main.dart                 # Punto de entrada y configuración de rutas
├── home_screen.dart          # Pantalla principal para jugadores
├── owner_home_screen.dart    # Pantalla principal para propietarios
├── login_screen.dart         # Pantalla de inicio de sesión
├── register_screen.dart      # Pantalla de registro
├── create_reservation_screen.dart # Formulario para crear una reserva
├── profile_screen.dart       # Pantalla de perfil de usuario
└── ...                       # Otros widgets y modelos
```
</details>

---

## 🛣️ Roadmap (Futuras Mejoras)

- [ ] **Sistema de Pagos:** Integración con pasarelas de pago para reservas online.
- [ ] **Notificaciones Push:** Recordatorios de reservas y promociones.
- [ ] **Calificaciones y Reseñas:** Sistema para que los jugadores califiquen las canchas.
- [ ] **Chat en la App:** Comunicación directa entre jugadores y propietarios.

---

## 📜 Licencia

Distribuido bajo la Licencia MIT. Ver `LICENSE` para más información.
