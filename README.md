# 📝 Flutter Notes App

A feature-rich note-taking application built with Flutter and Dart, featuring offline-first architecture with local SQLite storage and beautiful UI with dark mode support.

## ✨ Features

### Core Functionality
- **Create & Edit Notes**: Rich text editing with title and content fields
- **Search & Filter**: Real-time search across all notes with instant results
- **Smart Sorting**: Sort notes by creation date, last modified, or alphabetically by title
- **Custom Labels**: Organize notes with color-coded custom labels and filter by them
- **Swipe to Delete**: Intuitive swipe gesture with confirmation dialog
- **Undo Delete**: Restore accidentally deleted notes with snackbar action

### UI/UX
- **Dark Mode Toggle**: Beautiful light and dark themes with smooth transitions
- **Responsive Design**: Optimized layouts for both phones and tablets
- **Form Validation**: Real-time validation ensuring non-empty titles and content
- **Material Design**: Clean, modern interface following Material Design principles

### Technical Features
- **Offline-First**: All data stored locally using SQLite database
- **State Management**: Powered by GetX for reactive UI updates
- **Navigation**: Clean navigation with GetX named routes and bindings
- **Data Persistence**: Robust SQLite integration with custom service layer
- **Reactive UI**: Real-time updates using GetX observables (RxList, RxString)

## 🏗️ Architecture

### Tech Stack
- **Frontend**: Flutter + Dart
- **State Management**: GetX
- **Database**: SQLite (sqflite)
- **Navigation**: GetX Named Routes
- **Theme Management**: GetX Theme Controller

### Project Structure
```
lib/
├── controller/
│   └── note_controller.dart
├── models/
│   └── note.dart
├── service/
│   └── note_service.dart
├── views/
│   ├── home_screen.dart
│   └── note_screen.dart
└── main.dart
```
### Video Sample
https://github.com/user-attachments/assets/ccc0a365-caf5-41b2-8adc-538616576dd3

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code
- Android SDK (for Android builds)
- Xcode (for iOS builds - macOS only)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/prathmesh-d-glitch/notes_app
   cd flutter_notes_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For debug mode
   flutter run
   
   # For release mode
   flutter run --release
   
   # For specific device
   flutter run -d <device_id>
   ```

4. **Build for production**
   ```bash
   # Android APK
   flutter build apk --release
   
   # Android App Bundle
   flutter build appbundle --release
   
   # iOS (macOS only)
   flutter build ios --release
   ```

## 📱 Usage Guide

### Creating Notes
1. Tap the **+** floating action button on the home screen
2. Enter a title and content for your note
3. Optionally assign custom labels for organization
4. Tap **Save** to store the note locally

### Managing Notes
- **Search**: Use the search bar to find notes by title or content
- **Sort**: Tap the sort button to organize by date (newest/oldest) or title (A-Z/Z-A)
- **Filter by Labels**: Select label chips to show only notes with specific labels
- **Edit**: Tap any note to open the edit screen
- **Delete**: Swipe left on any note and confirm deletion
- **Undo Delete**: Tap "Restore" in the snackbar that appears after deletion

### Customization
- **Dark Mode**: Toggle dark/light theme from the settings menu or app bar
- **Labels**: Create, edit, and assign color-coded labels to organize your notes
- **Responsive UI**: The app automatically adapts to your device screen size

## 🔧 Development

### Key Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6           # State management & navigation
  sqflite: ^2.3.0       # SQLite database
  path: ^1.8.3          # Path manipulation
  intl: ^0.18.1         # Date formatting
```

### Database Schema
```sql
-- Notes table
CREATE TABLE notes (
  id TEXT PRIMARY KEY,
  title TEXT,
  content TEXT,
  labels TEXT,       -- JSON string for storing labels
  createdAt TEXT,
  updatedAt TEXT
);
```

**Database Implementation:**
```dart
Future<void> _createTables(Database db) async {
  await db.execute('''
    CREATE TABLE notes (
      id TEXT PRIMARY KEY,
      title TEXT,
      content TEXT,
      labels TEXT,
      createdAt TEXT,
      updatedAt TEXT
    )
  ''');
}
```

### GetX Controllers Overview
- **NoteController**: Manages note CRUD operations, search, sorting, theme switching, and label filtering
- **NoteService**: Handles SQLite database operations and data persistence

## 🎨 Customization

### Adding New Themes
1. Define theme data in the `NoteController`
2. Update theme switching logic in the controller
3. Add theme selection UI in the home screen app bar

### Extending Label System
1. Modify `Note` model to enhance label properties
2. Update database operations in `NoteService`
3. Enhance label filtering and UI in `NoteController` and views

