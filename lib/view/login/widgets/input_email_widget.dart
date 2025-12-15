// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:get/get_core/src/get_main.dart';
// //
// // import '../../../utils/utils.dart';
// // import '../../../view_models/controller/login/login_view_model.dart';
// //
// // class InputEmailWidget extends StatelessWidget {
// //   final loginVM = Get.put(LoginViewMOdel());
// //    InputEmailWidget({super.key});
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return TextFormField(
// //       controller: loginVM.emailController.value,
// //       focusNode: loginVM.emailFocusNode.value,
// //       validator: (value){
// //         if(value!.isEmpty){
// //           Utils.snackBar('Email', 'email_hint'.tr);
// //         }
// //       },
// //       onFieldSubmitted: (value){
// //         Utils.fieldFocusChange(context, loginVM.emailFocusNode.value, loginVM.passwordFocusNode.value);
// //       },
// //       decoration: InputDecoration(
// //         hintText: 'email_hint'.tr,
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //       ),
// //     );
// //   }
// // }
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

class InputPhoneWidget extends StatelessWidget {
  final loginVM = Get.put(LoginViewMOdel());

  InputPhoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          // elevation: 2,
          borderRadius: BorderRadius.circular(16),
          color: Colors.transparent,

          child: SizedBox(
            width: 70,
            child: TextFormField(
              controller: loginVM.ccodeController.value,
              decoration: roundedInputDecoration('ccode'.tr),
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Code' : null,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Material(
            // elevation: 2,
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,

            child: TextFormField(
              controller: loginVM.phoneController.value,
              decoration: roundedInputDecoration('mobile'.tr),
              keyboardType: TextInputType.phone,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter mobile';
                }
                if (!RegExp(r'^\d{10,10}$').hasMatch(value.trim())) {
                  return 'Invalid phone';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
    // return Container(
    //   padding: EdgeInsets.all(12),
    //   decoration: BoxDecoration(
    //     color: AppColor.bgcolor,
    //     borderRadius: BorderRadius.circular(12),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black12,
    //         blurRadius: 6,
    //         offset: Offset(0, 3),
    //       ),
    //     ],
    //   ),
    //   child: Row(
    //     children: [
    //       Container(
    //         width: 100, // Adjust width for country code input
    //         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    //         // decoration: BoxDecoration(
    //         //   color: Colors.grey.shade200,
    //         //   borderRadius: BorderRadius.circular(10),
    //         // ),
    //         child: TextFormField(
    //           controller: loginVM.ccodeController.value,
    //           focusNode: loginVM.ccodeFocusNode.value,
    //           keyboardType: TextInputType.phone,
    //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //           decoration: InputDecoration(
    //             hintText: '+92',
    //             hintStyle: TextStyle(color: Colors.grey.shade500),
    //             filled: true,
    //             fillColor: Colors.grey.shade100,
    //             border: InputBorder.none,
    //             // suffixIcon: Icon(Icons.phone_android_outlined, color: Colors.black54),
    //           ),
    //           onTap: () {
    //             if (loginVM.ccodeController.value.text.isEmpty) {
    //               loginVM.ccodeController.value.text =
    //                   "+92"; // Default country code
    //             }
    //           },
    //         ),
    //       ),
    //       SizedBox(width: 12),
    //       Expanded(
    //         child: TextFormField(
    //           controller: loginVM.phoneController.value,
    //           focusNode: loginVM.phoneFocusNode.value,
    //           keyboardType: TextInputType.phone,
    //           style: TextStyle(fontSize: 16),
    //           validator: (value) {
    //             if (value!.isEmpty) {
    //               Utils.snackBar(
    //                   'Phone Number', 'Please enter your phone number.');
    //               return 'Phone number is required';
    //             }
    //             return null;
    //           },
    //           onFieldSubmitted: (value) {
    //             Utils.fieldFocusChange(context, loginVM.phoneFocusNode.value,
    //                 loginVM.passwordFocusNode.value);
    //           },
    //           decoration: InputDecoration(
    //             hintText: 'Enter your phone number',
    //             hintStyle: TextStyle(color: Colors.grey.shade500),
    //             filled: true,
    //             fillColor: Colors.grey.shade100,
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(10),
    //               borderSide: BorderSide.none,
    //             ),
    //             contentPadding:
    //                 EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    //             suffixIcon:
    //                 Icon(Icons.phone_android_outlined, color: Colors.black54),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
