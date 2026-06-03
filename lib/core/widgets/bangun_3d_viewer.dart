import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class Bangun3DViewer extends StatefulWidget {
  final String bangunId;
  final double size;

  const Bangun3DViewer({
    super.key,
    required this.bangunId,
    this.size = 100,
  });

  @override
  State<Bangun3DViewer> createState() => _Bangun3DViewerState();
}

class _Bangun3DViewerState extends State<Bangun3DViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Timer? _resumeTimer;

  // Nilai sudut rotasi dan zoom interaktif
  double _dragAngleX = math.pi / 8; // Kemiringan awal (tilt down)
  double _dragAngleY = 0.0;
  double _zoom = 1.0;

  // Variabel penampung saat gesture dimulai
  double _baseAngleX = 0.0;
  double _baseAngleY = 0.0;
  double _baseZoom = 1.0;
  Offset _startFocalPoint = Offset.zero;
  bool _isInteracting = false;

  @override
  void initState() {
    super.initState();
    // Gunakan controller untuk memicu auto-rotate jika sedang tidak berinteraksi
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );
    _controller.addListener(() {
      if (!_isInteracting) {
        setState(() {
          _dragAngleY += 0.012; // Rotasi otomatis yang halus
          if (_dragAngleY > 2 * math.pi) {
            _dragAngleY -= 2 * math.pi;
          }
        });
      }
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    _resumeTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _resumeTimer?.cancel();
        setState(() {
          _isInteracting = true;
          _baseAngleX = _dragAngleX;
          _baseAngleY = _dragAngleY;
          _baseZoom = _zoom;
          _startFocalPoint = details.localFocalPoint;
        });
      },
      onScaleUpdate: (details) {
        setState(() {
          final Offset delta = details.localFocalPoint - _startFocalPoint;
          // Sensitivitas pergeseran rotasi
          const double sensitivity = 0.007;
          
          _dragAngleY = _baseAngleY - delta.dx * sensitivity;
          _dragAngleX = (_baseAngleX + delta.dy * sensitivity)
              .clamp(-math.pi / 2.2, math.pi / 2.2); // Batasi agar tidak berputar terbalik vertikal

          // Zoom/Pinch
          if (details.scale != 1.0) {
            _zoom = (_baseZoom * details.scale).clamp(0.5, 2.5);
          }
        });
      },
      onScaleEnd: (details) {
        _resumeTimer?.cancel();
        // Lanjutkan putar otomatis setelah 3 detik tidak disentuh
        _resumeTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isInteracting = false;
            });
          }
        });
      },
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _Solid3DPainter(
          bangunId: widget.bangunId,
          angleY: _dragAngleY,
          angleX: _dragAngleX,
          zoom: _zoom,
        ),
      ),
    );
  }
}

class _Face {
  final List<List<double>> vertices;
  _Face(this.vertices);
}

class _Solid3DPainter extends CustomPainter {
  final String bangunId;
  final double angleX;
  final double angleY;
  final double zoom;

  _Solid3DPainter({
    required this.bangunId,
    required this.angleX,
    required this.angleY,
    required this.zoom,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final scale = (size.width / 2.5) * zoom;

    List<_Face> faces = [];
    Color baseColor = Colors.blue;

    switch (bangunId) {
      case 'br_kubus':
        baseColor = Colors.blue;
        faces = _buildBox(1, 1, 1);
        break;
      case 'br_balok':
        baseColor = Colors.purple;
        faces = _buildBox(1.5, 0.8, 0.8);
        break;
      case 'br_prisma_segitiga':
        baseColor = Colors.green;
        faces = _buildPrisma();
        break;
      case 'br_limas_segiempat':
        baseColor = Colors.orange;
        faces = _buildLimas();
        break;
      case 'br_tabung':
        baseColor = Colors.cyan;
        faces = _buildTabung();
        break;
      case 'br_kerucut':
        baseColor = Colors.pink;
        faces = _buildKerucut();
        break;
      case 'br_bola':
        baseColor = Colors.indigo;
        faces = _buildBola();
        break;
      default:
        baseColor = Colors.grey;
        faces = _buildBox(1, 1, 1);
    }

    // Light direction
    final lightDir = [0.0, -1.0, -1.0];
    // Normalize light
    final lightLen = math.sqrt(lightDir[0]*lightDir[0] + lightDir[1]*lightDir[1] + lightDir[2]*lightDir[2]);
    lightDir[0] /= lightLen;
    lightDir[1] /= lightLen;
    lightDir[2] /= lightLen;

    // Projected faces with z-index
    List<Map<String, dynamic>> projectedFaces = [];

    for (var face in faces) {
      List<List<double>> transformedVertices = [];
      for (var v in face.vertices) {
        double x = v[0];
        double y = v[1];
        double z = v[2];

        // Rotate Y
        double x2 = x * math.cos(angleY) - z * math.sin(angleY);
        double z2 = x * math.sin(angleY) + z * math.cos(angleY);

        // Rotate X
        double y2 = y * math.cos(angleX) - z2 * math.sin(angleX);
        double z3 = y * math.sin(angleX) + z2 * math.cos(angleX);

        transformedVertices.add([x2, y2, z3]);
      }

      // Calculate Normal
      final v0 = transformedVertices[0];
      final v1 = transformedVertices[1];
      final v2 = transformedVertices[2];
      
      final u = [v1[0] - v0[0], v1[1] - v0[1], v1[2] - v0[2]];
      final w = [v2[0] - v0[0], v2[1] - v0[1], v2[2] - v0[2]];
      
      double nx = u[1] * w[2] - u[2] * w[1];
      double ny = u[2] * w[0] - u[0] * w[2];
      double nz = u[0] * w[1] - u[1] * w[0];
      
      final nLen = math.sqrt(nx*nx + ny*ny + nz*nz);
      if (nLen == 0) continue;
      nx /= nLen;
      ny /= nLen;
      nz /= nLen;

      // Backface culling (jika normal menghadap membelakangi kamera / nz > 0)
      if (nz > 0 && bangunId != 'br_bola') continue; // Bola is drawn as a whole, simple culling

      // Shading based on dot product with light (normal sudah outward)
      double dot = (nx * lightDir[0] + ny * lightDir[1] + nz * lightDir[2]);
      // Ambient + Diffuse
      double intensity = 0.4 + 0.6 * math.max(0.0, dot);
      
      // Average Z for sorting
      double avgZ = 0;
      List<Offset> pts = [];
      for (var v in transformedVertices) {
        avgZ += v[2];
        double factor = 4 / (4 + v[2]); // Perspective
        pts.add(Offset(v[0] * factor * scale + center.dx, v[1] * factor * scale + center.dy));
      }
      avgZ /= transformedVertices.length;

      // Color adjustment
      int r = (baseColor.red * intensity).clamp(0, 255).toInt();
      int g = (baseColor.green * intensity).clamp(0, 255).toInt();
      int b = (baseColor.blue * intensity).clamp(0, 255).toInt();
      Color faceColor = Color.fromARGB(255, r, g, b);

      projectedFaces.add({
        'z': avgZ,
        'pts': pts,
        'color': faceColor,
        'intensity': intensity,
      });
    }

    // Sort by Z (painter's algorithm)
    projectedFaces.sort((a, b) => b['z'].compareTo(a['z']));

    // Paint faces
    for (var pf in projectedFaces) {
      final path = Path();
      List<Offset> pts = pf['pts'];
      path.moveTo(pts[0].dx, pts[0].dy);
      for (int i = 1; i < pts.length; i++) {
        path.lineTo(pts[i].dx, pts[i].dy);
      }
      path.close();

      canvas.drawPath(
        path,
        Paint()
          ..color = pf['color']
          ..style = PaintingStyle.fill,
      );
      
      // Draw edges
      canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white.withAlpha(50)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0,
      );
    }
  }

  List<_Face> _buildBox(double w, double h, double d) {
    List<List<double>> v = [
      [-w, -h, -d], [w, -h, -d], [w, h, -d], [-w, h, -d],
      [-w, -h, d], [w, -h, d], [w, h, d], [-w, h, d]
    ];
    return [
      _Face([v[0], v[1], v[2], v[3]].reversed.toList()), // Front
      _Face([v[5], v[4], v[7], v[6]].reversed.toList()), // Back
      _Face([v[4], v[0], v[3], v[7]].reversed.toList()), // Left
      _Face([v[1], v[5], v[6], v[2]].reversed.toList()), // Right
      _Face([v[4], v[5], v[1], v[0]].reversed.toList()), // Top
      _Face([v[3], v[2], v[6], v[7]].reversed.toList()), // Bottom
    ];
  }

  List<_Face> _buildPrisma() {
    List<List<double>> v = [
      [0, -1, -1], [-1, 1, -1], [1, 1, -1],
      [0, -1, 1], [-1, 1, 1], [1, 1, 1]
    ];
    return [
      _Face([v[0], v[2], v[1]].reversed.toList()), // Front triangle
      _Face([v[3], v[4], v[5]].reversed.toList()), // Back triangle
      _Face([v[0], v[1], v[4], v[3]].reversed.toList()), // Left side
      _Face([v[0], v[3], v[5], v[2]].reversed.toList()), // Right side
      _Face([v[1], v[2], v[5], v[4]].reversed.toList()), // Bottom
    ];
  }

  List<_Face> _buildLimas() {
    List<List<double>> v = [
      [-1, 1, -1], [1, 1, -1], [1, 1, 1], [-1, 1, 1], // Base
      [0, -1, 0] // Apex
    ];
    return [
      _Face([v[0], v[3], v[2], v[1]].reversed.toList()), // Base
      _Face([v[0], v[1], v[4]].reversed.toList()), // Front
      _Face([v[1], v[2], v[4]].reversed.toList()), // Right
      _Face([v[2], v[3], v[4]].reversed.toList()), // Back
      _Face([v[3], v[0], v[4]].reversed.toList()), // Left
    ];
  }

  List<_Face> _buildTabung() {
    List<_Face> faces = [];
    int segments = 24;
    for (int i = 0; i < segments; i++) {
      double t1 = (i / segments) * 2 * math.pi;
      double t2 = ((i + 1) / segments) * 2 * math.pi;
      
      double x1 = math.cos(t1), z1 = math.sin(t1);
      double x2 = math.cos(t2), z2 = math.sin(t2);
      
      // Side
      faces.add(_Face([
        [x1, -1, z1], [x1, 1, z1], [x2, 1, z2], [x2, -1, z2]
      ]));
      // Top circle
      faces.add(_Face([[0, -1, 0], [x1, -1, z1], [x2, -1, z2]]));
      // Bottom circle
      faces.add(_Face([[0, 1, 0], [x2, 1, z2], [x1, 1, z1]]));
    }
    return faces;
  }

  List<_Face> _buildKerucut() {
    List<_Face> faces = [];
    int segments = 24;
    for (int i = 0; i < segments; i++) {
      double t1 = (i / segments) * 2 * math.pi;
      double t2 = ((i + 1) / segments) * 2 * math.pi;
      
      double x1 = math.cos(t1), z1 = math.sin(t1);
      double x2 = math.cos(t2), z2 = math.sin(t2);
      
      // Side
      faces.add(_Face([[0, -1, 0], [x1, 1, z1], [x2, 1, z2]]));
      // Bottom
      faces.add(_Face([[0, 1, 0], [x2, 1, z2], [x1, 1, z1]]));
    }
    return faces;
  }

  List<_Face> _buildBola() {
    List<_Face> faces = [];
    int lat = 16;
    int lon = 24;
    for (int i = 0; i < lat; i++) {
      double theta1 = (i / lat) * math.pi;
      double theta2 = ((i + 1) / lat) * math.pi;
      
      for (int j = 0; j < lon; j++) {
        double phi1 = (j / lon) * 2 * math.pi;
        double phi2 = ((j + 1) / lon) * 2 * math.pi;
        
        List<double> v1 = [math.sin(theta1) * math.cos(phi1), math.cos(theta1), math.sin(theta1) * math.sin(phi1)];
        List<double> v2 = [math.sin(theta2) * math.cos(phi1), math.cos(theta2), math.sin(theta2) * math.sin(phi1)];
        List<double> v3 = [math.sin(theta2) * math.cos(phi2), math.cos(theta2), math.sin(theta2) * math.sin(phi2)];
        List<double> v4 = [math.sin(theta1) * math.cos(phi2), math.cos(theta1), math.sin(theta1) * math.sin(phi2)];
        
        faces.add(_Face([v1, v2, v3, v4].reversed.toList()));
      }
    }
    return faces;
  }

  @override
  bool shouldRepaint(covariant _Solid3DPainter oldDelegate) {
    return oldDelegate.angleY != angleY ||
        oldDelegate.angleX != angleX ||
        oldDelegate.zoom != zoom ||
        oldDelegate.bangunId != bangunId;
  }
}
