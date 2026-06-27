import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../../../cors/routes/route_names.dart';
import 'package:abbas/presentation/views/course_screen/screens/my_class/widget/pdf_widget.dart';
import '../model/conversation_attachment_model.dart';
import '../provider/conversation_attachments_provider.dart';
import '../screens/chat_image_viewer_screen.dart';

Future<void> showConversationMediaFilesSheet({
  required BuildContext context,
  required String conversationId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xff030D15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    builder: (_) => _ConversationMediaFilesSheet(
      conversationId: conversationId,
    ),
  );
}

class _ConversationMediaFilesSheet extends StatefulWidget {
  final String conversationId;

  const _ConversationMediaFilesSheet({required this.conversationId});

  @override
  State<_ConversationMediaFilesSheet> createState() =>
      _ConversationMediaFilesSheetState();
}

class _ConversationMediaFilesSheetState
    extends State<_ConversationMediaFilesSheet>
    with SingleTickerProviderStateMixin {
  late final ConversationAttachmentsProvider _provider;
  late final TabController _tabController;
  late final ScrollController _mediaScrollController;
  late final ScrollController _filesScrollController;

  @override
  void initState() {
    super.initState();
    _provider = ConversationAttachmentsProvider();
    _tabController = TabController(length: 2, vsync: this);
    _mediaScrollController = ScrollController()..addListener(_onMediaScroll);
    _filesScrollController = ScrollController()..addListener(_onFilesScroll);

    _provider.fetchMedia(widget.conversationId);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    if (_tabController.index == 1 &&
        _provider.fileItems.isEmpty &&
        !_provider.isLoadingFiles) {
      _provider.fetchFiles(widget.conversationId);
    }
  }

  void _onMediaScroll() {
    if (!_mediaScrollController.hasClients) return;
    final pos = _mediaScrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _provider.fetchMedia(widget.conversationId, loadMore: true);
    }
  }

  void _onFilesScroll() {
    if (!_filesScrollController.hasClients) return;
    final pos = _filesScrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _provider.fetchFiles(widget.conversationId, loadMore: true);
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _mediaScrollController.dispose();
    _filesScrollController.dispose();
    _provider.dispose();
    super.dispose();
  }

  void _openMediaItem(
    BuildContext context,
    ConversationAttachment item,
    List<ConversationAttachment> mediaItems,
  ) {
    if (item.isVideo) {
      Navigator.pushNamed(
        context,
        RouteNames.videoPlayerScreen,
        arguments: {
          'asset_url': item.filePath,
          'file_name': item.fileName.isNotEmpty ? item.fileName : 'Video',
        },
      );
      return;
    }

    final images = mediaItems.where((a) => a.isImage).toList();
    final urls =
        images.map((a) => a.filePath).where((u) => u.isNotEmpty).toList();
    if (urls.isEmpty) return;

    final index = images.indexWhere((a) => a.id == item.id);
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChatImageViewerScreen(
          urls: urls,
          initialIndex: index.clamp(0, urls.length - 1),
        ),
      ),
    );
  }

  void _openFile(BuildContext context, ConversationAttachment item) {
    if (item.filePath.isEmpty) return;

    if (item.isPdf) {
      Navigator.pushNamed(
        context,
        RouteNames.pdfViewerScreen,
        arguments: {
          'asset_url': item.filePath,
          'file_name': item.fileName.isNotEmpty ? item.fileName : 'Document',
          'mime_type': item.mimeType,
        },
      );
      return;
    }

    Navigator.pushNamed(
      context,
      RouteNames.pdfViewerScreen,
      arguments: {
        'asset_url': item.filePath,
        'file_name': item.fileName.isNotEmpty ? item.fileName : 'File',
        'mime_type': item.mimeType,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.75;

    return ChangeNotifierProvider.value(
      value: _provider,
      child: SizedBox(
        height: sheetHeight,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xff3D4466),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'View media & files',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 12.h),
            TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xffE9201D),
              indicatorWeight: 2,
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xff8C9196),
              tabs: const [
                Tab(text: 'Media'),
                Tab(text: 'Files'),
              ],
            ),
            Expanded(
              child: Consumer<ConversationAttachmentsProvider>(
                builder: (context, provider, _) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _MediaTab(
                        items: provider.mediaItems,
                        isLoading: provider.isLoadingMedia,
                        isLoadingMore: provider.isLoadingMoreMedia,
                        scrollController: _mediaScrollController,
                        onTap: (item) =>
                            _openMediaItem(context, item, provider.mediaItems),
                      ),
                      _FilesTab(
                        items: provider.fileItems,
                        isLoading: provider.isLoadingFiles,
                        isLoadingMore: provider.isLoadingMoreFiles,
                        scrollController: _filesScrollController,
                        onView: (item) => _openFile(context, item),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaTab extends StatelessWidget {
  final List<ConversationAttachment> items;
  final bool isLoading;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final ValueChanged<ConversationAttachment> onTap;

  const _MediaTab({
    required this.items,
    required this.isLoading,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xffE9201D)),
      );
    }

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No media found',
          style: TextStyle(color: Color(0xff8C9196)),
        ),
      );
    }

    return GridView.builder(
      controller: scrollController,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
      ),
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xffE9201D),
              ),
            ),
          );
        }

        final item = items[index];
        return GestureDetector(
          onTap: () => onTap(item),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (item.isImage)
                Image.network(
                  item.filePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xff1F283D),
                    child: const Icon(Icons.broken_image, color: Colors.white54),
                  ),
                )
              else
                Container(
                  color: const Color(0xff1F283D),
                  child: Icon(
                    item.isVideo ? Icons.videocam : Icons.perm_media,
                    color: Colors.white54,
                    size: 28.sp,
                  ),
                ),
              if (item.isVideo)
                Container(
                  color: Colors.black26,
                  child: Icon(
                    Icons.play_circle_fill,
                    color: Colors.white.withValues(alpha: 0.9),
                    size: 28.sp,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _FilesTab extends StatefulWidget {
  final List<ConversationAttachment> items;
  final bool isLoading;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final ValueChanged<ConversationAttachment> onView;

  const _FilesTab({
    required this.items,
    required this.isLoading,
    required this.isLoadingMore,
    required this.scrollController,
    required this.onView,
  });

  @override
  State<_FilesTab> createState() => _FilesTabState();
}

class _FilesTabState extends State<_FilesTab> {
  final Set<String> _downloadingIds = {};

  Future<void> _downloadFile(ConversationAttachment item) async {
    final url = item.filePath;
    final fileName =
        item.fileName.isNotEmpty ? item.fileName : 'attachment_${item.id}';

    if (url.isEmpty || _downloadingIds.contains(item.id)) return;

    setState(() => _downloadingIds.add(item.id));

    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName';
      final file = File(filePath);
      if (file.existsSync()) await file.delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading $fileName...')),
        );
      }

      await Dio().download(url, filePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded $fileName')),
        );
      }

      await showDownloadCompletedNotification(filePath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _downloadingIds.remove(item.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading && widget.items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xffE9201D)),
      );
    }

    if (widget.items.isEmpty) {
      return const Center(
        child: Text(
          'No files found',
          style: TextStyle(color: Color(0xff8C9196)),
        ),
      );
    }

    return ListView.separated(
      controller: widget.scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: widget.items.length + (widget.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        if (index >= widget.items.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xffE9201D),
              ),
            ),
          );
        }

        final item = widget.items[index];
        final isDownloading = _downloadingIds.contains(item.id);

        return _FileAttachmentCard(
          item: item,
          isDownloading: isDownloading,
          onView: () => widget.onView(item),
          onDownload: () => _downloadFile(item),
        );
      },
    );
  }
}

class _FileAttachmentCard extends StatelessWidget {
  final ConversationAttachment item;
  final bool isDownloading;
  final VoidCallback onView;
  final VoidCallback onDownload;

  const _FileAttachmentCard({
    required this.item,
    required this.isDownloading,
    required this.onView,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xff0D2136),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onView,
                borderRadius: BorderRadius.circular(8.r),
                child: Row(
                  children: [
                    if (item.isPdf)
                      SvgPicture.asset(
                        'assets/icons/pdf.svg',
                        height: 32.h,
                        width: 32.w,
                      )
                    else
                      SvgPicture.asset(
                        'assets/icons/doc.svg',
                        height: 32.h,
                        width: 32.w,
                        colorFilter: const ColorFilter.mode(
                          Color(0xff5F6CA0),
                          BlendMode.srcIn,
                        ),
                      ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        item.fileName.isNotEmpty ? item.fileName : 'File',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: isDownloading ? null : onDownload,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: isDownloading
                  ? SizedBox(
                      width: 22.w,
                      height: 22.h,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xffE9201D),
                      ),
                    )
                  : SvgPicture.asset(
                      'assets/icons/download.svg',
                      height: 22.h,
                      width: 22.w,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
