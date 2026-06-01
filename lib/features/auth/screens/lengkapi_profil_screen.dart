import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/core.dart';
import '../services/auth_service.dart';

class LengkapiProfilScreen extends StatelessWidget {
  const LengkapiProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lengkapi Profil'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.assignment_ind_rounded, size: 80, color: AppColors.warning),
              const SizedBox(height: 24),
              Text(
                'Lengkapi Profil Anda',
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Halaman ini akan diimplementasikan nanti untuk melengkapi data profil seperti avatar dan detail lainnya.',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // TODO: Save profile data
                  context.go(AppConstants.routeHome);
                },
                child: const Text('Lewati Sementara'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  await AuthService().signOut();
                },
                child: const Text('Logout', style: TextStyle(color: AppColors.error)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
