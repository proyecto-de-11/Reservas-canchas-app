# Blueprint: Aplicación con Autenticación y Flujo de Perfil para Jugadores

## Descripción General

Crear una aplicación Flutter enfocada en jugadores, con un flujo de autenticación completo, una pantalla para completar el perfil después del registro, una `HomeScreen` elegante, un formulario para `Crear Reservas` y una pantalla de `Perfil de Usuario`. La navegación se gestiona con `go_router`.

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

- **Ruta:** `/login`
- **Diseño:** Formulario de inicio de sesión simplificado.
- **Integración con API:** La función `login` en `auth_service.dart` consume el endpoint de la API de login (`/api/auth/login`).

### 2. Pantalla de Registro (`register_screen.dart`)

- **Ruta:** `/register`
- **Diseño:** Formulario de registro simplificado.
- **Lógica:**
    - El rol del nuevo usuario se asigna automáticamente como "Jugador".
    - El estado de la cuenta se establece como "Activada".
    - **Después de un registro exitoso, el usuario es redirigido a `/create-profile` para completar su información.**

### 3. **NUEVO:** Pantalla de Creación de Perfil (`create_profile_screen.dart`)

- **Ruta:** `/create-profile`
- **Propósito:** Permitir a los nuevos usuarios rellenar su perfil inmediatamente después de registrarse.
- **Diseño:** Un formulario completo con los siguientes campos:
    - `nombreCompleto`
    - `telefono`
    - `documentoIdentidad`
    - `fechaNacimiento` (usando un `DatePicker`)
    - `genero` (usando un `DropdownButton` con opciones "masculino", "femenino", "otro")
    - `fotoPerfil`
    - `biografia`
    - `ciudad`
    - `pais`
- **Lógica:**
    - El `usuarioID` se obtiene del usuario que acaba de registrarse.
    - Al enviar el formulario, se llama a un nuevo método `createProfile` en `api_service.dart`.
    - **Tras la creación exitosa del perfil, el usuario es redirigido a `/home`.**

### 4. Pantalla de Inicio (`home_screen.dart`)

- **Ruta:** `/home`
- **Diseño:** Saludo de bienvenida y tarjeta de acción principal.
- **Navegación:** El `Drawer` permite navegar a `/create-reservation` y `/profile`.

### 5. Pantalla de Crear Reserva (`create_reservation_screen.dart`)

- **Ruta:** `/create-reservation`
- **Diseño:** Formulario detallado para crear una nueva reserva.

### 6. Pantalla de Perfil (`profile_screen.dart`)

- **Ruta:** `/profile/:userId`
- **Diseño Detallado:** Muestra la información completa del perfil del usuario.
- **Navegación:** El botón "Cerrar Sesión" redirige a `/login`.

## Navegación (Routing)

La navegación es manejada por `go_router`. Las rutas configuradas son:

- `/login`: `LoginScreen`.
- `/register`: `RegisterScreen`.
- **NUEVO:** `/create-profile`: `CreateProfileScreen`.
- `/home`: `HomeScreen`.
- `/create-reservation`: `CreateReservationScreen`.
- `/profile/:userId`: `ProfileScreen`.
- `/search`: `SearchUsersScreen`.
- `/chats`: `ChatListScreen`.
- `/chat/:userId`: `ChatScreen`.

## Plan de Implementación Actual

1.  **Actualizar `api_service.dart`:** Añadir el método `createProfile`.
2.  **Crear `lib/screens/create_profile_screen.dart`:** Construir el formulario de perfil.
3.  **Actualizar `main.dart`:** Añadir la nueva ruta `/create-profile`.
4.  **Modificar `register_screen.dart`:** Redirigir a `/create-profile` tras un registro exitoso.

