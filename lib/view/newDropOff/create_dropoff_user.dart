import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../res/colors/app_color.dart';
import '../../view_models/controller/create_new_drop_off/register_customer_view_model.dart';
import '../../view_models/services/location_service.dart';

class RegisterNewUser extends StatefulWidget {
  const RegisterNewUser({super.key});

  @override
  State<RegisterNewUser> createState() => _RegisterNewUserState();
}

class _RegisterNewUserState extends State<RegisterNewUser> {
  final RegisterCustomerViewModel registerController = Get.put(RegisterCustomerViewModel());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool hasElevator = false;
  String selectedAptType = "Home";
  String selectedCountryCode = "+1";
  bool _obscurePassword = true;

  // Location dropdown variables
  String? selectedCountryId;
  String? selectedStateId;
  String? selectedCityId;
  List<Map<String, dynamic>> countries = [];
  List<Map<String, dynamic>> states = [];
  List<Map<String, dynamic>> cities = [];
  bool isStateEnabled = false;
  bool isCityEnabled = false;

  final List<String> countryCodes = ["+1", "+44", "+91", "+92", "+971"];

  @override
  void initState() {
    super.initState();
    _loadLocationData();
  }

  Future<void> _loadLocationData() async {
    await LocationService.initialize();
    countries = LocationService.getCountries();
    setState(() {});
  }

  void _onCountryChanged(String? newValue) {
    setState(() {
      selectedCountryId = newValue;
      selectedStateId = null;
      selectedCityId = null;
      states = newValue != null
          ? LocationService.getStatesByCountry(newValue)
          : [];
      isStateEnabled = newValue != null;
      isCityEnabled = false;
      registerController.countryIdController.text = newValue ?? '';
      registerController.stateIdController.text = '';
      registerController.cityIdController.text = '';
    });
  }

  void _onStateChanged(String? newValue) {
    setState(() {
      selectedStateId = newValue;
      selectedCityId = null;
      cities = newValue != null
          ? LocationService.getCitiesByState(newValue)
          : [];
      isCityEnabled = newValue != null;
      registerController.stateIdController.text = newValue ?? '';
      registerController.cityIdController.text = '';
    });
  }

  void _onCityChanged(String? newValue) {
    setState(() {
      selectedCityId = newValue;
      registerController.cityIdController.text = newValue ?? '';
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      registerController.registerCustomer();
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {bool isNumber = false, bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      obscureText: isPassword ? _obscurePassword : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        )
            : null,
      ),
      validator: (value) => value == null || value.isEmpty ? "Required field" : null,
    );
  }

  Widget _buildLocationDropdown({
    required String label,
    required List<Map<String, dynamic>> items,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
    bool enabled = true,
    required IconData icon,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: selectedValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: !enabled,
        fillColor: Colors.grey.shade100,
      ),
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text(
            'Select $label',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ),
        ...items.map((item) {
          return DropdownMenuItem<String>(
            value: item['id'].toString(),
            child: Text(item['name'] ?? ''),
          );
        }),
      ],
      onChanged: enabled ? onChanged : null,
      validator: (value) => value == null ? "Required field" : null,
      style: TextStyle(
        color: enabled ? Colors.black : Colors.grey.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register New User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Obx(() => registerController.loading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView(
            children: [
              _buildTextField("Name", registerController.nameController, Icons.person),
              const SizedBox(height: 12),

              // Phone Number with Country Code
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCountryCode,
                        items: countryCodes.map((code) {
                          return DropdownMenuItem<String>(
                            value: code,
                            child: Text(code),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCountryCode = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                        "Phone",
                        registerController.phoneController,
                        Icons.phone,
                        isNumber: true
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _buildTextField("Email", registerController.emailController, Icons.email),
              const SizedBox(height: 12),
              _buildTextField(
                  "Password",
                  registerController.passwordController,
                  Icons.lock,
                  isPassword: true
              ),
              const SizedBox(height: 12),
              _buildTextField(
                  "Street Address",
                  registerController.addressController,
                  Icons.location_on
              ),
              const SizedBox(height: 12),

              // APT Type Dropdown
              DropdownButtonFormField<String>(
                initialValue: selectedAptType,
                decoration: InputDecoration(
                  labelText: "Apt Type",
                  prefixIcon: const Icon(Icons.apartment),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                items: ["Home", "Building"].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedAptType = newValue!;
                  });
                  registerController.aTypeController.text = selectedAptType;
                },
                validator: (value) => value == null ? "Required field" : null,
              ),
              const SizedBox(height: 12),

              // Country Dropdown
              _buildLocationDropdown(
                label: 'Country',
                items: countries,
                selectedValue: selectedCountryId,
                onChanged: _onCountryChanged,
                enabled: true,
                icon: Icons.public,
              ),
              const SizedBox(height: 12),

              // State Dropdown
              _buildLocationDropdown(
                label: 'State',
                items: states,
                selectedValue: selectedStateId,
                onChanged: _onStateChanged,
                enabled: isStateEnabled,
                icon: Icons.map,
              ),
              const SizedBox(height: 12),

              // City Dropdown
              _buildLocationDropdown(
                label: 'City',
                items: cities,
                selectedValue: selectedCityId,
                onChanged: _onCityChanged,
                enabled: isCityEnabled,
                icon: Icons.location_city,
              ),
              const SizedBox(height: 12),

              _buildTextField(
                  "Zip Code",
                  registerController.zipCodeController,
                  Icons.pin_drop,
                  isNumber: true
              ),
              const SizedBox(height: 12),

              // Elevator Checkbox
              Row(
                children: [
                  Checkbox(
                    value: hasElevator,
                    onChanged: (value) {
                      setState(() {
                        hasElevator = value!;
                      });
                      registerController.elevatorStatusController.text =
                      hasElevator ? "1" : "0";
                    },
                  ),
                  const Text("Elevator Available"),
                ],
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primeryBlueColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                    "Create User",
                    style: TextStyle(color: Colors.white)
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}