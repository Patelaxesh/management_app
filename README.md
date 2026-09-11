# Management App

A Flutter Android application for product browsing, product details, cart management, and checkout using REST APIs.

## How to Run

### Prerequisites

* Flutter SDK
* Android Studio or VS Code
* Android emulator or physical Android device
* Internet connection

### Steps

```bash
flutter pub get
flutter run
```

To build the release APK:

```bash
flutter build apk --release
```

### Login Credentials

* **Username:** `emilys`
* **Password:** `emilyspass`

## Architecture Used

Simple layered architecture:

* **Screens** – UI
* **Providers** – State management
* **Models** – Data models
* **Services** – API calls
* **Routes** – Navigation

## State Management

**Provider** is used for state management.

## Libraries / Packages Used

* `provider` – State management
* `http` – REST API calls
* `shared_preferences` – Local storage

## Assumptions / Limitations

* Internet connection is required for API features.
* API functionality depends on the provided API.
* Payment processing is not implemented.
* Checkout is a demonstration flow.
* The application is developed and tested for Android.

