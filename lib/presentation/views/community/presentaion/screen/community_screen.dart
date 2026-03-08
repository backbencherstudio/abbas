import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/custom_appbar.dart';
import '../../domain/community/community_entity.dart';
import '../provider/community/community_screen_provider.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CommunityScreenProvider>().fetchFeeds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppbar(title: "Community"),

            Expanded(
              child: Consumer<CommunityScreenProvider>(
                builder: (context, provider, child) {

                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Text(provider.error!),
                    );
                  }

                  if (provider.feeds.isEmpty) {
                    return const Center(
                      child: Text("No Posts Available"),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.feeds.length,
                    itemBuilder: (context, index) {
                      final CommunityEntity feed = provider.feeds[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// Author
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                    NetworkImage(feed.author?.name ?? ""),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    feed.authorId ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              /// Content
                              Text(feed.content ?? ""),

                              const SizedBox(height: 10),

                              /// Media
                              if (feed.mediaUrl != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(feed.mediaUrl!),
                                ),

                              const SizedBox(height: 10),

                              /// Actions
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("👍 ${feed.likeCount ?? 0}"),
                                  Text("💬 ${feed.commentCount ?? 0}"),
                                  Text("🔁 ${feed.shareCount ?? 0}"),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
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