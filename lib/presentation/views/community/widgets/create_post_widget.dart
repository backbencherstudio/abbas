import 'package:flutter/material.dart';

import '../../../../cors/routes/route_names.dart';
import '../../../../cors/theme/app_colors.dart';

class CreatePostWidget extends StatelessWidget {
  const CreatePostWidget({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage('assets/images/girls_profile.png'),
                    ),
                  ),
                  const SizedBox(width: 12),

                    Expanded(
                    child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(24.0),
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 1.0,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Center(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "What's on your mind?",
                                  hintStyle: TextStyle(
                                    color: AppColors.greyTextColor,
                                  ),
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ),
                        ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: "assets/icons/photo.png",
                    label: "Photo",
                    onTap: (){Navigator.pushNamed(context, RouteNames.createPost);}
                  ),
                  _buildActionButton(
                    icon: "assets/icons/video.png",
                    label: "Video",
                      onTap: (){Navigator.pushNamed(context, RouteNames.createPost);}
                  ),
                  _buildActionButton(
                    icon: "assets/icons/pool.png",
                    label: "Poll",
                      onTap: (){Navigator.pushNamed(context, RouteNames.createPool);}
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(icon, scale: 1.7),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.greyTextColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

}
