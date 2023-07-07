import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class ScannerDetectorPainter extends StatelessWidget {
  const ScannerDetectorPainter({Key? key, required this.code})
      : super(key: key);

  final List<Barcode> code;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScannerDetector(
        code: code,
        rectHeight: 200,
        rectWidth: 200,
      ),
    );
  }
}

class ScannerDetector extends CustomPainter {
  ScannerDetector({
    required this.code,
    required this.rectHeight,
    required this.rectWidth,
    this.rectColor = Colors.red,
    this.rectBorderColor = Colors.white,
  });

  final List<Barcode> code;

  final double rectWidth;
  final double rectHeight;

  final Color rectColor;
  final Color rectBorderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final double rectLeft = (width - rectWidth) / 2;
    final double rectTop = (height - rectHeight) / 2;

    if (code.isNotEmpty) {
      final double rectCenterX = rectLeft + rectWidth / 2;
      final double rectCenterY = (rectTop) + rectHeight / 2;
      double lineLength = rectHeight / 1.1;

      final Paint barcodeLinePaint = Paint()
        ..color = rectColor
        ..strokeWidth = 4.0;

      canvas.drawLine(
        Offset(rectCenterX, rectCenterY - lineLength / 2),
        Offset(rectCenterX, rectCenterY + lineLength / 2),
        barcodeLinePaint,
      );
    } else if (code.isNotEmpty) {
      final Paint rectPaint = Paint()
        ..color = rectColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;

      final Paint rectBorderPaint = Paint()
        ..color = rectBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0;

      final RRect rect = RRect.fromLTRBR(
        rectLeft,
        rectTop,
        rectLeft + rectWidth,
        rectTop + rectHeight,
        const Radius.circular(10.0),
      );

      canvas.drawRRect(rect, rectPaint);
      canvas.drawRRect(rect, rectBorderPaint);
    }
  }

  @override
  bool shouldRepaint(ScannerDetector oldDelegate) {
    return oldDelegate.code != code;
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({
    required this.code,
    required this.lineWidth,
    required this.lineSize,
  });
  final List<Barcode> code;
  final double lineWidth;
  final double lineSize;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (code.isNotEmpty) {
      for (final barcode in code) {
        final points =
            barcode.value == BarcodeType.text ? barcode.cornerPoints : null;
        if (points != null) {
          final path = Path()
            ..moveTo(points[0].x.toDouble(), points[0].y.toDouble())
            ..lineTo(points[1].x.toDouble(), points[1].y.toDouble())
            ..lineTo(points[2].x.toDouble(), points[2].y.toDouble())
            ..lineTo(points[3].x.toDouble(), points[3].y.toDouble())
            ..lineTo(points[0].x.toDouble(), points[0].y.toDouble());
          canvas.drawPath(path, paint);
        }
      }
    }
  }

  convertToDouble(int value) => value.toDouble();

  @override
  bool shouldRepaint(_LinePainter oldDelegate) {
    return oldDelegate.code != code;
  }
}
