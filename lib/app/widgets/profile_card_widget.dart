import 'package:flutter/material.dart';
import '../constants/app_color.dart';
import '../constants/app_widget_size.dart';

class ProfileCardWidget extends StatelessWidget {
  final String userName;
  final String greeting;
  final String? imageUrl;
  final bool showIcon;
  final IconData iconData;
  final Color iconBackgroundColor;
  final VoidCallback? onTap;
  final VoidCallback? onIconTap;

  const ProfileCardWidget({
    super.key,
    required this.userName,
    this.greeting = "Welcome Back",
    this.imageUrl,
    this.showIcon = true,
    this.iconData = Icons.arrow_forward_ios,
    this.iconBackgroundColor = Colors.white24,
    this.onTap,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                  imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.supervised_user_circle_outlined,
                        size: 50, color: Colors.white);
                  },
                )
                    : const Icon(Icons.supervised_user_circle_outlined,
                    size: 50, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, $userName",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      greeting,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (showIcon)
                GestureDetector(
                  onTap: onIconTap,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(iconData, size: AppWidgetSize.iconSM, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}