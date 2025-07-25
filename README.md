# 🎫 Event Booking App

A **Flutter** project for an Event Booking application, structured using **MVC architecture** and leveraging **GetX** for state management, routing, and dependency injection.

---

## 📁 Project Structure

* `lib/app/models/` — Data models (e.g., Event, User, Booking)
* `lib/app/views/` — UI screens and widgets
* `lib/app/controllers/` — Business logic and state management
* `lib/app/services/` — API calls and backend integration
* `lib/app/bindings/` — GetX bindings for dependency injection
* `lib/app/routes/` — Route definitions
* `lib/config/` — App-wide configuration, themes, constants
* `lib/core/` — Shared utilities and helpers

---

## 🔧 Requirements

* Flutter SDK (version 3.6.1 or compatible)
* Git
* An IDE (e.g., **VS Code**, **Android Studio**, or **IntelliJ**)

---

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/UP-Assignment-Exam/Event-Booking-App.git
cd event_booking_app
```

### 2. Pull Latest Updates

> **Tip:** Keep your local project updated:
>
> ```bash
> git pull origin main
> ```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

> Make sure you have an emulator running or a physical device connected.

---

## ⚙️ Useful Commands

| Command             | Description                    |
| ------------------- | ------------------------------ |
| `flutter pub get`   | Install dependencies           |
| `flutter run`       | Run the app on emulator/device |
| `flutter build apk` | Build APK for Android          |
| `flutter build ios` | Build for iOS                  |

---

## 📦 How to Push Changes to GitHub

### 1. Check Current Status

```bash
git status
```

> See which files have been modified.

### 2. Add Files to Staging

```bash
git add .
```

> Or add specific files instead of all:
>
> ```bash
> git add lib/app/views/new_view.dart
> ```

### 3. Commit Your Changes

```bash
git commit -m "Add feature: user can book events"
```

> Use meaningful commit messages.

### 4. Push to GitHub

```bash
git push origin main
```

> Replace `main` with your branch name if you’re working on a different branch.

---

## 📝 Additional Notes

* The app uses **GetX** for:

  * State management
  * Routing
  * Dependency injection
* Assets like images and icons are in `assets/images/` and `assets/icons/`.
* Follow existing code style and structure for consistency.
* If issues occur, check your Flutter version and installed dependencies.

---

## 🤝 Contributing

* Fork the repository.
* Create a new branch: `git checkout -b feature/your-feature-name`
* Make your changes.
* Commit and push: `git push origin feature/your-feature-name`
* Submit a pull request.

---

## 📬 Contact

For questions or support, contact **Mr. Neath** at
📧 [panhaneathpeng12@gmail.com](mailto:panhaneathpeng12@gmail.com)

---

If you'd like, I can also help design a logo/banner, add screenshots, or write a short “About” section for the app!
Let me know! 🚀
