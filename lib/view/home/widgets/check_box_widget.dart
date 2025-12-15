import 'package:flutter/material.dart';

import '../../../res/colors/app_color.dart';

class CheckboxView extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CheckboxView({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged, activeColor: AppColor.primeryBlueColor),
        Text(label, style: const TextStyle(color: Color(0xFF001F54)),),
      ],
    );
  }
}