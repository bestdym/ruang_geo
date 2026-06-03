import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';

class AuthService {
  /// Sign in dengan email dan password
  Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Registrasi dengan email, password, dan nama lengkap
  Future<AuthResponse> signUp(String email, String password, String fullName) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );

    // Jika registrasi berhasil, manual buatkan data di tabel 'profiles'
    final user = response.user;
    if (user != null) {
      try {
        await supabase.from('profiles').insert({
          'id': user.id,
          'full_name': fullName,
          'username': email.split('@')[0], // Buat username default dari email
          'is_profile_complete': false,
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        print('Peringatan: Gagal insert ke tabel profiles (mungkin karena RLS): $e');
      }
    }

    return response;
  }

  /// Sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  /// Mengambil user yang saat ini sedang login (jika ada)
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  /// Mengecek apakah user sedang login
  bool isLoggedIn() {
    return supabase.auth.currentUser != null;
  }
}
