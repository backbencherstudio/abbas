import 'package:abbas/cors/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebviewScreen extends StatefulWidget {
  final String url;

  const PaymentWebviewScreen({super.key, required this.url});

  @override
  State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            if (mounted) setState(() => _isLoading = true);
          },
          onPageFinished: (url) => _handleUrl(url),
          onWebResourceError: (_) {
            if (mounted) setState(() => _isLoading = false);
            Utils.showToast(
              msg: 'Failed to load payment page',
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          },
          onNavigationRequest: (request) {
            if (_handleUrl(request.url, preventNavigation: true)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  bool _handleUrl(String url, {bool preventNavigation = false}) {
    final normalizedUrl = url.toLowerCase();

    if (normalizedUrl.contains('success?session_id=') ||
        normalizedUrl.contains('/payment/success') ||
        (normalizedUrl.contains('/success') &&
            normalizedUrl.contains('session_id='))) {
      _closeWithResult(true);
      return preventNavigation;
    }

    if (normalizedUrl.contains('/failed') ||
        normalizedUrl.contains('/cancel') ||
        normalizedUrl.contains('status=failed')) {
      _closeWithResult(false, showError: true);
      return preventNavigation;
    }

    if (mounted) setState(() => _isLoading = false);
    return false;
  }

  void _closeWithResult(bool success, {bool showError = false}) {
    if (_isClosing || !mounted) return;
    _isClosing = true;

    if (showError) {
      Utils.showToast(
        msg: 'Payment cancelled or failed',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }

    Navigator.pop(context, success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030C15),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A29),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
          onPressed: () => _closeWithResult(false),
        ),
        title: Text(
          'Payment',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: Color(0xFFE9201D)),
            ),
        ],
      ),
    );
  }
}
