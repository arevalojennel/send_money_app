# 💸 Send Money App

A Flutter application that allows users to send money, view their wallet balance, and track transaction history. Built with **Clean Architecture** and **Cubit** state management, it uses a fake REST API (JSONPlaceholder) for demonstration but gracefully falls back to local storage when the API fails. The app includes full unit test coverage for use cases and cubits.

---

## ✨ Features

- **4 Screens**:
  1. **Login Screen** – Simple authentication with hardcoded credentials (`user` / `pass`). Password visibility toggle.
  2. **Home Screen** – Displays wallet balance with show/hide toggle (eye icon). Buttons to navigate to Send Money and Transaction History. Logout available.
  3. **Send Money Screen** – Numeric input field for amount. Validates against current balance. On submit, shows a bottom sheet indicating success or failure. Transactions are stored locally even if the API call fails.
  4. **Transaction History Screen** – Lists all sent transactions with amount and timestamp.

- **Business Logic**:
  - Login and logout (logout available on all screens).
  - Wallet balance starts at ₱500.00.
  - Send money only if amount ≤ balance.
  - Transactions persisted locally; API is a best‑effort sync.

---

## 🏗️ Architecture

The project follows **Clean Architecture** with three layers:

- **Domain Layer** – Contains entities, repository interfaces, and use cases. Independent of external frameworks.
- **Data Layer** – Implements repositories, remote data sources (API), and models. Handles API calls to JSONPlaceholder and in‑memory local storage.
- **Presentation Layer** – Contains Cubits (state management) and UI screens. Depends on domain layer to execute use cases.

**State Management**: `flutter_bloc` (Cubit) is used for each feature:
- `AuthCubit` – login/logout.
- `HomeCubit` – wallet balance and show/hide toggle.
- `SendMoneyCubit` – amount submission, validation, and calling the `SendMoney` use case.
- `TransactionsCubit` – loading and caching the transaction list.

**Dependency Injection**: `get_it` for service location.

---

## 🛠️ Tech Stack

- Flutter SDK
- `flutter_bloc` – Cubit state management
- `equatable` – value equality
- `http` – API calls
- `get_it` – dependency injection
- `dartz` – functional error handling (`Either`)
- `bloc_test` – Cubit testing
- `mockito` – mocking for tests
- `build_runner` – generating mock files

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (version 3.0 or higher) – [Install Flutter](https://flutter.dev/docs/get-started/install)
- Android Studio / Xcode for emulators or a physical device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/arevalojennel/send-money-app.git
   cd send-money-app


2. **Install dependencies**
   ```bash
   flutter pub get

3. **Run the app**
   ```bash
   flutter run

The app will launch on your connected device/emulator. Use credentials user / pass to log in.

---

## 🧪 Running Unit Tests

The project includes comprehensive unit tests for use cases and cubits.

1. **Generate mock files (required for tests using mockito):**
      ```bash
      flutter pub run build_runner build --delete-conflicting-outputs

2. **Run all test:**
      ```bash
      flutter test

All tests should pass, confirming that the core logic works as expected.

---

## 🌐 API Integration

The app uses [JSONPlaceholder](https://jsonplaceholder.typicode.com/) as a fake REST API:
- GET /posts?userId=1 – retrieves a list of "transactions" (mocked from posts).
- POST /posts – creates a new transaction (simulates sending money).

 **Important**:  JSONPlaceholder does not persist data. Therefore, all transactions created during a session are stored locally in memory. This ensures that even if the API is down, transactions are recorded and displayed. On logout, the local list is cleared.

---

## 📁 Project Structure


      lib/
      ├── core/                     # Shared utilities (errors, network)
      ├── data/                     # Data layer (datasources, models, repositories)
      ├── domain/                   # Domain layer (entities, repositories interfaces, use cases)
      ├── presentation/             # Presentation layer (cubits, screens, theme)
      ├── injection_container.dart   # Dependency injection setup
      └── main.dart                  # App entry point
      test/                          # Unit tests for use cases and cubits

---

## ⏱️ Time Spent

Approximately 10.5 hours on design, implementation, testing, and documentation.

---

## 📄 License

This project is for demonstration purposes only. All code is provided as‑is under the MIT License.

---

## 📧 Contact

For questions or feedback, please contact arevalojennel@gmail.com.