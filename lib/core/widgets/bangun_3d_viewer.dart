import 'dart:math' as math;
import 'package:flutter/material.dart';

class Bangun3DViewer extends StatefulWidget {
  final String bangunId;
  final double size;
  final Color color;

  const Bangun3DViewer({
    super.key,
    required this.bangunId,
    this.size = 100,
    this.color = Colors.white,
  });

  @override
  State<Bangun3DViewer> createState() => _Bangun3DViewerState();
}

class _Bangun3DViewerState extends State<Bangun3DViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _Bangun3DPainter(
            bangunId: widget.bangunId,
            angleY: _controller.value * 2 * math.pi,
            angleX: math.pi / 6, // Tilt slightly
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _Bangun3DPainter extends CustomPainter {
  final String bangunId;
  final double angleX;
  final double angleY;
  final Color color;

  _Bangun3DPainter({
    required this.bangunId,
    required this.angleX,
    required this.angleY,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 2.5;

    // List of 3D vertices
    List<List<double>> vertices = [];
    // List of edges connecting vertices (indices)
    List<List<int>> edges = [];

    switch (bangunId) {
      case 'br_kubus':
        vertices = [
          [-1, -1, -1], [1, -1, -1], [1, 1, -1], [-1, 1, -1],
          [-1, -1, 1], [1, -1, 1], [1, 1, 1], [-1, 1, 1]
        ];
        edges = [
          [0, 1], [1, 2], [2, 3], [3, 0], // Back
          [4, 5], [5, 6], [6, 7], [7, 4], // Front
          [0, 4], [1, 5], [2, 6], [3, 7]  // Connectors
        ];
        break;
      case 'br_balok':
        vertices = [
          [-1.5, -1, -1], [1.5, -1, -1], [1.5, 1, -1], [-1.5, 1, -1],
          [-1.5, -1, 1], [1.5, -1, 1], [1.5, 1, 1], [-1.5, 1, 1]
        ];
        edges = [
          [0, 1], [1, 2], [2, 3], [3, 0],
          [4, 5], [5, 6], [6, 7], [7, 4],
          [0, 4], [1, 5], [2, 6], [3, 7]
        ];
        break;
      case 'br_prisma_segitiga':
        vertices = [
          [0, -1.2, -1], [-1, 1.2, -1], [1, 1.2, -1], // Back triangle
          [0, -1.2, 1], [-1, 1.2, 1], [1, 1.2, 1]     // Front triangle
        ];
        edges = [
          [0, 1], [1, 2], [2, 0], // Back
          [3, 4], [4, 5], [5, 3], // Front
          [0, 3], [1, 4], [2, 5]  // Connectors
        ];
        break;
      case 'br_limas_segiempat':
        vertices = [
          [-1, 1, -1], [1, 1, -1], [1, 1, 1], [-1, 1, 1], // Base
          [0, -1.5, 0] // Apex
        ];
        edges = [
          [0, 1], [1, 2], [2, 3], [3, 0], // Base
          [0, 4], [1, 4], [2, 4], [3, 4]  // Sides
        ];
        break;
      case 'br_tabung':
        // approximate cylinder with a prism of many sides
        int segments = 16;
        for (int i = 0; i < segments; i++) {
          double theta = (i / segments) * 2 * math.pi;
          double x = math.cos(theta);
          double z = math.sin(theta);
          vertices.add([x, -1.2, z]); // Top
          vertices.add([x, 1.2, z]);  // Bottom
        }
        for (int i = 0; i < segments; i++) {
          int next = (i + 1) % segments;
          edges.add([i * 2, next * 2]); // Top circle
          edges.add([i * 2 + 1, next * 2 + 1]); // Bottom circle
          if (i % 4 == 0) {
            edges.add([i * 2, i * 2 + 1]); // Vertical lines
          }
        }
        break;
      case 'br_kerucut':
        int cSegments = 16;
        for (int i = 0; i < cSegments; i++) {
          double theta = (i / cSegments) * 2 * math.pi;
          double x = math.cos(theta);
          double z = math.sin(theta);
          vertices.add([x, 1.2, z]); // Base
        }
        vertices.add([0, -1.2, 0]); // Apex
        int apexIdx = vertices.length - 1;
        for (int i = 0; i < cSegments; i++) {
          int next = (i + 1) % cSegments;
          edges.add([i, next]); // Base circle
          if (i % 4 == 0) {
            edges.add([i, apexIdx]); // Lines to apex
          }
        }
        break;
      case 'br_bola':
        int bSegments = 12;
        // draw rings
        for (int j = 0; j <= bSegments; j++) {
          double phi = (j / bSegments) * math.pi; // 0 to pi
          double y = -math.cos(phi);
          double r = math.sin(phi);
          for (int i = 0; i < bSegments; i++) {
            double theta = (i / bSegments) * 2 * math.pi;
            double x = r * math.cos(theta);
            double z = r * math.sin(theta);
            vertices.add([x, y, z]);
          }
        }
        for (int j = 0; j < bSegments; j++) {
          for (int i = 0; i < bSegments; i++) {
            int current = j * bSegments + i;
            int nextH = j * bSegments + ((i + 1) % bSegments);
            int nextV = (j + 1) * bSegments + i;
            // horizontal line
            if (j > 0 && j < bSegments) {
              edges.add([current, nextH]);
            }
            // vertical line
            edges.add([current, nextV]);
          }
        }
        break;
      default:
        // Default to a cube if not found
        vertices = [
          [-1, -1, -1], [1, -1, -1], [1, 1, -1], [-1, 1, -1],
          [-1, -1, 1], [1, -1, 1], [1, 1, 1], [-1, 1, 1]
        ];
        edges = [
          [0, 1], [1, 2], [2, 3], [3, 0],
          [4, 5], [5, 6], [6, 7], [7, 4],
          [0, 4], [1, 5], [2, 6], [3, 7]
        ];
    }

    // Transform and project vertices
    List<Offset> projected = [];
    for (var v in vertices) {
      double x = v[0];
      double y = v[1];
      double z = v[2];

      // Rotate Y
      double x2 = x * math.cos(angleY) - z * math.sin(angleY);
      double z2 = x * math.sin(angleY) + z * math.cos(angleY);

      // Rotate X
      double y2 = y * math.cos(angleX) - z2 * math.sin(angleX);
      double z3 = y * math.sin(angleX) + z2 * math.cos(angleX);

      // Simple perspective
      double distance = 4;
      double factor = distance / (distance + z3);

      double px = x2 * factor * scale + center.dx;
      double py = y2 * factor * scale + center.dy;
      projected.add(Offset(px, py));
    }

    // Draw edges
    for (var e in edges) {
      canvas.drawLine(projected[e[0]], projected[e[1]], paint);
    }
  }

  @override
  bool shouldRepaint(covariant _Bangun3DPainter oldDelegate) {
    return oldDelegate.angleY != angleY || oldDelegate.bangunId != bangunId;
  }
}
