import 'package:abbas/presentation/views/profile/view_model/profil_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/custom_appbar.dart';
import '../../domain/community/community_entity.dart';
import '../../widgets/create_post_widget.dart';
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
    final provider = Provider.of<ProfileScreenProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          const CustomAppbar(title: "Community"),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CreatePostWidget(),
          ),

          Expanded(
            child: Consumer<CommunityScreenProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(child: Text(provider.error!));
                }

                if (provider.feeds.isEmpty) {
                  return const Center(child: Text("No Posts Available"));
                }
                return ListView.builder(
                  itemCount: provider.feeds.length,
                  itemBuilder: (context, index) {
                    final CommunityEntity feed = provider.feeds[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 7,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xff0A1A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      debugPrint(
                                        "THe id autherID ${feed.authorId}",
                                      );
                                      debugPrint("THe id ID ${feed.id}");
                                    },
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        feed.author?.avatar ?? "",
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        feed.author?.name ?? "N/A",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        feed.createdAt ?? "",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              SizedBox(height: 10),

                              Text(
                                feed.content ?? "N/A",
                                style: TextStyle(color: Colors.white),
                              ),

                              SizedBox(height: 10),

                              feed.mediaUrl != null && feed.mediaUrl!.isNotEmpty
                                  ? GestureDetector(
                                      onTap: () {},
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(feed.mediaUrl!),
                                      ),
                                    )
                                  : Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                                    ),

                              SizedBox(height: 10),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(child: Text("👍")),
                                      Text("${feed.likeCount ?? 0}"),
                                    ],
                                  ),

                                  Text("💬 ${feed.commentCount ?? 0}"),
                                  Text("🔁 ${feed.shareCount ?? 0}"),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}
