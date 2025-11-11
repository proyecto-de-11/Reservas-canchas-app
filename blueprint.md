
# Plan de Desarrollo: Pantalla de Inicio de Sesión

## Descripción General

Crear una pantalla de inicio de sesión visualmente atractiva y funcional para la aplicación de reserva de canchas. La pantalla contará con campos para el nombre de usuario y la contraseña, y un botón para iniciar sesión. Se implementará una validación para asegurar que la contraseña tenga un mínimo de 8 caracteres.

## Estilo y Diseño

- **Fondo:** Un degradado lineal de dos colores para dar un aspecto moderno y vibrante.
- **Tipografía:** Se utilizará el paquete `google_fonts` para una tipografía elegante y legible.
- **Componentes:**
    - Un ícono representativo en la parte superior.
    - Campos de texto con bordes redondeados, iconos y etiquetas.
    - Un botón de inicio de sesión con esquinas redondeadas y un color que resalte.
- **Animación:** Se agregará una animación sutil para mejorar la experiencia del usuario.

## Pasos de Implementación

1.  **Crear el archivo:** Generar un nuevo archivo `lib/login_screen.dart` para la pantalla de inicio de sesión.
2.  **Agregar dependencias:** Añadir `google_fonts` al archivo `pubspec.yaml` para las fuentes personalizadas.
3.  **Diseñar la interfaz de usuario (UI):**
    - Implementar un `Scaffold` con un `Container` que tenga un fondo degradado.
    - Añadir un `SingleChildScrollView` para evitar problemas de desbordamiento en pantallas pequeñas.
    - Estructurar el contenido en una `Column` con:
        - Un `Icon` para el logo.
        - Un `Text` para el título "Bienvenido".
        - Dos `TextFormField` para el usuario y la contraseña.
        - Un `ElevatedButton` para el botón de "Ingresar".
4.  **Estilizar los componentes:**
    - Aplicar el degradado al `Container`.
    - Usar `GoogleFonts` para el texto.
    - Personalizar los `TextFormField` con `InputDecoration` para los bordes, etiquetas e iconos.
    - Asegurar que el campo de contraseña oculte el texto.
    - Implementar la lógica de validación para la longitud de la contraseña.
    - Darle estilo al `ElevatedButton`.
5.  **Integrar la pantalla:** Modificar `lib/main.dart` para que la `LoginScreen` sea la pantalla principal de la aplicación.
