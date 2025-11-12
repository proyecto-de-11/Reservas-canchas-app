<div align="center">

# Cancha-Now
### Tu Cancha. Tus Reglas. Tu App.

</div>

<p align="center">
  <img src="https://storage.googleapis.com/flutter-a-test-ഘ-prod/brand-assets/Cancha-Now-Hero-Frame.png" alt="Cancha-Now Hero"/>
</p>

<p align="center">
    <img src="https://img.shields.io/badge/Flutter-v3.x-0056B3?style=for-the-badge&logo=flutter" alt="Flutter Version">
    <img src="https://img.shields.io/badge/Estado-Activo-5cb85c?style=for-the-badge" alt="Project Status">
    <img src="https://img.shields.io/github/last-commit/google/flutter.widgets/main?style=for-the-badge&logo=github&label=updates" alt="Last Commit">
    <img src="https://img.shields.io/badge/Licencia-MIT-blueviolet?style=for-the-badge" alt="License">
</p>

---

## 🤔 **¿Qué es Cancha-Now?**

**Cancha-Now** es la solución definitiva para modernizar el mundo de las reservas deportivas. Es un ecosistema digital completo construido en **Flutter** que ofrece una experiencia de usuario premium, fluida y profesional, con interfaces separadas y optimizadas para **Jugadores** y **Propietarios** de canchas.

<br>

## ✨ **¿Por Qué Cancha-Now?**

<table width="100%">
  <tr>
    <td align="center" width="33%">
      <img src="https://storage.googleapis.com/flutter-a-test-ഘ-prod/brand-assets/icon-design.png" width="80">
      <h3>Diseño de Élite</h3>
      <p>Interfaces premium con foco en la experiencia de usuario.</p>
    </td>
    <td align="center" width="33%">
      <img src="https://storage.googleapis.com/flutter-a-test-ഘ-prod/brand-assets/icon-speed.png" width="80">
      <h3>Multiplataforma Nativo</h3>
      <p>Un solo código base para un rendimiento excepcional en iOS, Android y Web.</p>
    </td>
    <td align="center" width="33%">
      <img src="https://storage.googleapis.com/flutter-a-test-ഘ-prod/brand-assets/icon-stack.png" width="80">
      <h3>Arquitectura Escalable</h3>
      <p>Construido para crecer, fácil de mantener y expandir con nuevas funciones.</p>
    </td>
  </tr>
</table>

---

##  галерея: Un Vistazo por Dentro

<table width="100%">
  <tr>
    <td align="center">
      <h4>Login Moderno</h4>
      <img src="https://storage.googleapis.com/flutter-a-test-ഘ-prod/screenshots/Cancha-Now-Login.png" alt="Login Screen" width="220">
    </td>
    <td align="center">
      <h4>Panel de Propietario</h4>
      <img src="https://storage.googleapis.com/flutter-a-test-ഘ-prod/screenshots/Cancha-Now-Owner.png" alt="Owner Panel" width="220">
    </td>
    <td align="center">
      <h4>Detalles de Cancha</h4>
      <img src="https://storage.googleapis.com/flutter-a-test-ഘ-prod/screenshots/Cancha-Now-Details.png" alt="Court Details" width="220">
    </td>
  </tr>
</table>

---

## 🚀 **Stack Tecnológico de Vanguardia**

<p align="center">
  <i>Solo las mejores herramientas para un producto de primera.</i>
</p>

<div align="center" style="display: flex; justify-content: center; align-items: center; gap: 15px;">
  <a href="https://flutter.dev">
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
  </a>
  <a href="https://dart.dev">
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
  </a>
  <a href="https://firebase.google.com">
    <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase">
  </a>
  <a href="https://pub.dev/packages/go_router">
    <img src="https://img.shields.io/badge/Go_Router-8A2BE2?style=for-the-badge" alt="Go Router">
  </a>
  <a href="https://fonts.google.com">
    <img src="https://img.shields.io/badge/Google_Fonts-4285F4?style=for-the-badge&logo=google&logoColor=white" alt="Google Fonts">
  </a>
</div>

---

<details>
<summary><h3>🏗️ Ver Arquitectura del Proyecto</h3></summary>
<br>

```mermaid
graph TD
    %% Styling
    classDef ui fill:#007BFF,stroke:#333,stroke-width:2px,color:#fff;
    classDef nav fill:#8A2BE2,stroke:#333,stroke-width:2px,color:#fff;
    classDef logic fill:#5cb85c,stroke:#333,stroke-width:2px,color:#fff;
    classDef data fill:#FF8C00,stroke:#333,stroke-width:2px,color:#fff;
    classDef backend fill:#1E90FF,stroke:#333,stroke-width:2px,color:#fff;

    subgraph "📱 UI Layer"
        A[LoginScreen]
        B[HomeScreen]
        C[OwnerHomeScreen]
        D[ProfileScreen]
    end

    subgraph "🚦 Navigation"
        Router(GoRouter)
    end

    subgraph "💼 Logic Layer"
        F[State Notifiers]
        G[Services]
    end

    subgraph "💾 Data Layer"
        H[Data Models]
        I[Repositories]
    end

    subgraph "☁️ Backend"
        J[Firebase / API]
    end

    A & B & C & D --> Router --> A & B & C & D;
    B & C & D --> F --> G --> I --> J;
    I --> H;

    class A,B,C,D ui;
    class Router nav;
    class F,G logic;
    class H,I data;
    class J backend;
```
</details>

---

<div align="center">
  <h2>¿Listo para empezar?</h2>
  <p>Clona el repositorio y lleva la gestión de canchas al siguiente nivel.</p>
  <pre><code>git clone https://github.com/tu-usuario/cancha-now.git && cd cancha-now && flutter pub get && flutter run</code></pre>
</div>
