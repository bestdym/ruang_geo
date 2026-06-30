import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ruang_geo/features/bangun_ruang/presentation/widgets/model_viewer_widget.dart';

class VrModeScreen extends StatefulWidget {
  final String bangunId;

  const VrModeScreen({
    super.key,
    required this.bangunId,
  });

  @override
  State<VrModeScreen> createState() => _VrModeScreenState();
}

class _VrModeScreenState extends State<VrModeScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Row(
            children: [
              // Left Eye
              Expanded(
                child: _buildEyeView(),
              ),
              // Divider for glasses center
              Container(
                width: 4,
                color: Colors.black,
              ),
              // Right Eye
              Expanded(
                child: _buildEyeView(),
              ),
            ],
          ),
          // Back button
          Positioned(
            top: 20,
            left: 20,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEyeView() {
    return IgnorePointer(
      ignoring: true,
      child: RGModelViewer(
        bangunId: widget.bangunId,
        autoRotate: true,
        cameraControls: false,
        backgroundColor: Colors.black,
        shadowIntensity: 1.0,
        fallbackSize: 140,
      ),
    );
  }
}
