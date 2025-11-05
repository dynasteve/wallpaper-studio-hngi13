# Wallpaper Studio

**Wallpaper Studio** is a Flutter-based desktop app that lets users browse, preview, and manage wallpapers with category filtering, favourites, and customizable setup options. Made for the HNGI13 program.

## 🚀 Features

* 🖼️ **Wallpaper Browser**
  View wallpapers by category in grid or list view.

* 💾 **Local Database (SQLite)**
  Stores wallpaper metadata such as category, tags, favourites, and active status.

* ❤️ **Favourites**
  Save wallpapers you love for quick access.

* 🎨 **Wallpaper Setup page**
  Configure active wallpapers, choose display modes (Fit, Fill, Stretch, Tile), enable auto-rotation, and manage advanced options like syncing and locking.

* 🎨 **Tile and list view**
  Be able to toggle into tiles(grid) or a list view with the ease of 1 button press.

## 🛠️ Tech Stack

* **Framework:** Flutter (Material 3)
* **Language:** Dart
* **Database:** sqflite / sqflite_ffi for desktop
* **State Management:** Stateful widgets
* **Assets:** Local image files (from `/assets`)

## ⚙️ Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/wallpaper-studio-hngi13.git
   cd wallpaper-studio-hngi13
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run the app:**

   ```bash
   flutter run
   ```

4. **Build for desktop (optional):**

   ```bash
   flutter build macos
   flutter build windows
   flutter build linux
   ```

## 🧱 Database Schema

| Column      | Type    | Description                      |
| ----------- | ------- | -------------------------------- |
| id          | INTEGER | Primary key                      |
| imageName   | TEXT    | Wallpaper name                   |
| imagePath   | TEXT    | Local file path                  |
| category    | TEXT    | Wallpaper category               |
| isFavourite | INTEGER | 0 or 1                           |
| isActive    | INTEGER | Marks currently active wallpaper |
| description | TEXT    | Optional description             |
| tags        | TEXT    | Comma-separated tags             |
| previewPath | TEXT    | Optional preview image path      |

## 💡 Notes

* All fonts used **Poppins** and **Clash Display** (make sure it’s declared in `pubspec.yaml`).
* Desktop support requires `sqflite_common_ffi` initialization.
* UI is not completely responsive may crash with some layouts.

Video Display Link
https://drive.google.com/file/d/1EW3j-qSpXxOrSOQ87YZngwu7NXt9q2vs/view?usp=drive_link

Download Release .exe file
https://drive.google.com/drive/folders/1PT5QOg4_jmwck9raNfhqwuoHbWl1b7B-?usp=drive_link
