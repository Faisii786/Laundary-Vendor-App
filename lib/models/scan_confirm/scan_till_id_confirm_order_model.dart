class UserByTillIDModel {
  String? responseCode;
  String? result;
  String? responseMsg;
  OrderDetails? orderDetails;

  UserByTillIDModel({
    this.responseCode,
    this.result,
    this.responseMsg,
    this.orderDetails,
  });

  UserByTillIDModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
    orderDetails = json['OrderDetails'] != null
        ? OrderDetails.fromJson(json['OrderDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    if (orderDetails != null) {
      data['OrderDetails'] = orderDetails!.toJson();
    }
    return data;
  }
}

class OrderDetails {
  int? orderId;
  String? orderQId;
  int? laundryId;
  String? orderType;
  String? orderTime;
  String? orderStatus;
  String? orderPrice;
  String? totalBags;
  String? weight;
  String? createdAt;
  List<Products>? products;
  Customer? customer;
  CustomerAddress? customerAddress;
  LaundromatDetails? laundromatDetails;

  OrderDetails({
    this.orderId,
    this.orderQId,
    this.laundryId,
    this.orderType,
    this.orderTime,
    this.orderStatus,
    this.orderPrice,
    this.totalBags,
    this.weight,
    this.createdAt,
    this.products,
    this.customer,
    this.customerAddress,
    this.laundromatDetails,
  });

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderQId = json['order_q_id'];
    laundryId = json['laundry_id'];
    orderType = json['order_type'];
    orderTime = json['order_time'];
    orderStatus = json['order_status'];
    orderPrice = json['order_price'];
    totalBags = json['total_bags'];
    weight = json['weight'];
    createdAt = json['created_at'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    customerAddress = json['customer_address'] != null
        ? CustomerAddress.fromJson(json['customer_address'])
        : null;
    laundromatDetails = json['laundromat_details'] != null
        ? LaundromatDetails.fromJson(json['laundromat_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_q_id'] = orderQId;
    data['laundry_id'] = laundryId;
    data['order_type'] = orderType;
    data['order_time'] = orderTime;
    data['order_status'] = orderStatus;
    data['order_price'] = orderPrice;
    data['total_bags'] = totalBags;
    data['weight'] = weight;
    data['created_at'] = createdAt;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    if (customerAddress != null) {
      data['customer_address'] = customerAddress!.toJson();
    }
    if (laundromatDetails != null) {
      data['laundromat_details'] = laundromatDetails!.toJson();
    }
    return data;
  }
}

class Products {
  String? productName;
  String? variationName;
  int? quantity;
  int? price;

  Products({
    this.productName,
    this.variationName,
    this.quantity,
    this.price,
  });

  Products.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    variationName = json['variation_name'];
    quantity = json['quantity'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_name'] = productName;
    data['variation_name'] = variationName;
    data['quantity'] = quantity;
    data['price'] = price;
    return data;
  }
}

class Customer {
  int? userId;
  String? name;
  String? email;
  String? mobile;

  Customer({
    this.userId,
    this.name,
    this.email,
    this.mobile,
  });

  Customer.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    return data;
  }
}

class CustomerAddress {
  String? address;
  String? landmark;
  String? cityId;
  String? stateId;
  String? zipCode;
  String? deliveryInstruction;

  CustomerAddress({
    this.address,
    this.landmark,
    this.cityId,
    this.stateId,
    this.zipCode,
    this.deliveryInstruction,
  });

  CustomerAddress.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    landmark = json['landmark'];
    cityId = json['city_id'];
    stateId = json['state_id'];
    zipCode = json['zip_code'];
    deliveryInstruction = json['delivery_instruction'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['address'] = address;
    data['landmark'] = landmark;
    data['city_id'] = cityId;
    data['state_id'] = stateId;
    data['zip_code'] = zipCode;
    data['delivery_instruction'] = deliveryInstruction;
    return data;
  }
}

class LaundromatDetails {
  String? name;
  String? city;
  String? state;
  String? zipCode;

  LaundromatDetails({
    this.name,
    this.city,
    this.state,
    this.zipCode,
  });

  LaundromatDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    city = json['city'];
    state = json['state'];
    zipCode = json['zip_code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['city'] = city;
    data['state'] = state;
    data['zip_code'] = zipCode;
    return data;
  }
}
