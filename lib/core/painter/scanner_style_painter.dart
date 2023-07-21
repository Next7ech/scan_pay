import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class ScannerDetectorPainter extends CustomPainter {
  ScannerDetectorPainter({
    required this.code,
    this.detectorPrimaryColor = Colors.white,
    this.detectorSecudaryColor = Colors.red,
    required this.maxDetectedCode,
    required this.minDetectedCode,
  });

  final List<Barcode> code;

  final Color detectorPrimaryColor;
  final Color detectorSecudaryColor;

  final int maxDetectedCode;

  final int minDetectedCode;

  @override
  void paint(Canvas canvas, Size size) {
    Paint pa = Paint()
      ..color = detectorPrimaryColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    double width = size.width;
    double height = size.height;

    canvas.drawLine(Offset(width / 2, 0), Offset(width / 2, height), pa);
    canvas.drawLine(Offset(0, height), Offset(width, height), pa);
    canvas.drawLine(const Offset(0, 0), Offset(width, 0), pa);
    for (final point in code) {
      Paint pa = Paint()
        ..color = point.displayValue!.isNotEmpty
            ? detectorSecudaryColor
            : detectorPrimaryColor
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;

      double width = size.width;
      double height = size.height;

      canvas.drawLine(Offset(width / 2, 0), Offset(width / 2, height), pa);
      canvas.drawLine(Offset(0, height), Offset(width, height), pa);
      canvas.drawLine(const Offset(0, 0), Offset(width, 0), pa);
    }
  }

  @override
  bool shouldRepaint(ScannerDetectorPainter oldDelegate) {
    return oldDelegate.code != code;
  }
}
