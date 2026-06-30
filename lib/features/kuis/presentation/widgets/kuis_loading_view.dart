import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ruang_geo/core/core.dart';

class KuisLoadingView extends StatelessWidget {
  const KuisLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarCustom(title: 'Memuat Soal...'),
      body: Shimmer.fromColors(
        baseColor: AppColors.surfaceVariant,
        highlightColor: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: 24, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
              const SizedBox(height: 12),
              Container(height: 120, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
              const SizedBox(height: 32),
              ...List.generate(4, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(height: 64, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
