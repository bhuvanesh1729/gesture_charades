# Gesture Charades

A Flutter app for playing gesture charades with friends. Perfect for parties and gatherings!

## Features

- **Random Word Display**: Shows a word/phrase to act out
- **Swipe-Up Gesture**: Swipe up to get the next word
- **Timer**: Countdown for each round
- **Score Tracker**: Keeps score for correct guesses
- **Team Mode**: Compete in teams
- **Multiple Categories**: Choose from movies, actions, celebrities, animals, and more
- **Phone Flip Detection**: Flip your phone to get the next word

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Android Studio / Xcode for mobile deployment
- Git

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/bhuvanesh1729/gesture_charades.git
   ```

2. Navigate to the project directory:
   ```
   cd gesture_charades
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

## Project Structure

The project follows a modular architecture:

- `app/`: Main Flutter application
- `packages/`: Shared packages and modules
  - `core_models/`: Core data models
  - `language_pack/`: Internationalization and word packs

## Building and Deployment

### Development Build

```bash
flutter build apk --debug
flutter build ios --debug
```

### Production Build

```bash
flutter build apk --release
flutter build ios --release
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
