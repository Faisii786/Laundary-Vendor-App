import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/components/custom_appbar.dart';
import '../../res/colors/app_color.dart';
import '../../res/routes/routes_name.dart';
import '../../view_models/controller/create_new_drop_off/update_user_view_model.dart';

class UpdateUserScreen extends StatefulWidget {
  const UpdateUserScreen({super.key});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final UpdateUserController updateUserController =
      Get.put(UpdateUserController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aptController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  bool elevatorStatus = false;
  bool isUpdateSuccessful = false; // ✅ Track if update was successful

  String? userId;

  @override
  void initState() {
    super.initState();
    final user = Get.arguments;

    if (user != null) {
      userId = user.id.toString();
      nameController.text = user.name ?? '';
      phoneController.text = user.mobile ?? '';
      emailController.text = user.email ?? '';
      addressController.text = user.address ?? '';
      aptController.text = user.apt ?? '';
      cityController.text = user.city ?? '';
      stateController.text = user.state ?? '';
      zipCodeController.text = user.zipCode ?? '';
      elevatorStatus = user.elevatorStatus == '1' ? true : false;
    }
  }

  void _updateUser() async {
    if (userId == null || userId!.isEmpty) {
      Get.defaultDialog(
        title: "Error",
        middleText: "User ID is missing. Cannot update user.",
        backgroundColor: Colors.white,
        textConfirm: "OK",
        onConfirm: () {
          Get.back();
        },
      );
      return;
    }

    Map<String, dynamic> updateData = {
      // "user_id": userId,
      "user_id": "test",
      "name": nameController.text,
      "mobile": phoneController.text,
      "email": emailController.text,
      "address": addressController.text,
      "apt": aptController.text,
      "city": cityController.text,
      "state": stateController.text,
      "zip_code": zipCodeController.text,
      "elevator_status": elevatorStatus ? "1" : "0",
    };
    print("🔹 Update Data: $updateData");

    try {
      await updateUserController.updateUser(updateData);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      Navigator.pop(context);
      // ✅ Navigate to Previous Screen after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        // Get.off(() => AddNewDropOff()); // 🔹 Replace with actual previous screen widget
        Get.back();
        //Get.off(() => AddNewDropOff(), transition: Transition.fadeIn);
        //Get.toNamed(RouteName.addNew);
        Get.offNamed(RouteName.addNew);
      });
    } catch (error) {}
  }

  Widget _buildTextField(
      String label, TextEditingController controller, IconData icon,
      {bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          child: TextField(
            controller: controller,
            enabled: isEditable,
            cursorColor: AppColor.primeryBlueColor,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColor.primeryBlueColor),
              labelText: label,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppbar("Update User"),
      // AppBar(
      //   title: const Text(
      //     "Update User",
      //     style: TextStyle(color: AppColor.bgcolor),
      //   ),
      //   backgroundColor: AppColor.primeryBlueColor,
      //   iconTheme: const IconThemeData(color: AppColor.bgcolor),
      // ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField("Name", nameController, Icons.person,
                          isEditable: false),
                      _buildTextField("Phone", phoneController, Icons.phone,
                          isEditable: false),
                      _buildTextField("Email", emailController, Icons.email,
                          isEditable: false),
                      _buildTextField("Street Address", addressController,
                          Icons.location_on),
                      _buildTextField("Apt", aptController, Icons.apartment),
                      _buildTextField(
                          "City", cityController, Icons.location_city),
                      _buildTextField("State", stateController, Icons.flag),
                      _buildTextField("Zip Code", zipCodeController,
                          Icons.local_post_office),

                      const SizedBox(height: 10),

                      // Elevator Switch
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Elevator Available:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Switch(
                            value: elevatorStatus,
                            onChanged: (value) {
                              setState(() {
                                elevatorStatus = value;
                              });
                            },
                            activeThumbColor: AppColor.primeryBlueColor,
                            activeTrackColor:
                                AppColor.primeryBlueColor.withOpacity(0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Align Update Button to Right
              Obx(() {
                return SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primeryBlueColor,
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: updateUserController.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Update",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                );
              }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
