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

/// Halaman login sederhana untuk pemula
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // Konstruktor LoginScreen

  @override
  State<LoginScreen> createState() => _LoginScreenState(); // Membuat state halaman login
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController(); // Controller input email
  final TextEditingController _passwordController = TextEditingController(); // Controller input password

  bool _isLoading = false; // Status sedang proses login
  String? _errorMessage; // Menyimpan pesan error jika gagal login

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Tampilkan loading
      _errorMessage = null; // Kosongkan error lama
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(), // Ambil email dan hapus spasi
        password: _passwordController.text.trim(), // Ambil password dan hapus spasi
      );
      // Jika berhasil, AuthWrapper otomatis pindah ke UserInfoScreen
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Login gagal'; // Tampilkan pesan error Firebase
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Matikan loading
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose(); // Hapus controller email saat keluar halaman
    _passwordController.dispose(); // Hapus controller password saat keluar halaman
    super.dispose(); // Panggil dispose bawaan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            TextField(
              controller: _emailController, // Hubungkan ke controller email
              decoration: const InputDecoration(
                labelText: 'Email', 
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12), 
            TextField(
              controller: _passwordController, // Hubungkan ke controller password
              obscureText: true, // Sembunyikan huruf password
              decoration: const InputDecoration(
                labelText: 'Password', 
                border: OutlineInputBorder(), 
              ),
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null) ...[
              Text(
                _errorMessage!, // Tampilkan pesan error jika ada
                style: const TextStyle(color: Colors.red), 
                textAlign: TextAlign.center, 
              ),
              const SizedBox(height: 12), 
            ],
            _isLoading
                ? const CircularProgressIndicator() // Tampilkan loading saat login
                : ElevatedButton(
                    onPressed: _login, // Jalankan fungsi _login saat diklik
                    child: const Text('Login'), // Tulisan tombol
                  ),
          ],
        ),
      ),
    );
  }
}