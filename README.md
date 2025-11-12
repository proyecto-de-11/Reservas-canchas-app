# Cancha-Now: Tu App de Reservas Deportivas

**Cancha-Now** es una aplicación moderna y completa construida con Flutter, diseñada para conectar a jugadores con propietarios de canchas deportivas. La plataforma ofrece una experiencia de usuario fluida y profesional, con interfaces separadas y optimizadas para cada tipo de usuario.

## Características Principales

### Para Jugadores:
- **Exploración de Canchas:** Descubre y filtra canchas por deporte, ubicación y disponibilidad.
- **Reservas Fáciles:** Reserva tus canchas favoritas en pocos pasos.
- **Perfil de Usuario:** Gestiona tu información personal y tu historial de reservas.

### Para Propietarios:
- **Gestión de Canchas:** Añade, edita y elimina tus canchas.
- **Calendario de Reservas:** Visualiza y gestiona todas tus reservas en un solo lugar.
- **Panel de Control:** Obtén estadísticas y reportes sobre el rendimiento de tus canchas.

## Diseño y Estilo Visual

La aplicación se ha desarrollado con un enfoque en el **diseño premium y la experiencia de usuario**.

- **Paleta de Colores:** Utilizamos un degradado de azul vibrante (`#007BFF` a `#0056B3`) como color principal, combinado con una base de grises neutros y blancos para una apariencia limpia y moderna.
- **Tipografía:** Empleamos la fuente **Poppins** de Google Fonts, que aporta un toque profesional y una excelente legibilidad en todas las pantallas.
- **Componentes Visuales:**
  - **Tarjetas con Elevación:** Las tarjetas de información tienen sombras sutiles y efectos de elevación para crear una sensación de profundidad.
  - **Iconografía Clara:** Usamos iconos de Material Design para una navegación intuitiva y una rápida comprensión de las acciones.
  - **Microinteracciones:** Animaciones suaves en los botones y al seleccionar elementos para una experiencia más dinámica.

## Tecnologías Utilizadas

- **Framework:** Flutter 3
- **Lenguaje:** Dart
- **Navegación:** `go_router` para una gestión de rutas declarativa y robusta.
- **Fuentes:** `google_fonts` para una tipografía elegante.
- **Iconos:** `flutter_svg` para el uso de gráficos vectoriales.

## Estructura del Proyecto

El proyecto sigue una arquitectura limpia, separando la lógica de la interfaz de usuario. Las pantallas principales se encuentran en la carpeta `lib/` y se organizan de la siguiente manera:

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

## Guía de Inicio Rápido

Para ejecutar el proyecto en tu entorno de desarrollo, sigue estos pasos:

1.  **Clona el repositorio:**
    ```bash
    git clone <URL_DEL_REPOSITORIO>
    cd <NOMBRE_DEL_PROYECTO>
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

---
*Este README fue generado y mejorado para reflejar el estado actual y la visión del proyecto.*
