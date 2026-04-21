import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../../../cors/routes/route_names.dart';
import '../../../../../widgets/secondary_appber.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final MobileScannerController _controller = MobileScannerController(
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_handled) return;

    final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
    final value = barcode?.rawValue ?? '';
    if (value.isEmpty) return;

    _handled = true;
    await _controller.stop();

    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('QR Detected'),
        content: Text('Value: $value'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              _handled = false;
              await _controller.start();
            },
            child: const Text('Scan Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).maybePop(value);
            },
            child: const Text('Use This'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff030D15),
      body: Column(
        children: [
          const SecondaryAppBar(title: 'Attendance'),

          SizedBox(height: 24.h),
          Image.asset("assets/icons/qr.png", scale: 2.4),
          SizedBox(height: 12.h),
          Text(
            "Scan QR code",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            "for QR attendance",
            style: TextStyle(
              color: const Color(0xff8C9196),
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 20.h),

          // ===== Scanner Area =====
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 👇 IMPORTANT: pass the function reference, do NOT call it
                    MobileScanner(
                      controller: _controller,
                      onDetect: _onDetect,
                      errorBuilder: (context, error, child) {
                        return Center(
                          child: Text(
                            'Camera error: $error',
                            style: const TextStyle(color: Colors.redAccent),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),

                    // Dim overlay
                    Container(color: Colors.black.withOpacity(0.35)),

                    // Corner-only brackets
                    CustomPaint(
                      painter: _CornerPainter(
                        color: Colors.red,
                        strokeWidth: 3,
                        cornerLength: 28,
                        inset: 10,
                      ),
                    ),

                    // Torch + Camera Switch
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => _controller.toggleTorch(),
                            // v1.x: torchState is a ValueListenable<TorchState>
                            icon: ValueListenableBuilder<TorchState>(
                              valueListenable: _controller.torchState,
                              builder: (context, state, _) {
                                return Icon(
                                  state == TorchState.on
                                      ? Icons.flash_on
                                      : Icons.flash_off,
                                  color: Colors.white,
                                );
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () => _controller.switchCamera(),
                            icon: const Icon(
                              Icons.cameraswitch,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false, // user must tap Back to Home
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: const Color(0xff8D9CDC), // dark background
                    child: Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0E17),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Circle with check
                          Image.asset('assets/images/Frame.png', scale: 3),
                          const SizedBox(height: 20),

                          // Text
                          const Text(
                            "Attendance Successful",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Back to Home button
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.parentScreen,
                              );
                            },
                            icon: Image.asset(
                              'assets/icons/back_arrow.png',
                              scale: 3,
                            ),
                            label: const Text(
                              "Back to Home",
                              style: TextStyle(
                                color: Color(0xff8D9CDC),
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                "Align the QR within the frame to scan automatically.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xff8C9196),
                  fontSize: 12.sp,
                ),
              ),
            ),
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

    // BR
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
