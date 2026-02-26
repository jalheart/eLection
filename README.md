# eLection: Modern Digital Voting System

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=flat&logo=dart&logoColor=white)](https://dart.dev)
[![Architecture: Hexagonal](https://img.shields.io/badge/Architecture-Hexagonal-orange.svg)](<https://en.wikipedia.org/wiki/Hexagonal_architecture_(software)>)

**eLection** is a robust, secure, and highly customizable digital voting management system designed for educational institutions and small-to-medium organizations. Built with **Flutter** and following **Hexagonal Architecture** principles, it ensures a clean separation of concerns, maintainability, and data integrity.

---

## 🚀 Key Features

### 🗳️ Voting & Participation

- **Secure Voting Flow:** Intuitive step-by-step voting process for students/voters.
- **Auto-Logout:** Enhanced security with automatic session termination after voting.
- **Voter Authentication:** Login via document ID with optional password verification.
- **Real-time Progress:** Monitor voting activity safely from the admin panel.

### 🛠️ Administrative Control

- **Dynamic Configuration:** Customize institution name, slogan, logo, and theme color.
- **Grading & Categories:** Manage academic grades and electoral categories (e.g., Personero, Contralor).
- **Candidate Registry:** Full CRUD operations for candidates with photo support.
- **Assignment Logic:** Easily link specific categories to relevant grades.

### 📊 Reporting & Maintenance

- **Instant Results:** Real-time calculation of election outcomes.
- **Export Capabilities:** Generate PDF reports and Excel exports for final tallies.
- **Data Mobility:** Import/Export full database backups for security and migration.
- **Offline First:** Local database powered by Drift (SQLite) ensures stability during elections.

---

## 🏗️ Architecture: Hexagonal (Ports & Adapters)

The project follows the **Hexagonal Architecture** pattern to ensure the business logic is independent of external factors like the database or UI.

- **Domain Layer (`lib/domain`):** Contains the core business entities (Voter, Candidate, Vote, etc.) and contract definitions (Repository interfaces).
- **Application Layer (`lib/application`):** Orchestrates the business flow through **Use Cases**. It also manages the application state using the **Provider** pattern.
- **Infrastructure Layer (`lib/infrastructure`):** Implements the concrete adapters for external services.
  - `database/`: Drift (SQLite) implementations of repository interfaces.
  - `services/`: Concrete implementations for PDF generation, backups, etc.
  - `ui/`: The Flutter widget layer (Pages, Widgets, Themes).

---

## 🛠️ Technology Stack

- **Framework:** [Flutter](https://flutter.dev) (v3.x)
- **Language:** [Dart](https://dart.dev)
- **State Management:** [Provider](https://pub.dev/packages/provider)
- **Local Persistence:** [Drift](https://pub.dev/packages/drift) (SQLite)
- **Dependency Injection:** Via Provider/ProxyProvider
- **Internationalization:** [Flutter Localizations](https://docs.flutter.dev/accessibility-and-localization/internationalization) (Supporting ES, EN, FR, PT)
- **UI Components:** Material 3, `data_table_2`, `google_fonts`
- **Reports:** `pdf`, `printing`, `excel`

---

## 🚦 Getting Started

### Prerequisites

- Flutter SDK installed.
- Dart SDK configured.
- (Optional) Firebase Studio / IDX environment.

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd eLection
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```

### Code Generation

This project uses `drift_dev` and `build_runner` for database code generation. If you modify database schemas or entities, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Running the App

- **Debug mode:**
  ```bash
  flutter run
  ```
- **Windows Build:**
  ```bash
  flutter build windows
  ```

---

## 📁 Project Structure

```text
lib/
├── application/       # Use Cases & Providers (Business Logic)
├── domain/            # Entities & Repository Interfaces (Core)
├── infrastructure/    # Database, Services & UI Widgets (Adapters)
│   ├── database/      # Drift/SQLite implementations
│   ├── services/      # PDF, Backup, Security
│   └── ui/            # Flutter Pages & Global Styles
├── l10n/              # Internationalization (ARB files)
└── main.dart          # Entry point & Dependency Injection setup
```

---

## 🤝 Developed By

- **Jaime Hernández**
- **Antigravity**

---

## 📄 License

This project is private and intended for specific use cases. All rights reserved.
