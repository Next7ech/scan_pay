import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'core/enum/scan_pay_type_enum.dart';
import 'view/scanner_view.dart';

List<CameraDescription> fiancialScannerCameras = [];

class ScanPayController {
  void openScanner(
    BuildContext context, {
    required ScanPayType scanPayType,
    required Function(String) onSuccess,
    Function()? accessInputField,
    String? pageToBack,
    Color? colorBackground,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScannerView(
          onSuccess: (code) => onSuccess(code),
          accessInputField: () => accessInputField,
          colorBackground: colorBackground,
          pageToBack: pageToBack,
          scanningType: scanPayType,
        ),
      ),
    );
  }

  /// This method is used to initialize the camera
  static Future<void> intiCamera() async {
    fiancialScannerCameras = await availableCameras();
  }
}
