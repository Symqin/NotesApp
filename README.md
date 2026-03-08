# 📝 Notes App

Aplikasi catatan sederhana yang dibuat menggunakan **Flutter** dengan **Isar Database** sebagai penyimpanan lokal.

## ✨ Fitur

- **CRUD Notes** — Buat, baca, edit, dan hapus catatan
- **Title & Content** — Setiap catatan memiliki judul dan isi terpisah
- **Auto-Save** — Catatan otomatis tersimpan saat kembali ke halaman utama
- **Dark / Light Mode** — Tema gelap dan terang, bisa diubah di Settings
- **Persistent Storage** — Data catatan tersimpan secara lokal menggunakan Isar
- **Material 3 UI** — Desain modern dengan Material Design 3
- **Custom App Icon** — Ikon launcher kustom dengan adaptive icon untuk Android 8.0+

## 🛠️ Tech Stack

| Teknologi | Kegunaan |
|-----------|----------|
| **Flutter** | Framework UI |
| **Isar** | Database lokal NoSQL |
| **Provider** | State management |
| **SharedPreferences** | Penyimpanan preferensi tema |
| **Material 3** | Design system |
| **flutter_launcher_icons** | Generator ikon launcher kustom |

## 📂 Struktur Proyek

```
assets/
└── logo/
    ├── notesbig.png             # Ikon launcher standar
    └── notesmall.png            # Foreground adaptive icon
lib/
├── main.dart                    # Entry point, MultiProvider setup
├── models/
│   ├── note.dart                # Model Note (title, content, updatedAt)
│   ├── note.g.dart              # Generated Isar schema
│   ├── note_database.dart       # CRUD operations dengan Isar
│   └── theme_provider.dart      # Provider untuk dark/light mode
└── pages/
    ├── notes_page.dart          # Halaman utama daftar catatan
    ├── note_detail_page.dart    # Halaman editor catatan
    └── settings_page.dart       # Halaman pengaturan tema
```

## 🚀 Cara Menjalankan

### Prasyarat
- Flutter SDK ^3.10.8
- Android Studio / VS Code
- Emulator atau device fisik

### Instalasi

```bash
# Clone repository
git clone <repository-url>
cd notes

# Install dependencies
flutter pub get

# Generate Isar schema
flutter pub run build_runner build --delete-conflicting-outputs

# Jalankan aplikasi
flutter run
```

## 📱 Halaman Aplikasi

### 1. Notes Page
Halaman utama menampilkan daftar catatan dalam bentuk kartu. Setiap kartu menampilkan judul, preview isi, dan waktu terakhir diedit. Terdapat **drawer menu** (☰) untuk navigasi ke Notes dan Settings.

### 2. Note Detail Page
Halaman editor full-screen dengan field judul dan isi terpisah. Mendukung pembuatan catatan baru dan pengeditan catatan yang sudah ada. Catatan otomatis tersimpan saat menekan tombol back.

### 3. Settings Page
Halaman pengaturan dengan toggle **Dark Mode / Light Mode**. Preferensi tema disimpan secara permanen menggunakan SharedPreferences.

## 📄 License

Project ini dibuat untuk keperluan pembelajaran Flutter.
