import 'package:flutter/material.dart';

import '../../../res/colors/app_color.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final List<int>? badgeCounts;

  const HeaderSection({required this.title, this.badgeCounts, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primeryBlueColor, width: 1),
        borderRadius: BorderRadius.circular(8.0),
        color: AppColor.bgcolor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// **Title with flexible width to prevent overflow**
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18, // Reduced font size slightly to fit small screens
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
              overflow: TextOverflow.ellipsis, // Prevents text overflow
              maxLines: 1,
            ),
          ),

          /// **Badges wrapped in `Wrap` to prevent overflow**
          if (badgeCounts != null)
            Wrap(
              spacing: 4.0, // Space between badges
              children: badgeCounts!.map((count) {
                Color badgeColor = count == 1
                    ? Colors.red
                    : count == 4
                        ? Colors.yellow
                        : Colors.green;
                return CircleAvatar(
                  backgroundColor: badgeColor,
                  radius: 12,
                  child: Text(
                    '$count',
                    style: const TextStyle(color: AppColor.bgcolor, fontSize: 12),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
