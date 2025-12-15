import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/round_button.dart';
import '../../../view_models/controller/login/login_view_model.dart';

class LoginButtonWidget extends StatelessWidget {
  final formKey;
  LoginButtonWidget({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final loginVM = Get.put(LoginViewMOdel());
    return Obx(
      () => Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          // width: loginVM.loading.value ? 50 : double.infinity,
          width: loginVM.loading.value ? 50 : MediaQuery.of(context).size.width,
          curve: Curves.easeInOut, // Optional: makes it smoother
          child: RoundButton(
            title: 'login'.tr,
            loading: loginVM.loading.value,
            onPress: () {
              if (formKey.currentState!.validate()) {
                loginVM.loginApi();
              }
            },
            // width: loginVM.loading.value ? 50 : double.infinity,
            // width: double.infinity,
          ),
        ),
      ),
    );
  }
}
