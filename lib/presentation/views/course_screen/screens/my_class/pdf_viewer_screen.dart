import 'dart:io';

import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/widgets/animated_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

enum _FileViewType { pdf, image, unsupported }

class PdfViewerScreen extends StatelessWidget {
  const PdfViewerScreen({
    super.key,
    required this.filePath,
    required this.title,
    this.mimeType,
  });

  final String filePath;
  final String title;
  final String? mimeType;

  _FileViewType get _viewType {
    final lowerName = title.toLowerCase();
    final mime = mimeType?.toLowerCase() ?? '';

    if (mime.contains('pdf') || lowerName.endsWith('.pdf')) {
      return _FileViewType.pdf;
    }

    if (mime.startsWith('image/') ||
        lowerName.endsWith('.jpg') ||
        lowerName.endsWith('.jpeg') ||
        lowerName.endsWith('.png') ||
        lowerName.endsWith('.gif') ||
        lowerName.endsWith('.webp')) {
      return _FileViewType.image;
    }

    return _FileViewType.unsupported;
  }

  bool get _isNetwork =>
      filePath.startsWith('http://') || filePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.containerColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 20.sp),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: switch (_viewType) {
        _FileViewType.pdf => _buildPdfViewer(),
        _FileViewType.image => _ImageFileViewer(
            filePath: filePath,
            isNetwork: _isNetwork,
          ),
        _FileViewType.unsupported => Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Text(
                'Preview is not supported for this file type.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
            ),
          ),
      },
    );
  }

  Widget _buildPdfViewer() {
    if (_isNetwork) {
      return SfPdfViewer.network(filePath);
    }
    return SfPdfViewer.file(File(filePath));
  }
}

class _ImageFileViewer extends StatelessWidget {
  const _ImageFileViewer({
    required this.filePath,
    required this.isNetwork,
  });

  final String filePath;
  final bool isNetwork;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4,
        child: isNetwork
            ? Image.network(
                filePath,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const AnimatedLoading();
                },
                errorBuilder: (context, error, stackTrace) {
                  return Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image_outlined,
                            color: Colors.red, size: 48.sp),
                        SizedBox(height: 12.h),
                        Text(
                          'Failed to load image',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : Image.file(
                File(filePath),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Text(
                      'Failed to load image',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
