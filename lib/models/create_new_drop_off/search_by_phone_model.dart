class SeachUserByPNModel {
  String? responseCode;
  String? result;
  String? responseMsg;
  User? user;

  SeachUserByPNModel({this.responseCode, this.result, this.responseMsg, this.user});

  SeachUserByPNModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
    user = json['User'] != null ? User.fromJson(json['User']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    if (user != null) {
      data['User'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? laundryId; // ✅ Changed from `Null?` to `String?`
  String? name;
  String? email;
  String? ccode;
  String? mobile;
  int? refercode;
  int? parentcode; // ✅ Changed from `Null?` to `int?`
  String? registartionDate;
  int? status;
  int? wallet;
  String? address;
  String? landmark;
  String? rInstruction;
  String? aType;
  double? aLat; // ✅ Convert to double
  double? aLong;
  String? floor;
  String? elevatorStatus;
  String? apt;
  String? zipCode;
  String? paymentMethod;
  String? country;
  String? city;
  String? state;

  User({
    this.id,
    this.laundryId,
    this.name,
    this.email,
    this.ccode,
    this.mobile,
    this.refercode,
    this.parentcode,
    this.registartionDate,
    this.status,
    this.wallet,
    this.address,
    this.landmark,
    this.rInstruction,
    this.aType,
    this.aLat,
    this.aLong,
    this.floor,
    this.elevatorStatus,
    this.apt,
    this.zipCode,
    this.paymentMethod,
    this.country,
    this.city,
    this.state,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    laundryId = json['laundry_id']?.toString(); // ✅ Ensure it's always a string
    name = json['name'];
    email = json['email'];
    ccode = json['ccode'];
    mobile = json['mobile'];
    refercode = json['refercode'] != null ? int.tryParse(json['refercode'].toString()) : null;
    parentcode = json['parentcode'] != null ? int.tryParse(json['parentcode'].toString()) : null;
    registartionDate = json['registartion_date'];
    status = json['status'];
    wallet = json['wallet'];
    address = json['address'];
    landmark = json['landmark'];
    rInstruction = json['r_instruction'];
    aType = json['a_type'];
    aLat = json['a_lat'] != null ? double.tryParse(json['a_lat'].toString()) : null;
    aLong = json['a_long'] != null ? double.tryParse(json['a_long'].toString()) : null;
    floor = json['floor'];
    elevatorStatus = json['elevator_status'];
    apt = json['apt'];
    zipCode = json['zip_code'];
    paymentMethod = json['payment_method'];
    city = json['city'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['laundry_id'] = laundryId;
    data['name'] = name;
    data['email'] = email;
    data['ccode'] = ccode;
    data['mobile'] = mobile;
    data['refercode'] = refercode;
    data['parentcode'] = parentcode;
    data['registartion_date'] = registartionDate;
    data['status'] = status;
    data['wallet'] = wallet;
    data['address'] = address;
    data['landmark'] = landmark;
    data['r_instruction'] = rInstruction;
    data['a_type'] = aType;
    data['a_lat'] = aLat;
    data['a_long'] = aLong;
    data['floor'] = floor;
    data['elevator_status'] = elevatorStatus;
    data['apt'] = apt;
    data['zip_code'] = zipCode;
    data['payment_method'] = paymentMethod;
    data['country'] = country;
    data['city'] = city;
    data['state'] = state;
    return data;
  }
}
