import 'package:flutter/material.dart';

/// **Reusable Card Widget**
Widget buildCard(List<Widget> children) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    ),
  );
}
