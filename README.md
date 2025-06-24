# Event Booking App

This is a Flutter project for an Event Booking application using the MVC architecture with GetX for state management, routing, and dependency injection.

## Project Structure

- `lib/app/models/`: Data models like Event, User, Booking.
- `lib/app/views/`: UI screens and widgets.
- `lib/app/controllers/`: Business logic and state management.
- `lib/app/services/`: API calls and backend integration.
- `lib/app/bindings/`: GetX bindings for dependency injection.
- `lib/app/routes/`: Route definitions.
- `lib/config/`: App-wide configuration, themes, constants.
- `lib/core/`: Shared utilities and helpers.

## Getting Started

### Prerequisites

- Flutter SDK installed (version 3.6.1 or compatible).
- An IDE like VS Code or Android Studio.
- Git installed.

### Setup Instructions

1. **Clone the repository:**
   ```bash
   https://github.com/UP-Assignment-Exam/Event-Booking-App.git
   cd event_booking_app
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### Notes

- Make sure you have an emulator running or a physical device connected.
- The project uses GetX for state management and routing.
- Assets like images and icons are located in `assets/images/` and `assets/icons/`.

## Useful Commands

- `flutter pub get`: Install dependencies.
- `flutter run`: Run the app.
- `flutter build apk`: Build APK for Android.
- `flutter build ios`: Build for iOS.

## Contributing

Feel free to fork the repo and submit pull requests. Please follow the existing code style and structure.

## Contact

For questions or help, contact Mr.Neath at panhaneathpeng12@gmail.com.
