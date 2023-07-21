// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import '../core/enum/scan_pay_type_enum.dart';
import '../scan_pay_controller.dart';

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    this.titleButtonText,
    this.titleButtonTextStyle,
    this.helpText,
    this.helpTextStyle,
    required this.detectorCode,
    required this.onImage,
    this.accessInputField,
    this.colorBackground,
    this.secondaryColor,
    this.primaryColor,
    required this.scanPayType,
  }) : super(key: key);

  final String? titleButtonText;

  final TextStyle? titleButtonTextStyle;

  final String? helpText;

  final TextStyle? helpTextStyle;

  final Widget? detectorCode;

  final Function(InputImage inputImage) onImage;

  final Function()? accessInputField;

  final Color? colorBackground;

  final Color? secondaryColor;
  final Color? primaryColor;

  final ScanPayType scanPayType;

  final CameraLensDirection initialDirection = CameraLensDirection.back;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController _cameraController = CameraController(
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
    _cameraController.addListener(() {
      if (_cameraController.value.hasError) {
        print('Camera error ${_cameraController.value.errorDescription}');
      }
      CameraController(
        const CameraDescription(
          name: '',
          lensDirection: CameraLensDirection.back,
          sensorOrientation: 0,
        ),
        ResolutionPreset.high,
      );
    });
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
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
      _cameraController =
          CameraController(selectedCamera, ResolutionPreset.high);
      await _cameraController.initialize();
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
    WidgetsBinding.instance.removeObserver(this);
    _stopLiveFeed();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    if (_cameraController.value.isInitialized == false) {
      return Container();
    }
    final size = MediaQuery.of(context).size;
    var scale = (size.aspectRatio) * _cameraController.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(_cameraController),
          ),
        ),
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            widget.colorBackground ?? Colors.black.withOpacity(0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width * 0.3,
                  height: size.height * 0.7,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: SizedBox(
            width: size.width * 0.3,
            height: size.height * 0.7,
            child: widget.detectorCode ?? const Offstage(),
          ),
        ),
        Positioned(
          right: 0,
          child: RotatedBox(
            quarterTurns: 1,
            child: Container(
              width: size.height,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(54, 54),
                      elevation: 8,
                      foregroundColor: widget.secondaryColor ?? Colors.black,
                      backgroundColor: widget.primaryColor ?? Colors.white,
                      shape: const CircleBorder(),
                    ),
                    child: Transform.scale(
                      scale: 1.2,
                      child: Icon(
                        Icons.arrow_back,
                        size: 24,
                        color: widget.secondaryColor ?? Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.8,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.secondaryColor ?? Colors.white,
                    ),
                    child: Center(
                        child: Text(
                      widget.helpText ?? '',
                      style: widget.helpTextStyle ??
                          Theme.of(context).textTheme.labelLarge,
                    )),
                  ),
                  Visibility(
                    visible: false,
                    replacement:
                        IconButton(onPressed: () {}, icon: const Offstage()),
                    child: FlashOnWidget(
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          child: RotatedBox(
            quarterTurns: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 24,
              ),
              width: size.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: widget.accessInputField,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(272, 54),
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 8,
                      foregroundColor: widget.secondaryColor ?? Colors.black,
                      backgroundColor: widget.primaryColor ?? Colors.white,
                    ),
                    child: Text(
                      widget.titleButtonText ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: widget.secondaryColor ?? Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future _startLiveFeed() async {
    final camera = fiancialScannerCameras[_cameraIndex];
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _cameraController.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_cameraController.value.isInitialized == false) {
        await _cameraController.stopImageStream();
        await _cameraController.dispose();
      }
      _cameraController;
    });
  }

  _processCameraImage(CameraImage image) {
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
    _stopLiveFeed();
    _cameraController.dispose();
  }
}

class FlashOnWidget extends StatelessWidget {
  FlashOnWidget({
    super.key,
    required this.onPressed,
  });
  final Function() onPressed;
  final ValueNotifier<bool> _isFlashOn = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: _isFlashOn,
        builder: (context, value, child) {
          return ElevatedButton(
            onPressed: () {
              _isFlashOn.value = !_isFlashOn.value;
              onPressed();
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(54, 54),
              elevation: 8,
              foregroundColor: Colors.black,
              backgroundColor: Colors.amberAccent,
              shape: const CircleBorder(),
            ),
            child: const Icon(
              Icons.flash_on,
              size: 24,
            ),
          );
        });
  }
}
