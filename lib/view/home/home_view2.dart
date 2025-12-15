import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendor_app/res/colors/app_color.dart';
import 'package:vendor_app/view/login/login_view.dart';
import 'package:vendor_app/view_models/controller/add_laundry/addLaundry_view_model.dart';
import 'package:vendor_app/view_models/controller/user_preference/user_preference_view_model.dart';

class HomeView2 extends StatefulWidget {
  const HomeView2({super.key});

  @override
  State<HomeView2> createState() => _HomeView2State();
}

class _HomeView2State extends State<HomeView2> {
  final AddlaundryViewModel addlaundryviewmodel =
      Get.put(AddlaundryViewModel());
  final UserPreference userPreference = UserPreference();

  void _onAddLaundry(BuildContext context) {
    // TODO: Implement add laundry functionality
    // addlaundryviewmodel.fetchzonesApi();
    // Get.to(() => AddLaundryPage());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Laundry pressed')),
    );
  }

  void _onLogout(BuildContext context) {
    // TODO: Implement logout functionality
    Navigator.pop(context);
    // _tabController.animateTo(0);

    userPreference.removeUser(); // Assuming you have this method implemented
    // Navigate to Login Screen
    // Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => LoginView()));
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginView()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primeryBlueColor,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        title: const Text('Vendor Home'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.logout),
            onPressed: () => _onLogout(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            const Center(
              child: Text(
                'To get started, first create a laundry.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_business),
              label: const Text('Add Laundry'),
              onPressed: () => _onAddLaundry(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor:
                    AppColor.primeryBlueColor, // Set background color
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
