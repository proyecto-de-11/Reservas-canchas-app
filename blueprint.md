# Blueprint: Aplicación con Autenticación y Pantallas Funcionales para Jugadores

## Descripción General

Crear una aplicación Flutter enfocada en jugadores, con un flujo de autenticación completo, una `HomeScreen` elegante, un formulario detallado para `Crear Reservas` y una pantalla de `Perfil de Usuario` rica en información. La navegación se gestiona con `go_router`.

## Estilo y Diseño

- **Paleta de Colores:** Se utiliza un degradado azul (de `Color(0xFF007BFF)` a `Color(0xFF0056B3)`) como color primario.
- **Tipografía:** Se emplea `google_fonts` con la fuente "Poppins" para una apariencia profesional.
- **Componentes y Efectos Visuales:**
    - **Menú lateral (Drawer):** Centro de navegación principal con diseño moderno.
    - **Tarjetas (`Card`):** Se usan para agrupar información de forma limpia y con sombras sutiles.
    - **Selectores Nativos:** Se usan `showDatePicker` y `showTimePicker` para una experiencia de usuario familiar.
    - **Botón de Acción Flotante (FAB):** Se usa para acciones primarias, como "Editar Perfil".

## Funcionalidades y Flujo

### 1. Pantalla de Inicio de Sesión (`login_screen.dart`)

- **Ruta:** `/`
- **Diseño:** Formulario de inicio de sesión simplificado.
- **Integración con API:** La función `login` en `auth_service.dart` consume el endpoint de la API de login (`/api/auth/login`).

### 2. Pantalla de Registro (`register_screen.dart`)

- **Ruta:** `/register`
- **Diseño:** Formulario de registro simplificado.
- **Lógica:**
    - El rol del nuevo usuario se asigna automáticamente como "Jugador" por defecto.
    - El estado de la cuenta se establece como "Activada" por defecto.

### 3. Pantalla de Inicio (`home_screen.dart`)

- **Ruta:** `/home`
- **Diseño:** Saludo de bienvenida y tarjeta de acción principal.
- **Navegación:** El `Drawer` permite navegar a `/create-reservation` y `/profile`.

### 4. Pantalla de Crear Reserva (`create_reservation_screen.dart`)

- **Ruta:** `/create-reservation`
- **Diseño:** Formulario detallado para crear una nueva reserva.

### 5. Pantalla de Perfil (`profile_screen.dart`)

- **Ruta:** `/profile`
- **Diseño Detallado:**
    - **Cabecera de Perfil:** Muestra una foto de perfil (con un icono para cambiarla), el nombre completo del usuario y su correo.
    - **Tarjeta de "Información Personal":**
        - Nombre completo
        - Documento de identidad
        - Fecha de nacimiento
        - Género
    - **Tarjeta de "Información de Contacto":**
        - Teléfono
        - Ciudad
        - País
    - **Tarjeta de "Biografía":** Un espacio para una descripción personal.
    - **Botón de Cerrar Sesión:** Para salir de la aplicación.
    - **Botón de Editar (FAB):** Un `FloatingActionButton` con un icono de lápiz, preparado para activar el modo de edición.
- **Navegación:** El botón "Cerrar Sesión" redirige a `/`.

## Navegación (Routing)

La navegación es manejada por `go_router`. Las rutas configuradas son:

- `/`: `LoginScreen`.
- `/register`: `RegisterScreen`.
- `/home`: `HomeScreen`.
- `/create-reservation`: `CreateReservationScreen`.
- `/profile`: `ProfileScreen`.

## Pasos de Implementación Realizados

1.  **Flujo de Autenticación y `HomeScreen`:** Implementación inicial.
2.  **Formulario de Reserva:** Construcción y corrección de errores.
3.  **Pantalla de Perfil (Versión 1):** Creación inicial y conexión de la ruta.
4.  **Rediseño Detallado de la Pantalla de Perfil:** Se reestructuró `profile_screen.dart` para incluir toda la información solicitada y un diseño más rico.
5.  **Simplificación del Registro:** Se modificó `register_screen.dart` para agilizar la creación de cuentas.
6.  **Ajuste del Servicio de Login:** Se corrigió `auth_service.dart` para que la función de login envíe los campos correctos a la API.
7.  **Eliminación de Flujo de Propietario:** Se eliminaron todas las pantallas y rutas relacionadas con la funcionalidad de propietario (`OwnerHomeScreen`, `ManageCourtScreen`, `CreateCourtScreen`) para enfocar la aplicación exclusivamente en los usuarios (jugadores).
8.  **Actualización de Blueprint:** Se documentaron todos los cambios realizados.
