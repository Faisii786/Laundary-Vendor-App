import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vendor_app/res/colors/app_color.dart';
import 'package:vendor_app/view_models/controller/add_laundry/addLaundry_view_model.dart';

class AddLaundryPage extends StatefulWidget {
  final String laundryUserId;
  final Map<String, Object> signupdata;
  const AddLaundryPage(
      {super.key, required this.signupdata, required this.laundryUserId});

  @override
  State<AddLaundryPage> createState() => _AddLaundryPageState();
}

class _AddLaundryPageState extends State<AddLaundryPage> {
  final AddlaundryViewModel addlaundryviewmodel =
      Get.put(AddlaundryViewModel());
  // final _formKey = GlobalKey<FormState>();
  List<GlobalKey<FormState>> _formKeys = [];

  int _currentStep = 0;
  final int _totalSteps = 8;

  // Controllers
  final TextEditingController _laundromatNameController =
      TextEditingController(text: "John Doe's Laundry");
  final TextEditingController _streetNameController =
      TextEditingController(text: "123 Main St");
  final TextEditingController _cityController =
      TextEditingController(text: "New York");
  final TextEditingController _stateController =
      TextEditingController(text: "NY");
  final TextEditingController _zipCodeController =
      TextEditingController(text: "10001");
  final TextEditingController _additionalAddressController =
      TextEditingController(text: "Suite 100");
  final TextEditingController _contactNameController =
      TextEditingController(text: "John Doe");
  final TextEditingController _contactEmailController =
      TextEditingController(text: "johndoe@example.com");
  final TextEditingController _contactPhoneController =
      TextEditingController(text: "1234567890");
  final TextEditingController _detergentsInfoController =
      TextEditingController(text: "Eco-friendly detergents");
  final TextEditingController _zoneController = TextEditingController(text: "");
  final TextEditingController _manualDeliveryPriceController =
      TextEditingController(text: "50.00");
  final TextEditingController _delayRulesController =
      TextEditingController(text: "delay rule applies after 2 days");
  final TextEditingController _delayFeesController =
      TextEditingController(text: "100.00");

  // Dropdown values
  String _preferredContact = 'email';
  String _laundryStatus = 'active';
  String _selectedzone = 'zones';
  final String _subscriptionType = 'Basic';
  String _deliverySystem = 'pickup';

  // Working days
  final List<String> _allDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  List<String> _selectedWorkingDays = [];

  // Start and end times
  final Map<String, TimeOfDay> _startTimes = {};
  final Map<String, TimeOfDay> _endTimes = {};

  // Laundry period
  List<String> _laundryPeriods = ["Daily"];
  final List<String> _periodOptions = ["Daily", "Weekly", "Monthly"];

  // Products
  final List<String> _productOptions = ['Blanket', 'Comforter', 'Clothes'];
  final Map<String, List<String>> _productVariations = {
    'Blanket': ['Single', 'Double'],
    'Comforter': ['Single', 'Double'],
    'Clothes': [],
  };
  final List<Map<String, String>> _selectedProductVariations = [];
  List<int> _products = [];
  List<TextEditingController> _productBasePriceControllers = [];
  List<TextEditingController> _productAppPriceControllers = [];
  List<TextEditingController> _pickupTimeControllers = [];

  @override
  void initState() {
    super.initState();
    _contactNameController.text = widget.signupdata['name'] as String;
    _contactEmailController.text = widget.signupdata['email'] as String;
    _contactPhoneController.text = widget.signupdata['mobile'] as String;

    _formKeys = List.generate(_totalSteps, (_) => GlobalKey<FormState>());

    _selectedWorkingDays = List.from(_allDays);
    for (var day in _allDays) {
      _startTimes[day] = const TimeOfDay(hour: 08, minute: 00);
      _endTimes[day] = const TimeOfDay(hour: 20, minute: 00);
    }
    _laundryPeriods = ["Daily"];
    _products = [1, 2, 3, 4, 5];
    _productBasePriceControllers = [
      TextEditingController(text: "10.00"),
      TextEditingController(text: "12.00"),
      TextEditingController(text: "10.00"),
      TextEditingController(text: "12.00"),
      TextEditingController(text: "15.00"),
    ];
    _productAppPriceControllers = [
      TextEditingController(text: "15.00"),
      TextEditingController(text: "18.00"),
      TextEditingController(text: "15.00"),
      TextEditingController(text: "18.00"),
      TextEditingController(text: "20.00"),
    ];
    _pickupTimeControllers = [
      TextEditingController(text: "10:00"),
      TextEditingController(text: "14:00"),
    ];
  }

  @override
  void dispose() {
    _laundromatNameController.dispose();
    _streetNameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _additionalAddressController.dispose();
    _contactNameController.dispose();
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    _detergentsInfoController.dispose();
    _zoneController.dispose();
    _manualDeliveryPriceController.dispose();
    _delayRulesController.dispose();
    _delayFeesController.dispose();
    for (var c in _productBasePriceControllers) {
      c.dispose();
    }
    for (var c in _productAppPriceControllers) {
      c.dispose();
    }
    for (var c in _pickupTimeControllers) {
      c.dispose();
    }
    super.dispose();
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
    );
  }

  Widget _buildTimePicker(String day, bool isStart) {
    final time = isStart ? _startTimes[day]! : _endTimes[day]!;
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          setState(() {
            if (isStart) {
              _startTimes[day] = picked;
            } else {
              _endTimes[day] = picked;
            }
          });
        }
      },
      child: InputDecorator(
        decoration: _inputDecoration(isStart ? "Start Time" : "End Time"),
        child: Text(time.format(context)),
      ),
    );
  }

  bool _isProductVariationAdded(String product, String variation) {
    return _selectedProductVariations
        .any((pv) => pv['product'] == product && pv['variation'] == variation);
  }

  bool _canAddProductVariation(String product, String variation) {
    if (!_productVariations.containsKey(product) ||
        _productVariations[product]!.isEmpty) {
      return !_selectedProductVariations.any((pv) => pv['product'] == product);
    }
    return !_isProductVariationAdded(product, variation);
  }

  Widget _buildProductSelector() {
    String? selectedProduct;
    String? selectedVariation;

    return StatefulBuilder(
      builder: (context, setInnerState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Select Product"),
              initialValue: selectedProduct,
              items: _productOptions
                  .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(p),
                      ))
                  .toList(),
              onChanged: (v) {
                setInnerState(() {
                  selectedProduct = v;
                  selectedVariation = null;
                });
              },
            ),
            if (selectedProduct != null &&
                _productVariations[selectedProduct!]!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: DropdownButtonFormField<String>(
                  decoration: _inputDecoration("Select Variation"),
                  initialValue: selectedVariation,
                  items: _productVariations[selectedProduct!]!
                      .where((variation) =>
                          _canAddProductVariation(selectedProduct!, variation))
                      .map((v) => DropdownMenuItem(
                            value: v,
                            child: Text(v),
                          ))
                      .toList(),
                  onChanged: (v) {
                    setInnerState(() {
                      selectedVariation = v;
                    });
                  },
                ),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                if (selectedProduct == null) return;
                String variation = '';
                if (_productVariations[selectedProduct!]!.isNotEmpty) {
                  if (selectedVariation == null) return;
                  variation = selectedVariation!;
                }
                if (!_canAddProductVariation(selectedProduct!, variation)) {
                  return;
                }

                setState(() {
                  _selectedProductVariations.add({
                    'product': selectedProduct!,
                    'variation': variation,
                  });
                  _products.add(_products.length + 1);
                  _productBasePriceControllers
                      .add(TextEditingController(text: "10.00"));
                  _productAppPriceControllers
                      .add(TextEditingController(text: "10.00"));
                });
                setInnerState(() {
                  selectedProduct = null;
                  selectedVariation = null;
                });
              },
              child: const Text("Add Product"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductFieldsWithName(int index) {
    final pv = _selectedProductVariations[index];
    final product = pv['product']!;
    final variation = pv['variation']!;
    String title = product;
    if (variation.isNotEmpty) title += " ($variation)";
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "Remove",
                  onPressed: () {
                    setState(() {
                      _selectedProductVariations.removeAt(index);
                      _products.removeAt(index);
                      _productBasePriceControllers[index].dispose();
                      _productAppPriceControllers[index].dispose();
                      _productBasePriceControllers.removeAt(index);
                      _productAppPriceControllers.removeAt(index);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _productBasePriceControllers[index],
              decoration: _inputDecoration("Base Price"),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.isEmpty) return "Required";
                if (double.tryParse(v) == null) return "Invalid price";
                return null;
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _productAppPriceControllers[index],
              decoration: _inputDecoration("App Price"),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.isEmpty) return "Required";
                if (double.tryParse(v) == null) return "Invalid price";
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  List<int> assignProductCodes(List<Map<String, dynamic>> products) {
    return products.map((product) {
      final name = product['product']?.toString().toLowerCase();
      final variation = product['variation']?.toString().toLowerCase();

      if (name == 'blanket' && variation == 'single') return 1;
      if (name == 'blanket' && variation == 'double') return 2;
      if (name == 'comforter' && variation == 'single') return 3;
      if (name == 'comforter' && variation == 'double') return 4;
      if (name == 'clothes') return 5;

      return 0; // Default if no condition matches
    }).toList();
  }

  void _submit() {
    List<int> codes = assignProductCodes(_selectedProductVariations);
    print("Zone: $_selectedzone");
    Map<String, dynamic> requestData = {
      "laundry_user_id": widget.laundryUserId,
      'laundromat_name': _laundromatNameController.text,
      'street_name': _streetNameController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'zip_code': _zipCodeController.text,
      'additional_address': _additionalAddressController.text,
      'contact_name': _contactNameController.text,
      'contact_email': _contactEmailController.text,
      'contact_phone': _contactPhoneController.text,
      'preferred_contact': _preferredContact,
      'laundry_status': _laundryStatus,
      'subscription_type': "Basic",
      'detergents_info': _detergentsInfoController.text,
      'zone': _selectedzone,
      'delivery_system': _deliverySystem,
      'manual_delivery_price': _manualDeliveryPriceController.text,
      'delay_rules': _delayRulesController.text,
      'delay_fees': _delayFeesController.text,
      'working_days': _selectedWorkingDays,
      'start_time': {
        for (var day in _selectedWorkingDays)
          day: _startTimes[day]?.format(context),
      },
      'end_time': {
        for (var day in _selectedWorkingDays)
          day: _endTimes[day]?.format(context),
      },
      'laundry_period': _laundryPeriods,
      'product': codes,
      'product_base_price':
          List.generate(_productBasePriceControllers.length, (i) {
        return double.parse(_productBasePriceControllers[i].text);
      }),
      'product_app_price':
          List.generate(_productBasePriceControllers.length, (i) {
        return double.parse(_productAppPriceControllers[i].text);
      }),
      // 'products': List.generate(_selectedProductVariations.length, (i) {
      //   final pv = _selectedProductVariations[i];
      //   return {
      //     'product': pv['product'],
      //     'variation': pv['variation'],
      //     'base_price': _productBasePriceControllers[i].text,
      //     'app_price': _productAppPriceControllers[i].text,
      //   };
      // }),
    };

    print("requestData: $requestData");

    addlaundryviewmodel.addlaundryApi(requestData);

    // Get.snackbar(
    //   'Success',
    //   'Laundry added successfully!',
    //   backgroundColor: AppColor.onoffGreenColor2,
    //   colorText: Colors.white,
    //   snackPosition: SnackPosition.BOTTOM,
    //   margin: const EdgeInsets.symmetric(vertical: 10),
    //   duration: const Duration(seconds: 3),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text('Laundry added successfully!')),
    // );
    // }
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Basic Info'),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKeys[0],
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              ),
              TextFormField(
                controller: _laundromatNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("Laundry Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _streetNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("Street Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cityController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("City"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _stateController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("State"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _zipCodeController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("Zip Code"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _additionalAddressController,
                decoration: _inputDecoration("Additional Address"),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Contact'),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKeys[1],
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              ),
              TextFormField(
                controller: _contactNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("Contact Name"),
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactEmailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("Contact Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Required";
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(v)) return "Invalid email";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _contactPhoneController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("Contact Phone"),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) => v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _preferredContact,
                decoration: _inputDecoration("Preferred Contact"),
                items: ['email', 'phone']
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(StringCasingExtension(e).capitalize())))
                    .toList(),
                onChanged: (v) => setState(() => _preferredContact = v!),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Laundry Details'),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKeys[2],
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              ),
              DropdownButtonFormField<String>(
                initialValue: _laundryStatus,
                decoration: _inputDecoration("Laundry Status"),
                items: ['active', 'inactive']
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(StringCasingExtension(e).capitalize())))
                    .toList(),
                onChanged: (v) => setState(() => _laundryStatus = v!),
              ),
              const SizedBox(height: 12),
              // DropdownButtonFormField<String>(
              //   initialValue: _subscriptionType,
              //   decoration: _inputDecoration("Subscription Type"),
              //   items: ['monthly', 'yearly']
              //       .map((e) => DropdownMenuItem<String>(
              //           value: e,
              //           child: Text(StringCasingExtension(e).capitalize())))
              //       .toList(),
              //   onChanged: (v) {
              //     if (v != null) {
              //       setState(() => _subscriptionType = v);
              //     }
              //   },
              // ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _detergentsInfoController,
                decoration: _inputDecoration("Detergents Info"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _deliverySystem,
                decoration: _inputDecoration("Delivery System"),
                items: ['pickup', 'dropoff', 'pickup & delivery']
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(StringCasingExtension(e).capitalize())))
                    .toList(),
                onChanged: (v) => setState(() => _deliverySystem = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _manualDeliveryPriceController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("Manual Delivery Price"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Required";
                  if (double.tryParse(v) == null) return "Invalid price";
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _delayRulesController,
                decoration: _inputDecoration("Delay Rules"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _delayFeesController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: _inputDecoration("Delay Fees"),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Required";
                  if (double.tryParse(v) == null) return "Invalid fee";
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Working Days'),
        isActive: _currentStep >= 3,
        state: _currentStep > 3 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKeys[3],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: InputDecorator(
                  decoration: _inputDecoration("Working Days"),
                  child: Wrap(
                    spacing: 8,
                    children: _allDays.map((day) {
                      return FilterChip(
                        label: Text(day),
                        selected: _selectedWorkingDays.contains(day),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedWorkingDays.add(day);
                            } else {
                              _selectedWorkingDays.remove(day);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ..._selectedWorkingDays.map((day) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(child: Text(day)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTimePicker(day, true)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTimePicker(day, false)),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Laundry Period'),
        isActive: _currentStep >= 4,
        state: _currentStep > 4 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKeys[4],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: InputDecorator(
              decoration: _inputDecoration("Laundry Period"),
              child: Wrap(
                spacing: 8,
                children: _periodOptions.map((period) {
                  return FilterChip(
                    label: Text(period),
                    selected: _laundryPeriods.contains(period),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _laundryPeriods.add(period);
                        } else {
                          _laundryPeriods.remove(period);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
      Step(
        title: const Text('Products'),
        isActive: _currentStep >= 5,
        state: _currentStep > 5 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKeys[5],
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              ),
              TextFormField(
                validator: (_) {
                  if (_selectedProductVariations.isEmpty) {
                    return 'Please add at least one product.';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // This makes the field invisible
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 0),
              ),
              _buildProductSelector(),
              const SizedBox(height: 12),
              ...List.generate(
                _selectedProductVariations.length,
                (i) => _buildProductFieldsWithName(i),
              ),
              const SizedBox(height: 12),
              TextFormField(
                validator: (_) {
                  if (_selectedProductVariations.isEmpty) {
                    return 'Please add at least one product.';
                  }
                  if (_productBasePriceControllers
                          .every((c) => c.text.isEmpty) ||
                      _productAppPriceControllers
                          .every((c) => c.text.isEmpty)) {
                    return 'Please enter base prices and app price for all products.';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // This makes the field invisible
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 0),
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Zone'),
        isActive: _currentStep >= 6,
        state: _currentStep > 6 ? StepState.complete : StepState.indexed,
        content: Form(
          key: _formKeys[6],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: Obx(
                  () => DropdownButtonFormField<String>(
                    decoration: _inputDecoration("Select Zone"),
                    hint: const Text("Select Zone"),
                    initialValue: addlaundryviewmodel.zonesList
                            .any((e) => e['id'].toString() == _selectedzone)
                        ? _selectedzone
                        : null,
                    items: addlaundryviewmodel.zonesList.map((zone) {
                      final id = zone['id'].toString();
                      final title = zone['title'].toString();
                      return DropdownMenuItem<String>(
                        value:
                            id, // This is what will be returned when selected
                        child: Text(StringCasingExtension(title)
                            .capitalize()), // This is what is shown
                      );
                    }).toList(),
                    onChanged: (selectedId) {
                      setState(() {
                        _selectedzone = selectedId!;
                      });
                    },
                  ),

                  // DropdownButtonFormField<String>(
                  //   decoration: _inputDecoration("Select Zone"),
                  //   hint: const Text("Select Zone"),
                  //   value: addlaundryviewmodel.zonesList.isEmpty ||
                  //           !addlaundryviewmodel.zonesList
                  //               .map((e) => e['title'].toString())
                  //               .contains(_selectedzone)
                  //       ? null
                  //       : _selectedzone,
                  //   items: addlaundryviewmodel.zonesList
                  //       .map((e) => e['title'].toString())
                  //       .toSet()
                  //       .map((title) => DropdownMenuItem<String>(
                  //             value: title,
                  //             child: Text(
                  //                 StringCasingExtension(title).capitalize()),
                  //           ))
                  //       .toList(),
                  //   onChanged: (v) {
                  //     setState(() {
                  //       _selectedzone = v!;
                  //     });
                  //   },
                  // ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                validator: (_) {
                  if (_selectedzone.isEmpty || _selectedzone == 'zones') {
                    return 'Select zone where your laundry is.';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                // This makes the field invisible
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(fontSize: 0),
              ),
            ],
          ),
        ),
      ),
      Step(
        title: const Text('Review & Submit'),
        isActive: _currentStep >= 7,
        state: _currentStep == 7 ? StepState.editing : StepState.indexed,
        content: SingleChildScrollView(
          child: Form(
            key: _formKeys[7],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Please review your details before submitting:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                _buildReviewRow(
                    "Laundromat Name", _laundromatNameController.text),
                _buildReviewRow("Street Name", _streetNameController.text),
                _buildReviewRow("City", _cityController.text),
                _buildReviewRow("State", _stateController.text),
                _buildReviewRow("Zip Code", _zipCodeController.text),
                _buildReviewRow(
                    "Additional Address", _additionalAddressController.text),
                const Divider(),
                _buildReviewRow("Contact Name", _contactNameController.text),
                _buildReviewRow("Contact Email", _contactEmailController.text),
                _buildReviewRow("Contact Phone", _contactPhoneController.text),
                _buildReviewRow("Preferred Contact",
                    StringCasingExtension(_preferredContact).capitalize()),
                const Divider(),
                _buildReviewRow("Laundry Status",
                    StringCasingExtension(_laundryStatus).capitalize()),
                _buildReviewRow("Subscription Type",
                    StringCasingExtension(_subscriptionType).capitalize()),
                _buildReviewRow(
                    "Detergents Info", _detergentsInfoController.text),
                _buildReviewRow("Delivery System",
                    StringCasingExtension(_deliverySystem).capitalize()),
                _buildReviewRow("Manual Delivery Price",
                    _manualDeliveryPriceController.text),
                _buildReviewRow("Delay Rules", _delayRulesController.text),
                _buildReviewRow("Delay Fees", _delayFeesController.text),
                const Divider(),
                _buildReviewRow(
                    "Working Days", _selectedWorkingDays.join(", ")),
                ..._selectedWorkingDays.map((day) => Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 4),
                      child: Text(
                          "$day: ${_startTimes[day]?.format(context) ?? ""} - ${_endTimes[day]?.format(context) ?? ""}",
                          style: const TextStyle(fontSize: 14)),
                    )),
                const Divider(),
                _buildReviewRow("Laundry Period", _laundryPeriods.join(", ")),
                const Divider(),
                const Text("Products:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...List.generate(_selectedProductVariations.length, (i) {
                  final pv = _selectedProductVariations[i];
                  final product = pv['product']!;
                  final variation = pv['variation']!;
                  String title = product;
                  if (variation.isNotEmpty) title += " ($variation)";
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: Text(
                      "$title | Base Price: ${_productBasePriceControllers[i].text} | App Price: ${_productAppPriceControllers[i].text}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }),
                const Divider(),
                _buildReviewRow("Zone", _selectedzone),
                // const SizedBox(height: 24),
                // SizedBox(
                //   width: double.infinity,
                //   height: 48,
                //   child: ElevatedButton(
                //     onPressed: _submit,
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColor.primeryBlueColor,
                //       foregroundColor: Colors.white,
                //       elevation: 6,
                //       shadowColor: Colors.blue.withOpacity(0.3),
                //       textStyle: const TextStyle(
                //           fontSize: 18, fontWeight: FontWeight.bold),
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(16)),
                //     ),
                //     child:
                //         const Text("Add Laundry", style: TextStyle(fontSize: 18)),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColor.primeryBlueColor,
        title: const Text('Add Laundry'),
        centerTitle: true,
      ),
      body: Obx(
        () => Stack(children: [
          AbsorbPointer(
            absorbing: addlaundryviewmodel.loading.value,
            child: Opacity(
              opacity: addlaundryviewmodel.loading.value
                  ? 0.5
                  : 1.0, // Optional fade effect
              child: Form(
                // key: _formKeys,
                child: Stepper(
                  type: StepperType.vertical,
                  onStepTapped: (value) => setState(() => _currentStep = value),
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_formKeys[_currentStep].currentState?.validate() ??
                        false) {
                      if (_currentStep < _buildSteps().length - 1) {
                        setState(() => _currentStep += 1);
                      } else {
                        _submit();
                      }
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep -= 1);
                    }
                  },
                  steps: _buildSteps(),
                  controlsBuilder: (context, details) {
                    return Row(
                      children: <Widget>[
                        if (_currentStep < _buildSteps().length - 1)
                          ElevatedButton(
                            onPressed: details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primeryBlueColor,
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shadowColor: Colors.blue.withOpacity(0.3),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Next'),
                          ),
                        if (_currentStep == _buildSteps().length - 1)
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.primeryBlueColor,
                              foregroundColor: Colors.white,
                              elevation: 6,
                              shadowColor: Colors.blue.withOpacity(0.3),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Submit'),
                          ),
                        if (_currentStep > 0)
                          TextButton(
                            onPressed: details.onStepCancel,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColor.primeryBlueColor,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Back'),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // Loading overlay
          if (addlaundryviewmodel.loading.value)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ]),
      ),
    );
  }
}

Widget _buildReviewRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.normal),
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
      ],
    ),
  );
}

extension StringCasingExtension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
