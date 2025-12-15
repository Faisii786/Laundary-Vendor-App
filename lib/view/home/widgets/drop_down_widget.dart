import 'package:flutter/material.dart';

import '../../../res/colors/app_color.dart';

class DropdownView extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownView({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.primeryBlueColor, width: 2.0), // Navy blue border
        ),
      ),
      dropdownColor: AppColor.bgcolor, // Dropdown menu background color
      style: const TextStyle(
        color: AppColor.primeryBlueColor, // Navy blue selected text
        fontSize: 16,
      ),
      initialValue: value,
      items: items
          .map((item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            color: AppColor.primeryBlueColor, // Navy blue item text
          ),
        ),
      ))
          .toList(),
      onChanged: onChanged,
    );
  }
}