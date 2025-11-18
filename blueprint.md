# Blueprint: Aplicación con Autenticación y Pantallas Funcionales

## Descripción General

Crear una aplicación Flutter con un flujo de autenticación completo, una `HomeScreen` elegante, un formulario detallado para `Crear Reservas` y una pantalla de `Perfil de Usuario` rica en información. La navegación se gestiona con `go_router`.

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
- **Diseño:** Formulario de inicio de sesión.

### 2. Pantalla de Registro (`register_screen.dart`)

- **Ruta:** `/register`
- **Diseño:** Formulario de registro simplificado.
- **Cambios Recientes:**
    - Se eliminó el campo "Confirmar Contraseña" para agilizar el proceso.
    - El rol del nuevo usuario se asigna automáticamente como "Jugador" por defecto.
    - El estado de la cuenta se establece como "Activada" por defecto.
    - Los campos de rol y estado ya no son visibles en la interfaz de usuario.

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
4.  **Rediseño Detallado de la Pantalla de Perfil:**
    - Se reestructuró `profile_screen.dart` para incluir toda la información solicitada, organizada en tarjetas lógicas y con un diseño más rico.
    - Se añadió un `FloatingActionButton` para futuras funcionalidades de edición.
5.  **Simplificación del Registro:** Se modificó `register_screen.dart` para eliminar campos y establecer valores por defecto, agilizando la creación de cuentas.
6.  **Actualización de Blueprint:** Se documentaron todos los cambios realizados.
