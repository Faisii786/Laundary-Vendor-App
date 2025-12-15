import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/res/colors/app_color.dart';

// Helper for rounded InputDecoration
InputDecoration roundedInputDecoration(String label) => InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );

// Input widgets
class InputNameWidget extends StatelessWidget {
  final TextEditingController controller;
  const InputNameWidget({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // elevation: 2,
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,

      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
        decoration: roundedInputDecoration('name'.tr),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Enter your name';
          if (value.trim().length < 2) return 'Name too short';
          return null;
        },
      ),
    );
  }
}

class InputEmailWidget extends StatelessWidget {
  final TextEditingController controller;
  const InputEmailWidget({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // elevation: 2,
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,

      child: TextFormField(
        controller: controller,
        decoration: roundedInputDecoration('email'.tr),
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Enter your email';
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value.trim())) return 'Invalid email';
          return null;
        },
      ),
    );
  }
}

class InputPhoneWidget extends StatelessWidget {
  final TextEditingController ccodeController;
  final TextEditingController mobileController;
  const InputPhoneWidget({
    required this.ccodeController,
    required this.mobileController,
    super.key,
  });

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
              controller: ccodeController,
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
              controller: mobileController,
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
  }
}

class InputParentCodeWidget extends StatelessWidget {
  final TextEditingController controller;
  const InputParentCodeWidget({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      // elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: TextFormField(
        controller: controller,
        decoration: roundedInputDecoration('parentcode'.tr),
        keyboardType: TextInputType.number,
        // validator: (value) {
        //   if (value == null || value.trim().isEmpty) return 'Enter parent code';
        //   if (!RegExp(r'^\d+$').hasMatch(value.trim())) return 'Invalid code';
        //   return null;
        // },
      ),
    );
  }
}

class InputPasswordWidget extends StatefulWidget {
  final TextEditingController controller;
  const InputPasswordWidget({required this.controller, super.key});

  @override
  State<InputPasswordWidget> createState() => _InputPasswordWidgetState();
}

class _InputPasswordWidgetState extends State<InputPasswordWidget> {
  bool _obscure = true;

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
            controller: widget.controller,
            obscureText: _obscure,
            decoration: roundedInputDecoration('password'.tr).copyWith(
              // Remove errorText from decoration
              errorText: null,
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Enter password';
              if (value.length < 6) return 'Password too short';
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
  }
}

class SignupButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onPressed;
  const SignupButtonWidget(
      {required this.formKey, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primeryBlueColor, // Button background color
          foregroundColor: Colors.white, // Text color
          elevation: 6, // Button elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          shadowColor: Colors.blue.withOpacity(0.3), // Shadow color
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
        child: Text('Sign Up'.tr),
      ),
    );
  }
}
