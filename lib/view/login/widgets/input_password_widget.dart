import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../view_models/controller/login/login_view_model.dart';

InputDecoration roundedInputDecoration(String label) => InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );

class InputPasswordWidget extends StatefulWidget {
  const InputPasswordWidget({super.key});

  @override
  State<InputPasswordWidget> createState() => _InputPasswordWidgetState();
}

class _InputPasswordWidgetState extends State<InputPasswordWidget> {
  final loginVM = Get.put(LoginViewMOdel());

  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Material(
      // elevation: 2,
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: loginVM.passwordController.value,
            obscureText: isObscured,
            decoration: roundedInputDecoration('password'.tr).copyWith(
              // Remove errorText from decoration
              errorText: null,
              suffixIcon: IconButton(
                icon:
                    Icon(isObscured ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => isObscured = !isObscured),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter password';
              // if (value.length < 6) return 'Password too short';
              // if (!RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{6,}$')
              //     .hasMatch(value)) {
              //   return 'Password must contain at least one uppercase letter,\none number, and one special character';
              // }
              return null;
            },
          ),
          // Error text is already handled by TextFormField's validator and decoration.
        ],
      ),
    );
    // return Obx(
    //       () => Container(
    //     padding: EdgeInsets.all(12),
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.circular(12),
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.black12,
    //           blurRadius: 6,
    //           offset: Offset(0, 3),
    //         ),
    //       ],
    //     ),
    //     child: TextFormField(
    //       controller: loginVM.passwordController.value,
    //       focusNode: loginVM.passwordFocusNode.value,
    //       obscureText: isObscured.value, // Toggle based on this value
    //       obscuringCharacter: '*',
    //       style: TextStyle(fontSize: 16),
    //       validator: (value) {
    //         if (value!.isEmpty) {
    //           Utils.snackBar('Password', 'password_hint'.tr);
    //           return 'Password is required';
    //         }
    //         return null;
    //       },
    //       decoration: InputDecoration(
    //         hintText: 'password_hint'.tr,
    //         hintStyle: TextStyle(color: Colors.grey.shade500),
    //         filled: true,
    //         fillColor: Colors.grey.shade100,
    //         border: OutlineInputBorder(
    //           borderRadius: BorderRadius.circular(10),
    //           borderSide: BorderSide.none,
    //         ),
    //         contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    //         prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade600),
    //         suffixIcon: GestureDetector(
    //           onTap: () {
    //             isObscured.value = !isObscured.value; // Toggle password visibility
    //           },
    //           child: Icon(
    //             isObscured.value ? Icons.visibility_off : Icons.visibility,
    //             color: Colors.grey.shade600,
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
