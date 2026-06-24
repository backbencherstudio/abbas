import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/cors/utils/app_utils.dart';
import 'package:abbas/presentation/views/home/view_model/attendance_scan_provider.dart';
import 'package:abbas/presentation/widgets/secondary_appber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class Scanner extends ConsumerStatefulWidget {
  const Scanner({super.key});

  @override
  ConsumerState<Scanner> createState() => _ScannerState();
}

class _ScannerState extends ConsumerState<Scanner> with WidgetsBindingObserver {
  late final MobileScannerController _controller;

  bool _handled = false;
  bool _permissionGranted = false;
  bool _permissionPermanentlyDenied = false;
  bool _checkingPermission = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    _ensureCameraPermission();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_permissionGranted) return;

    switch (state) {
      case AppLifecycleState.resumed:
        if (!_handled) _controller.start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _controller.stop();
        break;
    }
  }

  Future<void> _ensureCameraPermission() async {
    setState(() => _checkingPermission = true);

    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (!mounted) return;

    setState(() {
      _checkingPermission = false;
      _permissionGranted = status.isGranted;
      _permissionPermanentlyDenied = status.isPermanentlyDenied;
    });

    if (status.isGranted) {
      await _controller.start();
    }
  }

  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  Future<void> _resetScanner() async {
    _handled = false;
    if (_permissionGranted) {
      await _controller.start();
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handled || ref.read(attendanceScanProvider).isSubmitting) return;

    final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
    final value = barcode?.rawValue?.trim() ?? '';
    if (value.isEmpty) return;

    _handled = true;
    await _controller.stop();

    final result =
        await ref.read(attendanceScanProvider.notifier).submitToken(value);

    if (!mounted) return;

    if (result.success) {
      await _showSuccessDialog(result.message);
    } else {
      Utils.showToast(
        msg: result.message,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      await _resetScanner();
    }
  }

  Future<void> _showSuccessDialog(String message) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: const Color(0xFF0A0E17),
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/Frame.png', scale: 3),
                SizedBox(height: 20.h),
                Text(
                  'Attendance Successful',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).pop();
                  },
                  icon: Image.asset(
                    'assets/icons/back_arrow.png',
                    scale: 3,
                  ),
                  label: Text(
                    'Back to Home',
                    style: TextStyle(
                      color: const Color(0xff8D9CDC),
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (mounted) await _resetScanner();
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(attendanceScanProvider).isSubmitting;

    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Attendance'),
          SizedBox(height: 24.h),
          Image.asset('assets/icons/qr.png', scale: 2.4),
          SizedBox(height: 12.h),
          Text(
            'Scan QR code',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            'for QR attendance',
            style: TextStyle(
              color: const Color(0xff8C9196),
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: _buildScannerArea(isSubmitting),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
            child: Text(
              'Align the QR within the frame to scan automatically.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xff8C9196),
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerArea(bool isSubmitting) {
    if (_checkingPermission) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.activeButtonColor),
      );
    }

    if (!_permissionGranted) {
      return _PermissionDeniedView(
        permanentlyDenied: _permissionPermanentlyDenied,
        onRetry: _ensureCameraPermission,
        onOpenSettings: _openAppSettings,
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
              errorBuilder: (context, error) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Text(
                      error.errorDetails?.message ?? 'Camera unavailable',
                      style: const TextStyle(color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            CustomPaint(
              painter: _CornerPainter(
                color: Colors.red,
                strokeWidth: 3,
                cornerLength: 28,
                inset: 10,
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _controller.toggleTorch(),
                    icon: ValueListenableBuilder<MobileScannerState>(
                      valueListenable: _controller,
                      builder: (context, state, _) {
                        return Icon(
                          state.torchState == TorchState.on
                              ? Icons.flash_on
                              : Icons.flash_off,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () => _controller.switchCamera(),
                    icon: const Icon(Icons.cameraswitch, color: Colors.white),
                  ),
                ],
              ),
            ),
            if (isSubmitting)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.activeButtonColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PermissionDeniedView extends StatelessWidget {
  final bool permanentlyDenied;
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  const _PermissionDeniedView({
    required this.permanentlyDenied,
    required this.onRetry,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A29),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFF3D4566)),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 48.sp),
          SizedBox(height: 16.h),
          Text(
            'Camera permission required',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            permanentlyDenied
                ? 'Enable camera access in Settings to scan attendance QR codes.'
                : 'Allow camera access to scan the classroom QR code.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54, fontSize: 13.sp),
          ),
          SizedBox(height: 20.h),
          if (permanentlyDenied)
            ElevatedButton(
              onPressed: onOpenSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.activeButtonColor,
              ),
              child: const Text('Open Settings'),
            )
          else
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.activeButtonColor,
              ),
              child: const Text('Allow Camera'),
            ),
        ],
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double cornerLength;
  final double inset;

  _CornerPainter({
    required this.color,
    this.strokeWidth = 2,
    this.cornerLength = 20,
    this.inset = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final left = inset;
    final top = inset;
    final right = size.width - inset;
    final bottom = size.height - inset;

    canvas.drawLine(Offset(left, top), Offset(left + cornerLength, top), p);
    canvas.drawLine(Offset(left, top), Offset(left, top + cornerLength), p);
    canvas.drawLine(Offset(right, top), Offset(right - cornerLength, top), p);
    canvas.drawLine(Offset(right, top), Offset(right, top + cornerLength), p);
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left + cornerLength, bottom),
      p,
    );
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left, bottom - cornerLength),
      p,
    );
    canvas.drawLine(
      Offset(right, bottom),
      Offset(right - cornerLength, bottom),
      p,
    );
    canvas.drawLine(
      Offset(right, bottom),
      Offset(right, bottom - cornerLength),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.cornerLength != cornerLength ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.inset != inset;
}
