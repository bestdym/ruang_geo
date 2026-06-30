import 'package:flutter/material.dart';

class KuisGambar extends StatelessWidget {
  const KuisGambar({super.key, required this.url});
  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url?.isEmpty ?? true) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(url!, fit: BoxFit.cover),
      ),
    );
  }
}
