# Setup Environment Variables untuk API Key

## Langkah-langkah Setup:

### 1. Install Dependencies
Pastikan Anda sudah menjalankan:
```bash
flutter pub get
```

### 2. File `.env` sudah ada di root project
File `.env` berisi:
```
TMDB_API_KEY=API_KEY_ANDA
```

### 3. Ganti API Key Anda
Edit file `.env` dan ganti `API_KEY_ANDA` dengan API key aktual dari [The Movie Database (TMDb)](https://www.themoviedb.org/settings/api)

**Contoh:**
```
TMDB_API_KEY=abc123def456ghi789
```

### 4. File `.gitignore` sudah updated
File `.env` sudah di-add ke `.gitignore`, jadi tidak akan ter-commit ke repository

### 5. File `.env.example` tersedia
Gunakan `.env.example` sebagai template untuk dokumentasi:
```bash
cp .env.example .env
```

## Cara Kerja di Kode:

### `main.dart`
```dart
void main() async {
  // Load environment variables dari .env
  await dotenv.load();
  runApp(const MyApp());
}
```

### `movie_page.dart`
```dart
late final String apiKey = dotenv.env['TMDB_API_KEY'] ?? 'API_KEY_ANDA';
```

## Security Tips:
✅ API Key disimpan di `.env` (tidak di-commit)
✅ File `.env` di-ignore oleh git
✅ Gunakan `.env.example` untuk dokumentasi
✅ Jangan pernah commit file `.env` yang berisi API key real

## Troubleshooting:
- Jika API key tidak terbaca, pastikan file `.env` ada di root project (d:\tmdb\.env)
- Setelah mengubah `.env`, lakukan `flutter clean` kemudian `flutter pub get`
- Pastikan format file `.env` benar (tidak ada spasi sebelum/sesudah `=`)
