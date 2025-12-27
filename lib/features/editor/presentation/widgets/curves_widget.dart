import 'package:flutter/material.dart';

class CurvesWidget extends StatefulWidget {
  final Function(List<Offset>) onCurveChanged;

  const CurvesWidget({super.key, required this.onCurveChanged});

  @override
  State<CurvesWidget> createState() => _CurvesWidgetState();
}

class _CurvesWidgetState extends State<CurvesWidget> {
  // We control a set of points. Start with linear: (0,0) and (1,1)
  List<Offset> _points = [const Offset(0, 0), const Offset(1, 1)];
  int? _activePointIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double size = constraints.maxWidth < constraints.maxHeight
          ? constraints.maxWidth
          : constraints.maxHeight;
      // Subtract padding
      size -= 40; 
      
      return Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.black54,
            border: Border.all(color: Colors.white24),
          ),
          child: GestureDetector(
            onPanStart: (details) => _handleTouch(details.localPosition, size),
            onPanUpdate: (details) => _handleTouch(details.localPosition, size),
            onPanEnd: (_) => setState(() => _activePointIndex = null),
            child: CustomPaint(
              painter: _CurvePainter(_points),
              size: Size(size, size),
            ),
          ),
        ),
      );
    });
  }

  void _handleTouch(Offset localPos, double size) {
    // Normalize logic
    double x = (localPos.dx / size).clamp(0.0, 1.0);
    double y = 1.0 - (localPos.dy / size).clamp(0.0, 1.0); // Y is inverted in UI coords

    // Find closest point
    if (_activePointIndex == null) {
      // Logic to pick or add point
      // Simple: just move the closest point if within radius, or add new
      // For this demo: just move the closest
      int bestIdx = -1;
      double minDesc = 1000;
      
      for(int i=0; i<_points.length; i++) {
        double dist = (Offset(x,y) - _points[i]).distance;
        if (dist < 0.1) {
           if (dist < minDesc) {
             minDesc = dist;
             bestIdx = i;
           }
        }
      }
      
      if (bestIdx != -1) {
        _activePointIndex = bestIdx;
      } else {
        // Add new point sorted
        _points.add(Offset(x,y));
        _points.sort((a,b) => a.dx.compareTo(b.dx));
        _activePointIndex = _points.indexOf(Offset(x,y));
      }
    }

    if (_activePointIndex != null) {
      setState(() {
        _points[_activePointIndex!] = Offset(x,y);
        // Ensure strictly increasing X for valid function? 
        // We'll trust the simple sort for now or constrain logic
      });
      // Debounce this in real app
      widget.onCurveChanged(_points);
    }
  }
}

class _CurvePainter extends CustomPainter {
  final List<Offset> points;
  _CurvePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    // Draw Grid
    final gridPaint = Paint()..color = Colors.white10..strokeWidth=1;
    canvas.drawLine(Offset(size.width/2, 0), Offset(size.width/2, size.height), gridPaint);
    canvas.drawLine(Offset(0, size.height/2), Offset(size.width, size.height/2), gridPaint);

    // Draw Spline/Lines
    final path = Path();
    // Simple linear segments for now. Catmull-Rom is better for curves.
    // Map points to Size
    final mappedPoints = points.map((p) => Offset(p.dx * size.width, (1.0 - p.dy) * size.height)).toList();
    
    if (mappedPoints.isNotEmpty) {
      path.moveTo(mappedPoints[0].dx, mappedPoints[0].dy);
      for (int i=1; i<mappedPoints.length; i++) {
        path.lineTo(mappedPoints[i].dx, mappedPoints[i].dy);
      }
    }
    canvas.drawPath(path, paint);

    // Draw Points
    final dotPaint = Paint()..color = Colors.white;
    for (var p in mappedPoints) {
      canvas.drawCircle(p, 6, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
