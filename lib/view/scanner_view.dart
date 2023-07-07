import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import '../core/enum/scan_pay_type_enum.dart';
import '../core/painter/scanner_style_painter.dart';
import 'camera_view.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({
    super.key,
    required this.onSuccess,
    this.accessInputField,
    this.pageToBack,
    this.colorBackground,
    required this.scanningType,
  });
  final Function(String) onSuccess;

  final Function()? accessInputField;

  final String? pageToBack;

  final Color? colorBackground;
  final ScanPayType scanningType;
  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _canProcess = true;
  bool _isBusy = false;
  Widget? _detectorCode;
  String? _text;

  @override
  void dispose() {
    _canProcess;
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  void initState() {
    _canProcess = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      scanPayType: widget.scanningType,
      detectorCode: _detectorCode ?? const Offstage(),
      colorBackground: widget.colorBackground,
      pageToBack: widget.pageToBack,
      onImage: (inputImage) => processImage(inputImage),
      accessInputField: () => widget.accessInputField!,
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;
    setState(() {
      _isBusy = true;
    });

    final List<Barcode> code = await _barcodeScanner.processImage(inputImage);

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final barcodePainter = ScannerDetectorPainter(
        code: code,
      );
      // final qrcodePainter = ScannerDetectorPainter(
      //   code: code,
      //   rectHeight: 250,
      //   rectWidth: 250,
      // );
      _detectorCode = barcodePainter;
      for (var element in code) {
        final String? displayValue = element.displayValue;
        if (displayValue != null) {
          widget.onSuccess(displayValue);
          _canProcess = false;
        }
      }
    }
    if (mounted) {
      setState(() {
        _isBusy = false;
      });
    }
  }
}
