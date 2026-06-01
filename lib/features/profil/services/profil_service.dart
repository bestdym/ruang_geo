import '../../../core/services/supabase_service.dart';
import '../models/profile_model.dart';

class ProfilService {
  /// Mengambil data profil dari Supabase berdasarkan userId
  Future<ProfileModel?> getProfile(String userId) async {
    try {
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return ProfileModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Menyimpan (upsert) data profil ke Supabase
  Future<bool> updateProfile(ProfileModel profile) async {
    try {
      await supabase.from('profiles').upsert(profile.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Mengecek apakah profil sudah lengkap (full_name, username, kelas, sekolah)
  Future<bool> isProfileComplete(String userId) async {
    final profile = await getProfile(userId);
    if (profile == null) return false;
    return profile.isProfileComplete;
  }

  /// Mengecek ketersediaan username (true = tersedia)
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final data = await supabase
          .from('profiles')
          .select('id')
          .eq('username', username);
      return (data as List).isEmpty;
    } catch (e) {
      return false;
    }
  }
}
