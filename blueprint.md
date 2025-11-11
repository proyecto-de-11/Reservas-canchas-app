# Blueprint: Aplicación con Autenticación y Pantalla de Inicio Elegante

## Descripción General

Crear una aplicación Flutter con un flujo de autenticación de usuario completo (inicio de sesión y registro) y una `HomeScreen` con un diseño limpio y elegante. La navegación principal de la aplicación se centraliza en un menú lateral (`Drawer`) bien diseñado. La navegación se gestiona con `go_router`.

## Estilo y Diseño

- **Paleta de Colores:** Se utiliza un degradado azul (de `Color(0xFF007BFF)` a `Color(0xFF0056B3)`) como color primario. El fondo de la `HomeScreen` tiene un gradiente sutil (`Colors.blue.shade50` a `Colors.grey.shade200`) que añade profundidad.
- **Tipografía:** Se emplea `google_fonts` con la fuente "Poppins" para una apariencia profesional y consistente.
- **Animaciones:** La `HomeScreen` cuenta con una animación de desvanecimiento (`FadeTransition`) para una carga suave del contenido.
- **Componentes y Efectos Visuales:**
    - **Menú lateral (Drawer):** Es el centro de navegación principal. Presenta un diseño moderno con un encabezado de usuario prominente, iconos de colores para cada acción y un efecto de respuesta táctil (`InkWell`).
    - **Tarjeta de Contenido Principal (`HomeScreen`):** El cuerpo de la pantalla de inicio ahora presenta una única tarjeta grande y elegante que invita al usuario a realizar una acción clave, en lugar de una cuadrícula de botones.
    - **Diseño limpio:** La interfaz se ha simplificado para evitar la sobrecarga visual, centrando la atención en el contenido más relevante.

## Funcionalidades y Flujo

### 1. Pantalla de Inicio de Sesión (`login_screen.dart`)

- **Ruta:** `/`
- **Diseño:** Formulario de inicio de sesión.
- **Navegación:**
    - Al tocar "Iniciar Sesión", redirige a `/home`.
    - Al tocar "Regístrate", redirige a `/register`.

### 2. Pantalla de Registro (`register_screen.dart`)

- **Ruta:** `/register`
- **Diseño:** Formulario de registro.
- **Navegación:**
    - Al tocar "Inicia Sesión", redirige de vuelta a `/`.

### 3. Pantalla de Inicio (`home_screen.dart`) - Reestructurada

- **Ruta:** `/home`
- **Diseño:**
    - Un `AppBar` con el título "Inicio".
    - El **cuerpo principal** ahora contiene un saludo de bienvenida y una **tarjeta de contenido principal** que anima al usuario a "Reservar una Cancha".
    - **Ya no hay una cuadrícula de botones en el cuerpo principal.**
- **Navegación (Centralizada en el `Drawer`):**
    - El `Drawer` (menú lateral) ha sido rediseñado para ser el **centro de navegación principal**. Contiene las siguientes opciones:
        - "Reservar Cancha"
        - "Mis Reservas"
        - "Historial"
        - "Mi Perfil"
        - "Configuración"
    - La opción "Cerrar Sesión" en el `Drawer` redirige al usuario a la pantalla de inicio de sesión (`/`).

## Navegación (Routing)

La navegación es manejada por `go_router`. Las rutas configuradas son:

- `/`: `LoginScreen`.
- `/register`: `RegisterScreen`.
- `/home`: `HomeScreen`.

## Pasos de Implementación Realizados

1.  **Flujo de Autenticación Inicial:** Se crearon las pantallas de inicio de sesión y registro.
2.  **Primera Versión de `HomeScreen`:** Se diseñó una pantalla de inicio con una cuadrícula de botones.
3.  **Reestructuración de `HomeScreen`:**
    - Se **movieron todas las acciones de navegación** desde la cuadrícula del cuerpo principal al **menú lateral (`Drawer`)**.
    - Se **rediseñó el `Drawer`** para convertirlo en el centro de navegación, con un estilo visual mejorado.
    - Se **eliminó la cuadrícula de botones** del cuerpo de la pantalla.
    - Se **diseñó una nueva tarjeta de contenido principal** para la `HomeScreen`, creando una interfaz más limpia y enfocada.
4.  **Actualización de Blueprint:** Se actualizó este documento para reflejar la nueva arquitectura centrada en el `Drawer` y el diseño simplificado de la `HomeScreen`.
