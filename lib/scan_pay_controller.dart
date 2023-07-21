import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'core/enum/scan_pay_type_enum.dart';
import 'view/scanner_view.dart';

List<CameraDescription> fiancialScannerCameras = [];

class ScanPay {
  call(
    BuildContext context, {
    required ScanPayType scanPayType,
    required String helpText,
    required String titleButtonText,
    required int minDetectedCode,
    required int maxDetectedCode,
    required Color backgroundColor,
    required Color secondaryColor,
    required Color primaryColor,
    required Color detectorPrimaryColor,
    required Color detectorSecondaryColor,
    required TextStyle titleButtonTextStyle,
    required TextStyle helpTextStyle,
    required Function(String) onSuccess,
    required Function() digitableBoletoPage,
  }) {
    return ScannerView(
      helpText: helpText,
      helpTextStyle: helpTextStyle,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      titleButtonTextStyle: titleButtonTextStyle,
      titleButtonText: titleButtonText,
      detectorPrimaryColor: detectorPrimaryColor,
      detectorSecondaryColor: detectorSecondaryColor,
      digitableBoletoPage: digitableBoletoPage,
      onSuccess: (code) => onSuccess(code),
      backgroundColor: backgroundColor,
      scanningType: scanPayType,
      maxDetectedCode: maxDetectedCode,
      minDetectedCode: minDetectedCode,
    );
  }
}
