import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scan_pay/scan_pay.dart';

import 'info_code.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Financial Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeFinancial(),
    );
  }
}

class HomeFinancial extends StatefulWidget {
  const HomeFinancial({super.key});

  @override
  State<HomeFinancial> createState() => _HomeFinancialState();
}

class _HomeFinancialState extends State<HomeFinancial> {
  final ScanPay scanPay = ScanPay();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Financial Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            scanPay(
              context,
              scanPayType: ScanPayType.barcode,
              backgroundColor: Colors.black.withOpacity(0.5),
              detectorPrimaryColor: Colors.white,
              detectorSecudaryColor: Colors.red,
              primaryColor: Colors.red,
              secondaryColor: Colors.white,
              helpText: 'Scan Slip',
              digitableBoletoPage: () => const Text('Digitable Boleto'),
              titleButtonText: 'Cancel',
              titleButtonTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              helpTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              onSuccess: (code) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoCode(code: code),
                  ),
                );
              },
            );
          },
          child: const Text('Scan Slip'),
        ),
      ),
    );
  }
}

class BorderDetect extends StatelessWidget {
  const BorderDetect({
    super.key,
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              left: 0,
              top: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomPaint(
                    size: const Size(10, 10),
                    painter: CustomShapePainter(
                      rotation: 0,
                      fillColor: color,
                    ),
                  ),
                  CustomPaint(
                    size: const Size(10, 10),
                    painter: CustomShapePainter(
                      rotation: 90,
                      fillColor: color,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomPaint(
                    size: const Size(10, 10),
                    painter: CustomShapePainter(
                      rotation: 270,
                      fillColor: color,
                    ),
                  ),
                  CustomPaint(
                    size: const Size(10, 10),
                    painter: CustomShapePainter(
                      rotation: 180,
                      fillColor: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomShapePainter extends CustomPainter {
  final Color fillColor;
  final int rotation;

  CustomShapePainter({required this.fillColor, required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, 30)
      ..lineTo(10, 30)
      ..lineTo(10, 10)
      ..lineTo(30, 10)
      ..lineTo(30, 0)
      ..close();

    double rotationInRadians = rotation * (pi / 180); // Convert to radians
    canvas.translate(centerX, centerY); // Move to the center of the canvas
    canvas.rotate(rotationInRadians); // Apply rotation
    canvas.translate(-centerX, -centerY); // Move back to the original position

    final Paint fillPaint = Paint()..color = fillColor;
    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
