# BookApp

A Flutter app to browse, search, and view books using the Google Books API. Includes email/password and Google authentication, user profile, and category-based book browsing.

---

## Screenshots

> Replace these with your own screenshots from the app

| Home Screen | Book Detail | Profile |
|-------------|-------------|---------|
| ![Home](assets/screenshots/home.png) | ![Detail](assets/screenshots/detail.png) | ![Profile](assets/screenshots/profile.png) |

---

## State Management

This app uses **GetX** for state management. GetX provides reactive variables and controllers to manage UI state and business logic efficiently.

- Controllers (e.g., `HomeController`, `AuthController`) are created with `Get.put()` and accessed via `Get.find()`.
- UI widgets use `Obx()` to listen for changes in reactive variables and update automatically.
- Example: `HomeController` manages the book list, loading state, and filter selection. `AuthController` manages authentication and user info.

---

## Assumptions & Limitations

- The app assumes the Google Books API and Firebase user model provide all required fields (title, authors, thumbnail, etc.).
- "Popular" books filtering is limited if the API/model does not provide a rating field.
- "New" books are filtered by published date if available.
- Filter and search state are not persisted across app restarts.
- Error handling is basic (snackbars for errors).
- Only one instance of each controller is used globally via GetX.

---

## Getting Started

1. Clone the repo and run `flutter pub get`.
2. Add your Firebase config and assets.
3. Run the app with `flutter run`.

---



