import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/routes/app_routes.dart';
import '../../../core/config/themes/app_colors.dart';
import '../../../presentation/bloc/setting/setting_bloc.dart';
import '../../../presentation/bloc/setting/setting_event.dart';

class TakeCameraPage extends StatefulWidget {
  const TakeCameraPage({super.key});

  @override
  State<TakeCameraPage> createState() => _TakeCameraPageState();
}

class _TakeCameraPageState extends State<TakeCameraPage> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  /// Initialize camera
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;

    _currentCameraIndex = 0;
    await _startCamera(_cameras[_currentCameraIndex]);
  }

  /// Start camera
  Future<void> _startCamera(CameraDescription desc) async {
    await _controller?.dispose();

    _controller = CameraController(
      desc,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  /// Switch camera
  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
    await _startCamera(_cameras[_currentCameraIndex]);
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final file = await _controller!.takePicture();

    if (!mounted) return;

    context.read<SettingBloc>().add(UpdateAvatarSubmitted(filePath: file.path));

    context.go(AppRoutes.changeprofile);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body:
          _isInitialized && _controller != null
              ? Stack(
                children: [
                  // Camera preview
                  Positioned.fill(child: CameraPreview(_controller!)),

                  // Back
                  Positioned(
                    top: 50,
                    left: 20,
                    child: InkWell(
                      onTap: () => context.go(AppRoutes.changeprofile),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Switch camera
                  Positioned(
                    top: 50,
                    right: 20,
                    child: GestureDetector(
                      onTap: _switchCamera,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.35),
                        ),
                        child: const Icon(
                          Icons.cameraswitch,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  // Capture button
                  Positioned(
                    bottom: 55,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: InkWell(
                        onTap: _takePicture,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.blur.withOpacity(0.6),
                              width: 4,
                            ),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.blur,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
