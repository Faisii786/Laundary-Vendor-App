import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/view_models/controller/login/login_view_model.dart';

class InputPasswordWidget extends StatefulWidget {
  const InputPasswordWidget({super.key});

  @override
  _InputPasswordWidgetState createState() => _InputPasswordWidgetState();
}

class _InputPasswordWidgetState extends State<InputPasswordWidget> {
  final loginVM = Get.put(LoginViewMOdel());
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: loginVM.passwordController.value,
      obscureText: _obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return 'enter_password'.tr;
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'password'.tr,
        prefixIcon: const Icon(Icons.lock, color: Colors.grey), // Replace with your AppColor
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey, // Replace with your AppColor
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}