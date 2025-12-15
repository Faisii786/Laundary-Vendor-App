import 'package:flutter/material.dart';

/// **Row for Displaying Order Details**
Widget buildRow(String title, String value, {Color? valueColor}) {
  // title text
  final titlecontainer = Text(
    title,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  );
// value container
  final valuecontainer = Container(
    //container only used for status box with color
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    decoration: BoxDecoration(
      color: valueColor?.withValues().withAlpha(60),
      borderRadius: BorderRadius.circular(8),
    ),
    // text for showing value
    child: Text(
      value,
      style: TextStyle(fontSize: 16, color: valueColor ?? Colors.black54),
      softWrap: true,
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.right,
    ),
  );
  // returning row with data
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // condition to visualize address properly
        title.toLowerCase().contains('address')
            ? titlecontainer
            : Expanded(
                child: titlecontainer,
              ),
        // condition to visualize address properly
        title.toLowerCase().contains('address')
            ? Expanded(
                child: valuecontainer,
              )
            : valuecontainer,
      ],
    ),
  );
}
