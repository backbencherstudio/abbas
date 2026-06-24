import 'package:abbas/cors/theme/app_colors.dart';
import 'package:abbas/presentation/views/community/presentaion/provider/community/community_search_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommunitySearchScreen extends ConsumerStatefulWidget {
  const CommunitySearchScreen({super.key});

  @override
  ConsumerState<CommunitySearchScreen> createState() =>
      _CommunitySearchScreenState();
}

class _CommunitySearchScreenState extends ConsumerState<CommunitySearchScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocus;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocus = FocusNode();
    Future.microtask(
      () => ref.read(communitySearchHistoryProvider.notifier).loadRecent(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _submit([String? rawQuery]) async {
    final query = await ref
        .read(communitySearchHistoryProvider.notifier)
        .submit(rawQuery ?? _searchController.text);
    if (!mounted || query == null) return;
    Navigator.pop(context, query);
  }

  @override
  Widget build(BuildContext context) {
    final recentSearches = ref.watch(communitySearchHistoryProvider).recentSearches;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 12.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A1A29),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: const Color(0xFF3D4566)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        onSubmitted: _submit,
                        textInputAction: TextInputAction.search,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        decoration: InputDecoration(
                          hintText: 'Search posts...',
                          hintStyle: TextStyle(
                            color: Colors.white38,
                            fontSize: 14.sp,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.white54,
                                    size: 18.sp,
                                  ),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 12.h,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _submit(),
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: AppColors.activeButtonColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
              child: Text(
                'Recent searches',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: recentSearches.isEmpty
                  ? Center(
                      child: Text(
                        'No recent searches',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                      child: Wrap(
                        spacing: 10.w,
                        runSpacing: 10.h,
                        children: recentSearches.map((term) {
                          return _SearchChip(
                            label: term,
                            onTap: () {
                              _searchController.text = term;
                              _submit(term);
                            },
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SearchChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0A1A29),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: const Color(0xFF3D4566)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
