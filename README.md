Of course. Based on the project structure from your images and the context from the GitHub repository, here is a more complete and well-styled version of your mobile application documentation.

---

# Mobile Application Documentation

## Overview

The Vira mobile application allows users to discover, browse, and book places of interest. It provides a seamless user experience for managing bookings and user profiles.

-   **Platform**: Android / iOS
-   **Framework**: Flutter
-   **State Management**: Riverpod
-   **Architecture**: Feature-First Clean Architecture
-   **API Communication**: REST with Dio

---

## Table of Contents

-   App Features
-   Architecture
-   Project Structure
-   Environment Setup
-   API Integration
-   Authentication Flow
-   State Management
-   Error Handling
-   Build & Release

---

## App Features

-   **Authentication**: Secure user registration and login functionality.
-   **Place & Region Discovery**: Users can browse places, view detailed information, and explore different regions.
-   **Seamless Booking**: An intuitive booking system allows users to create and manage their reservations.
-   **User Profile Management**: Users can view and manage their personal information.
-   **Home Dashboard**: A central screen that provides an overview of available places and regions.
-   **Onboarding**: A simple and welcoming introduction for new users.

---

## Architecture

The application is built using a **Feature-First Clean Architecture**. This approach isolates features from one another, making the codebase scalable, maintainable, and easy to test.

The core layers within each feature are:

-   **Presentation**: Contains the UI elements, including screens and feature-specific widgets. It listens to the application layer for state changes.
-   **Application**: Manages the state of the feature using Riverpod providers and controllers. It orchestrates calls to the data layer.
-   **Data**: Responsible for data retrieval and management. It includes repositories, data sources (remote and local), and data models.
-   **Domain** (Implicit): While not a separate folder, the Repositories act as an abstraction layer between the application and data sources, defining the contracts for data operations.

---

## Project Structure

The project is organized into two main directories: `core` and `features`.

```
lib/
├── core/
│   ├── config/         # App-wide constants, themes, colors, and assets.
│   ├── extensions/     # Dart extensions for easy-to-use helper methods.
│   ├── network/        # API client, interceptors, and network result handlers.
│   ├── services/       # Shared services like caching.
│   ├── utils/          # Utility classes (e.g., logger, debouncer).
│   └── widgets/        # Common UI widgets shared across all features.
│
├── features/
│   ├── auth/           # Authentication feature (login, register).
│   │   ├── application/
│   │   ├── data/
│   │   └── presentation/
│   ├── booking/        # Booking management feature.
│   ├── home/           # Home screen feature.
│   ├── places/         # Place details and listing feature.
│   └── ... (other features)
│
├── shared/
│   └── providers/      # Riverpod providers with application-wide scope.
│
└── main.dart           # The application's entry point.
```

---

## Environment Setup

The API Base URL is centrally configured to allow for easy switching between development and production environments.

**Configuration Location:**
```dart
// lib/core/config/app_constants.dart

const String baseUrl = "https://api.example.com/v1";
```

---

## API Integration

-   All HTTP requests are managed through a centralized `ApiClient` built on top of the `dio` package.
-   **Interceptors** are used to automatically inject the JWT token into requests (`auth_interceptor`) and log network activity (`log_interceptor`).
-   Responses are wrapped in a custom `ApiResult` class to handle success and error states gracefully across the application.

---

## Authentication Flow

1.  **Login**: The user authenticates with their credentials via the `AuthRepository`.
2.  **Token Storage**: Upon success, the JWT is securely stored on the device using the `CacheService` (which utilizes `shared_preferences`).
3.  **Authenticated Requests**: The `auth_interceptor` automatically retrieves the stored token and attaches it to the `Authorization` header of all subsequent API requests.
4.  **Logout/Token Expiry**: If the API returns an unauthorized (`401`) response, the interceptor will clear the stored token and user data, effectively logging the user out and redirecting them to the login screen.

---

## State Management

-   The application uses **Riverpod** for declarative, compile-safe, and scalable state management.
-   **Providers** are used to expose repositories, controllers, and services to the UI layer, enabling a clean separation of concerns.
-   State changes in the UI are driven by listening to these providers.

---

## Error Handling

-   Network and business logic errors from the API are caught in the `ApiClient` and `Repositories`.
-   Errors are converted into user-friendly messages and exposed to the UI via state.
-   Validation errors from the backend (e.g., "Email is required") can be displayed directly in the relevant input fields to provide clear feedback to the user.

---

## Build & Release

Standard Flutter CLI commands are used to build the application for release.

**Build for Android (APK):**
```bash
flutter build apk --release
```

**Build for iOS:**
```bash
flutter build ios --release
```