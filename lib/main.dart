import 'package:flutter/material.dart'; // Mengimpor widget UI Flutter
import 'package:firebase_core/firebase_core.dart'; // Mengimpor core Firebase
import 'package:firebase_auth/firebase_auth.dart'; // Mengimpor layanan login Firebase

import 'firebase_options.dart'; // Mengimpor konfigurasi hasil flutterfire configure

void main() async {

  WidgetsFlutterBinding.ensureInitialized(); // Menyiapkan Flutter sebelum proses async
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Menyalakan Firebase sesuai platform
  );
  runApp(const MyApp()); // Menjalankan aplikasi
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Konstruktor MyApp

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth Simple', // Judul aplikasi
      home: const AuthWrapper(), // Halaman awal mengecek status login
    );
  }
}

/// Mengecek apakah user sudah login atau belum
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key}); // Konstruktor AuthWrapper

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Memantau status login user
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()), // Tampilan loading awal
          );
        }
        if (snapshot.hasData) {
          return UserInfoScreen(user: snapshot.data!); // Jika sudah login, buka halaman user
        }
        return const LoginScreen(); // Jika belum login, buka halaman login
      },
    );
  }
}