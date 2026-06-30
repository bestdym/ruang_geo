# ⬟ Ruang-Geo

**Ruang-Geo** adalah Aplikasi Edukasi Geometri interaktif berbasis *Augmented Reality (AR)* dan visualisasi 3D yang dirancang khusus untuk mempermudah pemahaman konsep **Bangun Ruang** dan **Bangun Datar**. Aplikasi ini dibangun menggunakan **Flutter** dan berbagai teknologi modern untuk memberikan pengalaman belajar yang imersif, menyenangkan, dan mudah dipahami.

## ✨ Fitur Utama

*   **📐 Visualisasi 3D Interaktif:** Menampilkan berbagai macam bangun datar dan bangun ruang dalam bentuk 3D yang dapat diputar, di-zoom, dan dieksplorasi.
*   **🌐 Augmented Reality (AR):** Memproyeksikan bangun ruang ke dunia nyata menggunakan kamera perangkat, membantu membayangkan bentuk dan ukurannya secara riil.
*   **📖 Materi Edukasi Komprehensif:** Menyediakan rumus-rumus lengkap (luas, keliling, volume, luas permukaan) yang disajikan secara rapi menggunakan render rumus matematika.
*   **🎮 Kuis Interaktif:** Menguji pemahaman pengguna dengan kuis-kuis menarik beserta penyimpanan progres belajar secara lokal.
*   **✨ UI/UX Modern & Animasi Mulus:** Antarmuka ramah pengguna (*user-friendly*) dengan animasi memukau menggunakan Flutter Animate, Lottie, dan Rive.

## 🛠️ Teknologi yang Digunakan

Proyek ini dibangun menggunakan *stack* dan package unggulan dari ekosistem Flutter:

*   **Framework Utama:** [Flutter](https://flutter.dev/) (SDK ^3.11.5)
*   **State Management:** [Flutter BLoC](https://pub.dev/packages/flutter_bloc) & Equatable
*   **Routing:** [GoRouter](https://pub.dev/packages/go_router)
*   **Visualisasi 3D & AR:** 
    *   [model_viewer_plus](https://pub.dev/packages/model_viewer_plus)
    *   [ar_flutter_plugin](https://pub.dev/packages/ar_flutter_plugin)
*   **Animasi & UI Utils:** 
    *   [flutter_animate](https://pub.dev/packages/flutter_animate) & [Rive](https://rive.app/)
    *   `lottie`, `shimmer`, `cached_network_image`, `google_fonts`
*   **Penyimpanan Lokal:** [Hive](https://pub.dev/packages/hive_flutter) & Shared Preferences
*   **Lainnya:** `flutter_math_fork` (untuk merender rumus), `permission_handler`, `camera`.

## 🚀 Cara Menjalankan Proyek (Getting Started)

### Prasyarat

Pastikan perangkat Anda sudah terinstal:
*   [Flutter SDK](https://docs.flutter.dev/get-started/install)
*   Android Studio atau Visual Studio Code dengan ekstensi Flutter/Dart
*   Perangkat fisik Android/iOS atau Emulator (Dianjurkan menggunakan perangkat fisik untuk menggunakan fitur AR)

### Langkah-langkah Instalasi

1. **Clone repositori ini (jika menggunakan git):**
   ```bash
   git clone <URL_REPOSITORY>
   cd ruang_geo
   ```

2. **Unduh dependensi (packages):**
   ```bash
   flutter pub get
   ```

3. **Generate file (untuk Hive & dependensi lainnya):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```
   > **Catatan:** Fitur *Augmented Reality* (AR) dan Kamera biasanya memerlukan izin (permissions) spesifik dan dukungan ARCore (Android) / ARKit (iOS). Pastikan untuk melakukan pengujian di perangkat asli (*real device*).

## 📂 Struktur Folder Utama

Proyek ini menerapkan arsitektur fitur-sentris untuk memastikan kode terstruktur dan mudah dipelihara:

```text
lib/
├── core/         # Komponen inti (utils, themes, constants, network)
├── features/     # Modul fitur aplikasi (home, ruang, datar, kuis, ar_view)
├── models/       # Data models dan entities
├── routes/       # Konfigurasi navigasi menggunakan GoRouter
└── main.dart     # Entry point aplikasi
```

---
*Dibuat untuk memajukan cara belajar matematika dan geometri menggunakan teknologi terkini 🇮🇩.
