# Blueprint: Aplicación con Autenticación y Pantalla de Inicio Elegante

## Descripción General

Crear una aplicación Flutter con un flujo de autenticación de usuario completo (inicio de sesión y registro), una `HomeScreen` elegante y una pantalla funcional para `Crear Reservas` con un formulario detallado. La navegación se gestiona con `go_router`.

## Estilo y Diseño

- **Paleta de Colores:** Se utiliza un degradado azul (de `Color(0xFF007BFF)` a `Color(0xFF0056B3)`) como color primario.
- **Tipografía:** Se emplea `google_fonts` con la fuente "Poppins" para una apariencia profesional.
- **Componentes y Efectos Visuales:**
    - **Menú lateral (Drawer):** Centro de navegación principal con diseño moderno.
    - **Tarjetas (`Card`):** Se usan para agrupar información de forma limpia y con sombras sutiles, como en el formulario de reservas.
    - **Selectores Nativos:** Se usan `showDatePicker` y `showTimePicker` para una experiencia de usuario familiar.

## Funcionalidades y Flujo

### 1. Pantalla de Inicio de Sesión (`login_screen.dart`)

- **Ruta:** `/`
- **Diseño:** Formulario de inicio de sesión.

### 2. Pantalla de Registro (`register_screen.dart`)

- **Ruta:** `/register`
- **Diseño:** Formulario de registro.

### 3. Pantalla de Inicio (`home_screen.dart`)

- **Ruta:** `/home`
- **Diseño:** Saludo de bienvenida y tarjeta de acción principal.
- **Navegación:** El `Drawer` y la tarjeta principal dirigen a la pantalla de crear reserva.

### 4. Pantalla de Crear Reserva (`create_reservation_screen.dart`)

- **Ruta:** `/create-reservation`
- **Estructura:** Convertida a `StatefulWidget` para manejar el estado del formulario.
- **Diseño del Formulario:**
    - **Tarjeta de Detalles:** Una `Card` central agrupa todos los campos de la reserva.
    - **Campos Interactivos:**
        - `Fecha de la Reserva`: Al tocar, abre un selector de fecha (`showDatePicker`).
        - `Hora de Inicio`: Abre un selector de hora (`showTimePicker`).
        - `Hora de Fin`: Abre un selector de hora (`showTimePicker`).
    - **Campos Automáticos y Fijos:**
        - `Total de Horas`: Se calcula automáticamente basado en la hora de inicio y fin.
        - `Método de Pago`: Valor fijo mostrado como "Efectivo".
        - `Monto Total a Pagar`: Valor de ejemplo (placeholder).
        - `Estado`: Valor fijo mostrado como "Pendiente".
    - **Botón de Confirmación:** Un `ElevatedButton` para enviar el formulario.

## Navegación (Routing)

La navegación es manejada por `go_router`. Las rutas configuradas son:

- `/`: `LoginScreen`.
- `/register`: `RegisterScreen`.
- `/home`: `HomeScreen`.
- `/create-reservation`: `CreateReservationScreen`.

## Pasos de Implementación Realizados

1.  **Flujo de Autenticación y `HomeScreen`:** Se crearon las pantallas iniciales y se reestructuró la `HomeScreen`.
2.  **Conexión de la Pantalla de Reservas:**
    - Se creó el archivo `lib/create_reservation_screen.dart`.
    - Se añadió la ruta `/create-reservation` en `go_router`.
    - Se conectaron los botones desde `home_screen.dart`.
3.  **Implementación del Formulario de Reserva:**
    - Se añadió el paquete `intl` para el formato de fechas.
    - Se convirtió `CreateReservationScreen` en un `StatefulWidget`.
    - Se diseñó y construyó el formulario detallado con campos interactivos para fecha y hora, y campos de información estática.
4.  **Actualización de Blueprint:** Se documentó la estructura detallada del nuevo formulario de reservas.
