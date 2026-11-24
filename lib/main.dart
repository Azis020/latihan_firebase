import 'package:flutter/material.dart'; // Mengimpor widget UI Flutter
import 'package:firebase_core/firebase_core.dart'; // Mengimpor core Firebase
import 'package:firebase_auth/firebase_auth.dart'; // Mengimpor layanan login Firebase

import 'firebase_options.dart'; // Mengimpor konfigurasi hasil flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Menyiapkan Flutter sebelum proses async
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Menyalakan Firebase sesuai platform
  );
  runApp(const MyApp()); // Menjalankan aplikasi
}
