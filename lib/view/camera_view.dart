import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import '../core/enum/scan_pay_type_enum.dart';
import '../scan_pay_controller.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    required this.detectorCode,
    required this.onImage,
    this.accessInputField,
    this.pageToBack,
    this.colorBackground,
    required this.scanPayType,
  }) : super(key: key);

  final Widget? detectorCode;

  final Function(InputImage inputImage) onImage;

  final Function()? accessInputField;

  final String? pageToBack;

  final Color? colorBackground;

  final ScanPayType scanPayType;

  final CameraLensDirection initialDirection = CameraLensDirection.back;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController _controller = CameraController(
    const CameraDescription(
      name: '',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 0,
    ),
    ResolutionPreset.high,
  );

  int _cameraIndex = -1;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) {
      Container();
    }

    final initialDirection = widget.initialDirection;

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
      _controller = CameraController(selectedCamera, ResolutionPreset.high);
      await _controller.initialize();
      setState(() {
        _cameraIndex = cameras.indexOf(selectedCamera!);
      });
      _startLiveFeed();
    } else {
      Container();
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    if (_controller.value.isInitialized == false) {
      return Container();
    }
    final size = MediaQuery.of(context).size;

    var scale = (size.aspectRatio) * _controller.value.aspectRatio;

    if (scale < 1) scale = 1 / scale;

    return SafeArea(
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Transform.scale(
              scale: scale,
              child: Center(
                child: CameraPreview(_controller),
              ),
            ),
            Visibility(
              replacement: const Offstage(),
              visible: widget.detectorCode != null,
              child: widget.detectorCode ?? const Offstage(),
            ),
            Visibility(
              visible: widget.scanPayType == ScanPayType.barcode,
              replacement: Positioned(
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  actions: [
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      icon: Icon(
                        _controller.value.flashMode == FlashMode.off
                            ? Icons.flashlight_off
                            : Icons.flashlight_on,
                        color: _controller.value.flashMode == FlashMode.off
                            ? Colors.white
                            : Colors.yellow,
                      ),
                      onPressed: () {
                        if (_controller.value.flashMode == FlashMode.off) {
                          _controller.setFlashMode(FlashMode.torch);
                        } else {
                          _controller.setFlashMode(FlashMode.off);
                        }
                        setState(() {});
                      },
                      iconSize: 38,
                    ),
                  ],
                ),
              ),
              child: Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: size.width / 4,
                  height: size.height,
                  color: widget.colorBackground?.withOpacity(.5) ??
                      Colors.blue.withOpacity(.5),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Offstage(),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.colorBackground,
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.keyboard,
                                  color: Colors.black, size: 20),
                              SizedBox(width: 10),
                              Text(
                                'Digitar código de barras',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                          onPressed: () => widget.accessInputField,
                        ),
                        TextButton(
                          child: Text(
                            widget.pageToBack ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: widget.scanPayType == ScanPayType.barcode,
              child: Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: size.width / 4,
                  height: size.height,
                  color: widget.colorBackground?.withOpacity(.5) ??
                      Colors.blue.withOpacity(.5),
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Offstage(),
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          'Posicione o código de barras no centro da tela',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: Colors.white,
                              ),
                        ),
                        IconButton(
                          padding: const EdgeInsets.all(0),
                          icon: Icon(
                            _controller.value.flashMode == FlashMode.off
                                ? Icons.flashlight_off
                                : Icons.flashlight_on,
                            color: _controller.value.flashMode == FlashMode.off
                                ? Colors.white
                                : Colors.yellow,
                          ),
                          onPressed: () {
                            if (_controller.value.flashMode == FlashMode.off) {
                              _controller.setFlashMode(FlashMode.torch);
                            } else {
                              _controller.setFlashMode(FlashMode.off);
                            }
                            setState(() {});
                          },
                          iconSize: 38,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _startLiveFeed() async {
    final camera = fiancialScannerCameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller.stopImageStream();
    await _controller.dispose();
    _controller;
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) return;
    widget.onImage(inputImage);
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
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

  @override
  void deactivate() {
    super.deactivate();
    _stopLiveFeed();
  }
}
