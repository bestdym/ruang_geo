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
    return await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
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
