import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/response/status.dart';
import '../../res/colors/app_color.dart';
import '../../view_models/controller/create_new_drop_off/search_user_by_phone_view_model.dart';
import 'create_dropoff_user.dart';
import 'create_drop_off_order_view.dart';
import 'update_user_screen.dart'; // Import Update User screen

class AddNewDropOff extends StatefulWidget {
  const AddNewDropOff({super.key});

  @override
  State<AddNewDropOff> createState() => _AddNewDropOffState();
}

class _AddNewDropOffState extends State<AddNewDropOff> {
  final SearchUserByPhoneController searchUserController =
      Get.put(SearchUserByPhoneController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ever(searchUserController.rxRequestStatus, (status) {
      if (status == Status.ERROR) {
        _showUserNotFoundDialog();
      }
    });
  }

  Widget _buildInfoCard(IconData icon, String label, String? value) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: AppColor.primeryBlueColor),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value ?? 'N/A'),
      ),
    );
  }

  void _showUserNotFoundDialog() {
    Get.defaultDialog(
      title: 'No User Found',
      middleText: 'User does not exist. Do you want to create a new user?',
      backgroundColor: Colors.white,
      confirm: ElevatedButton(
        onPressed: () {
          Get.to(() => const RegisterNewUser());
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primeryBlueColor),
        child: const Text('Create User', style: TextStyle(color: Colors.white)),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back();
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
        child: const Text('Cancel', style: TextStyle(color: Colors.white)),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgcolor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Search by Phone',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        searchUserController.searchUser(searchController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primeryBlueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        "Search",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Display user details or nothing if the user is not found
              Obx(() {
                if (searchUserController.rxRequestStatus.value ==
                    Status.LOADING) {
                  return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 20),
                      child: const CircularProgressIndicator(
                        color: AppColor.primeryBlueColor,
                      ));
                } else if (searchUserController.rxRequestStatus.value ==
                    Status.ERROR) {
                  return const SizedBox();
                } else {
                  var user = searchUserController.user;
                  if (user == null) {
                    // Show placeholder when no search has been performed
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_search,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Search for a Customer',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enter a phone number above to find\nor create a new customer',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _buildInfoCard(Icons.person, 'Name', user.name),
                          _buildInfoCard(Icons.phone, 'Phone', user.mobile),
                          _buildInfoCard(Icons.email, 'Email', user.email),
                          _buildInfoCard(Icons.location_on, 'Street Address',
                              user.address),
                          _buildInfoCard(Icons.apartment, 'Apt', user.apt),
                          _buildInfoCard(
                              Icons.location_city, 'City', user.city),
                          _buildInfoCard(Icons.map, 'State', user.state),
                          _buildInfoCard(
                              Icons.pin_drop, 'Zip Code', user.zipCode),
                          _buildInfoCard(Icons.elevator, 'Elevator',
                              user.elevatorStatus == '1' ? 'Yes' : 'No'),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Row with "Update User" and "Create Dropoff" buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => const UpdateUserScreen(),
                                  arguments: searchUserController.user);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primeryBlueColor,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              "Update User",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => CreateOrderScreen(), arguments: {
                                "user_id": searchUserController.user!.id
                                    .toString(), // ✅ Pass User ID as string
                                "user_data": searchUserController
                                    .user // ✅ Pass full user object (optional)
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .green, // Green color for Create Dropoff button
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text(
                              "Create Dropoff",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
