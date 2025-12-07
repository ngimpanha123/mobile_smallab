import 'package:flutter/material.dart';

class CustomAppBarLeftLogo extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarLeftLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: Colors.white,
        child: Row(
          children: [
            // ------- LEFT: LOGO -------
            SizedBox(
              height: 40,
              child: Image.asset(
                "assets/logo/logo.png",
                fit: BoxFit.contain,
              ),
            ),

            const Spacer(), // pushes the icon group to the far right

            // ------- RIGHT ICON GROUP -------
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Notification with red badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        size: 20,
                        color: Colors.black54,
                      ),
                    ),
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 12),

                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
