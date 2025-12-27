import 'package:flutter/material.dart';
import '../../../../core/image/histogram_data.dart';

class HistogramWidget extends StatelessWidget {
  final HistogramData data;
  final double width;
  final double height;

  const HistogramWidget({
    super.key,
    required this.data,
    this.width = 120,
    this.height = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: CustomPaint(
        painter: _HistogramPainter(data),
      ),
    );
  }
}

class _HistogramPainter extends CustomPainter {
  final HistogramData data;

  _HistogramPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paintR = Paint()
      ..color = Colors.red.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final paintG = Paint()
      ..color = Colors.green.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final paintB = Paint()
      ..color = Colors.blue.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
      
    // Fill
    final paintRFill = Paint()..color = Colors.red.withOpacity(0.2)..style = PaintingStyle.fill;
    final paintGFill = Paint()..color = Colors.green.withOpacity(0.2)..style = PaintingStyle.fill;
    final paintBFill = Paint()..color = Colors.blue.withOpacity(0.2)..style = PaintingStyle.fill;


    // Normalize
    int max = 1;
    for (int i = 0; i < 256; i++) {
       if (data.r[i] > max) max = data.r[i];
       if (data.g[i] > max) max = data.g[i];
       if (data.b[i] > max) max = data.b[i];
    }
    
    // Smooth factor? No, raw is fine.
    
    final pathR = Path();
    final pathG = Path();
    final pathB = Path();
    
    pathR.moveTo(0, size.height);
    pathG.moveTo(0, size.height);
    pathB.moveTo(0, size.height);
    
    final wStep = size.width / 255.0;
    
    for (int i = 0; i < 256; i++) {
       final x = i * wStep;
       final hR = (data.r[i] / max) * size.height;
       final hG = (data.g[i] / max) * size.height;
       final hB = (data.b[i] / max) * size.height;
       
       pathR.lineTo(x, size.height - hR);
       pathG.lineTo(x, size.height - hG);
       pathB.lineTo(x, size.height - hB);
    }
    
    pathR.lineTo(size.width, size.height);
    pathG.lineTo(size.width, size.height);
    pathB.lineTo(size.width, size.height);
    
    canvas.drawPath(pathR, paintRFill);
    canvas.drawPath(pathR, paintR);
    
    canvas.drawPath(pathG, paintGFill);
    canvas.drawPath(pathG, paintG);
    
    canvas.drawPath(pathB, paintBFill);
    canvas.drawPath(pathB, paintB);
    
    // Draw white blend? Optional. 
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
