import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'core/enum/scan_pay_type_enum.dart';
import 'view/scanner_view.dart';

List<CameraDescription> fiancialScannerCameras = [];

class ScanPay {
  call(
    BuildContext context, {
    required ScanPayType scanPayType,
    String? helpText,
    String? titleButtonText,
    Color? backgroundColor,
    Color? secondaryColor,
    Color? primaryColor,
    Color? detectorPrimaryColor,
    Color? detectorSecudaryColor,
    TextStyle? titleButtonTextStyle,
    TextStyle? helpTextStyle,
    required Function(String) onSuccess,
    Function()? digitableBoletoPage,
  }) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ScannerView(
              headerText: helpText,
              helpTextStyle: helpTextStyle,
              primaryColor: primaryColor,
              secondaryColor: secondaryColor,
              titleButtonTextStyle: titleButtonTextStyle,
              titleButtonText: titleButtonText,
              detectorPrimaryColor: detectorPrimaryColor,
              detectorSecudaryColor: detectorSecudaryColor,
              digitableBoletoPage: () => digitableBoletoPage,
              onSuccess: (code) => onSuccess(code),
              backgroundColor: backgroundColor,
              scanningType: scanPayType,
            );
          },
        ),
      );
    });
  }
}
