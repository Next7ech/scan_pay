import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import '../scan_pay_controller.dart';

class ControllerCamera extends ChangeNotifier {
  late final Function(InputImage inputImage) onImage;

  final int _cameraIndex = -1;

  late final CameraLensDirection initialDirection;

  late final CameraController? cameraController;

  void initializeCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      Container();
    }

    final initialDirection = this.initialDirection;

    CameraDescription? selectedCamera;

    for (var camera in cameras) {
      if (camera.lensDirection == initialDirection &&
          camera.sensorOrientation == 90) {
        selectedCamera = camera;
        break;
      }
    }

    if (selectedCamera == null) {
      for (var camera in cameras) {
        if (camera.lensDirection == initialDirection) {
          selectedCamera = camera;
          break;
        }
      }
    }

    if (selectedCamera != null) {
      cameraController =
          CameraController(selectedCamera, ResolutionPreset.high);
      await cameraController?.initialize();
      notifyListeners();
      startLiveFeed();
    } else {
      Container();
    }
  }

  Future startLiveFeed() async {
    final camera = fiancialScannerCameras[_cameraIndex];
    cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    cameraController?.initialize().then((_) {
      cameraController?.startImageStream(processCameraImage);
      notifyListeners();
    });
  }

  Future stopLiveFeed() async {
    await cameraController?.stopImageStream();
    await cameraController?.dispose();
    cameraController = null;
  }

  void processCameraImage(CameraImage image) {
    final inputImage = inputImageFromCameraImage(image);
    if (inputImage == null) return;
    onImage(inputImage);
  }

  InputImage? inputImageFromCameraImage(CameraImage image) {
    final camera = fiancialScannerCameras[_cameraIndex];
    final rotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
}
