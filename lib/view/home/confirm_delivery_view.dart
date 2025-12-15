import 'package:flutter/material.dart';
import 'package:vendor_app/res/colors/app_color.dart';
import 'package:vendor_app/view/home/widgets/check_box_widget.dart';
import 'package:vendor_app/view/home/widgets/drop_down_widget.dart';
import 'package:vendor_app/view/home/widgets/text_fields_widget.dart';

class ConfirmDelivery extends StatefulWidget {
  const ConfirmDelivery({super.key});

  @override
  State<ConfirmDelivery> createState() => _AddNewDropOffState();
}

class _AddNewDropOffState extends State<ConfirmDelivery> {
  bool isHouseChecked = false;
  bool isBuildingChecked = false;
  bool hasElevator = false;
  String? selectedDeliveryTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: AppColor.primeryBlueColor),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                      child: const Text(
                        "Confirm Delivery",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Receipt No and Search Client ID Row
              const Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFieldView(label: 'Receipt No'),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: TextFieldView(label: 'Search client ID'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name and Phone Row
              const Row(
                children: [
                  Expanded(child: TextFieldView(label: 'Name')),
                  SizedBox(width: 16),
                  Expanded(child: TextFieldView(label: 'Phone')),
                ],
              ),
              const SizedBox(height: 16),

              // Street Address
              const TextFieldView(label: 'Street Address'),
              const SizedBox(height: 16),

              // Apt and City Row
              const Row(
                children: [
                  Expanded(child: TextFieldView(label: 'Apt')),
                  SizedBox(width: 16),
                  Expanded(child: TextFieldView(label: 'City')),
                ],
              ),
              const SizedBox(height: 16),

              // State and Zip Code Row
              const Row(
                children: [
                  Expanded(child: TextFieldView(label: 'State')),
                  SizedBox(width: 16),
                  Expanded(child: TextFieldView(label: 'Zip Code')),
                ],
              ),
              const SizedBox(height: 16),

              // House and Building Checkboxes
              Row(
                children: [
                  CheckboxView(
                    label: 'House',
                    value: isHouseChecked,
                    onChanged: (value) {
                      setState(() {
                        isHouseChecked = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  CheckboxView(
                    label: 'Building',
                    value: isBuildingChecked,
                    onChanged: (value) {
                      setState(() {
                        isBuildingChecked = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Elevator Checkboxes
              Row(
                children: [
                  const Text("Elevator: "),
                  CheckboxView(
                    label: 'Yes',
                    value: hasElevator,
                    onChanged: (value) {
                      setState(() {
                        hasElevator = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 16),
                  CheckboxView(
                    label: 'No',
                    value: !hasElevator,
                    onChanged: (value) {
                      setState(() {
                        hasElevator = !value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Total lb and No of Bags Row
              const Row(
                children: [
                  Expanded(child: TextFieldView(label: 'Total lb')),
                  SizedBox(width: 16),
                  Expanded(child: TextFieldView(label: 'No of bags')),
                ],
              ),
              const SizedBox(height: 16),

              // Price Field
              const TextFieldView(label: 'Price'),
              const SizedBox(height: 16),

              // Delivery Time Dropdown
              DropdownView(
                label: 'Delivery Time',
                value: selectedDeliveryTime,
                items: const ['Morning', 'Afternoon', 'Evening'],
                onChanged: (value) {
                  setState(() {
                    selectedDeliveryTime = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Add Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primeryBlueColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    minimumSize: const Size(150, 60),
                  ),
                  child: const Text(
                    'Update Order',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



