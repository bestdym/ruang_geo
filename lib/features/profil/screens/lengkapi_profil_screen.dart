import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/core.dart';
import '../../../core/services/supabase_service.dart';
import '../models/profile_model.dart';
import '../services/profil_service.dart';

class LengkapiProfilScreen extends StatefulWidget {
  const LengkapiProfilScreen({super.key});

  @override
  State<LengkapiProfilScreen> createState() => _LengkapiProfilScreenState();
}

class _LengkapiProfilScreenState extends State<LengkapiProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _sekolahController = TextEditingController();
  final _profilService = ProfilService();

  String? _selectedKelas;
  bool _isSaving = false;
  bool _isCheckingUsername = false;
  String? _usernameError;

  final List<String> _kelasList = ['VII', 'VIII', 'IX', 'X', 'XI', 'XII'];

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }

  Future<void> _loadExistingProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    final profile = await _profilService.getProfile(userId);
    if (profile != null && mounted) {
      setState(() {
        _namaController.text = profile.fullName ?? '';
        _usernameController.text = profile.username ?? '';
        _sekolahController.text = profile.sekolah ?? '';
        _selectedKelas = profile.kelas;
      });
    }
  }

  Future<void> _checkUsername(String username) async {
    if (username.length < 3) return;
    setState(() {
      _isCheckingUsername = true;
      _usernameError = null;
    });
    final currentUserId = supabase.auth.currentUser?.id;
    // Ambil profil sendiri untuk skip check jika username tidak berubah
    final existing = await _profilService.getProfile(currentUserId ?? '');
    if (existing?.username == username) {
      setState(() => _isCheckingUsername = false);
      return;
    }
    final available = await _profilService.isUsernameAvailable(username);
    setState(() {
      _isCheckingUsername = false;
      _usernameError = available ? null : 'Username sudah digunakan';
    });
  }

  Future<void> _simpanProfil() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_usernameError != null) return;
    if (_selectedKelas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih kelas terlebih dahulu')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      setState(() => _isSaving = false);
      return;
    }

    final profile = ProfileModel(
      id: userId,
      fullName: _namaController.text.trim(),
      username: _usernameController.text.trim(),
      kelas: _selectedKelas,
      sekolah: _sekolahController.text.trim(),
    );

    final success = await _profilService.updateProfile(profile);
    setState(() => _isSaving = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil disimpan! 🎉'),
            backgroundColor: AppColors.success,
          ),
        );
        context.go(AppConstants.routeHome);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan profil. Coba lagi.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go(AppConstants.routeHome),
        ),
        title: Text('Lengkapi Profil', style: AppTypography.titleMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ─── Header ──────────────────────────────────────────────────
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded, size: 44, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Siapa kamu?',
                    style: AppTypography.headlineSmall.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    'Isi profil untuk melanjutkan belajar',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: 32),

                // ─── Nama Lengkap ─────────────────────────────────────────────
                Text('Nama Lengkap', style: AppTypography.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan nama lengkap',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),

                // ─── Username ─────────────────────────────────────────────────
                Text('Username', style: AppTypography.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: 'contoh: budi123',
                    prefixIcon: const Icon(Icons.alternate_email),
                    border: const OutlineInputBorder(),
                    suffixIcon: _isCheckingUsername
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                          )
                        : _usernameError == null && _usernameController.text.length >= 3
                            ? const Icon(Icons.check_circle, color: AppColors.success)
                            : null,
                    errorText: _usernameError,
                  ),
                  onChanged: (v) {
                    if (v.length >= 3) {
                      Future.delayed(const Duration(milliseconds: 600), () {
                        if (_usernameController.text == v) _checkUsername(v);
                      });
                    }
                  },
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Username tidak boleh kosong';
                    if (v.length < 3) return 'Username minimal 3 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ─── Kelas ────────────────────────────────────────────────────
                Text('Kelas', style: AppTypography.labelLarge),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedKelas,
                  hint: const Text('Pilih kelas'),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.school_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: _kelasList
                      .map((k) => DropdownMenuItem(value: k, child: Text('Kelas $k')))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedKelas = v),
                  validator: (v) => v == null ? 'Pilih kelas Anda' : null,
                ),
                const SizedBox(height: 16),

                // ─── Sekolah ──────────────────────────────────────────────────
                Text('Sekolah', style: AppTypography.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _sekolahController,
                  decoration: const InputDecoration(
                    hintText: 'Nama sekolah Anda',
                    prefixIcon: Icon(Icons.location_city_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama sekolah tidak boleh kosong' : null,
                ),
                const SizedBox(height: 32),

                // ─── Tombol Simpan ────────────────────────────────────────────
                ElevatedButton(
                  onPressed: _isSaving ? null : _simpanProfil,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'Simpan Profil',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.go(AppConstants.routeHome),
                  child: Text(
                    'Lewati dulu',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
