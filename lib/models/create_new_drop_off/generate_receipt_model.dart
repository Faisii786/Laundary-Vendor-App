class GenerateReceiptModel {
  String? responseCode;
  String? result;
  String? responseMsg;
  OrderDetails? orderDetails;
  CustomerDetails? customerDetails;
  LaundromatDetails? laundromatDetails;

  GenerateReceiptModel(
      {this.responseCode,
        this.result,
        this.responseMsg,
        this.orderDetails,
        this.customerDetails,
        this.laundromatDetails});

  GenerateReceiptModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
    orderDetails = json['OrderDetails'] != null
        ? OrderDetails.fromJson(json['OrderDetails'])
        : null;
    customerDetails = json['CustomerDetails'] != null
        ? CustomerDetails.fromJson(json['CustomerDetails'])
        : null;
    laundromatDetails = json['LaundromatDetails'] != null
        ? LaundromatDetails.fromJson(json['LaundromatDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    if (orderDetails != null) {
      data['OrderDetails'] = orderDetails!.toJson();
    }
    if (customerDetails != null) {
      data['CustomerDetails'] = customerDetails!.toJson();
    }
    if (laundromatDetails != null) {
      data['LaundromatDetails'] = laundromatDetails!.toJson();
    }
    return data;
  }
}

class OrderDetails {
  int? id;
  String? orderQId;
  int? customerId;
  int? laundromatId;
  String? orderTime;
  String? orderDate;
  String? orderType;
  String? orderStatus;
  Null driverAssignedId;
  String? orderPrice;
  Null receipt;
  Null rating;
  Null attachment;
  Null deliveryCode;
  Null productType;
  String? createdAt;
  String? totalBags;
  String? weight;
  String? pickupOrderTime;
  String? deliveryMethod;
  String? deliveryType;
  String? orderInstructions;
  String? orderAddress;
  Null status;
  String? payment;
  String? productDetails;
  String? orderTemp;
  String? houseStatus;
  String? aptNo;
  String? elevatorStatus;
  String? floor;
  String? deliveryStatus;
  Null helpStatus;
  Null confirmOrderPic;
  String? dueTo;
  String? deliveryTime;
  Null collectedAmount;
  String? paymentStatus;
  Null paymentType;
  String? laundromatName;
  String? customerName;
  String? customerMobile;

  OrderDetails(
      {this.id,
        this.orderQId,
        this.customerId,
        this.laundromatId,
        this.orderTime,
        this.orderDate,
        this.orderType,
        this.orderStatus,
        this.driverAssignedId,
        this.orderPrice,
        this.receipt,
        this.rating,
        this.attachment,
        this.deliveryCode,
        this.productType,
        this.createdAt,
        this.totalBags,
        this.weight,
        this.pickupOrderTime,
        this.deliveryMethod,
        this.deliveryType,
        this.orderInstructions,
        this.orderAddress,
        this.status,
        this.payment,
        this.productDetails,
        this.orderTemp,
        this.houseStatus,
        this.aptNo,
        this.elevatorStatus,
        this.floor,
        this.deliveryStatus,
        this.helpStatus,
        this.confirmOrderPic,
        this.dueTo,
        this.deliveryTime,
        this.collectedAmount,
        this.paymentStatus,
        this.paymentType,
        this.laundromatName,
        this.customerName,
        this.customerMobile});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderQId = json['order_q_id'];
    customerId = json['customer_id'];
    laundromatId = json['laundromat_id'];
    orderTime = json['order_time'];
    orderDate = json['order_date'];
    orderType = json['order_type'];
    orderStatus = json['order_status'];
    driverAssignedId = json['driver_assigned_id'];
    orderPrice = json['order_price'];
    receipt = json['receipt'];
    rating = json['rating'];
    attachment = json['attachment'];
    deliveryCode = json['delivery_code'];
    productType = json['product_type'];
    createdAt = json['created_at'];
    totalBags = json['total_bags'];
    weight = json['weight'];
    pickupOrderTime = json['pickup_order_time'];
    deliveryMethod = json['delivery_method'];
    deliveryType = json['delivery_type'];
    orderInstructions = json['order_instructions'];
    orderAddress = json['order_address'];
    status = json['status'];
    payment = json['payment'];
    productDetails = json['product_details'];
    orderTemp = json['order_temp'];
    houseStatus = json['house_status'];
    aptNo = json['apt_no'];
    elevatorStatus = json['elevator_status'];
    floor = json['floor'];
    deliveryStatus = json['delivery_status'];
    helpStatus = json['help_status'];
    confirmOrderPic = json['confirm_order_pic'];
    dueTo = json['due_to'];
    deliveryTime = json['delivery_time'];
    collectedAmount = json['collected_amount'];
    paymentStatus = json['payment_status'];
    paymentType = json['payment_type'];
    laundromatName = json['laundromat_name'];
    customerName = json['customer_name'];
    customerMobile = json['customer_mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_q_id'] = orderQId;
    data['customer_id'] = customerId;
    data['laundromat_id'] = laundromatId;
    data['order_time'] = orderTime;
    data['order_date'] = orderDate;
    data['order_type'] = orderType;
    data['order_status'] = orderStatus;
    data['driver_assigned_id'] = driverAssignedId;
    data['order_price'] = orderPrice;
    data['receipt'] = receipt;
    data['rating'] = rating;
    data['attachment'] = attachment;
    data['delivery_code'] = deliveryCode;
    data['product_type'] = productType;
    data['created_at'] = createdAt;
    data['total_bags'] = totalBags;
    data['weight'] = weight;
    data['pickup_order_time'] = pickupOrderTime;
    data['delivery_method'] = deliveryMethod;
    data['delivery_type'] = deliveryType;
    data['order_instructions'] = orderInstructions;
    data['order_address'] = orderAddress;
    data['status'] = status;
    data['payment'] = payment;
    data['product_details'] = productDetails;
    data['order_temp'] = orderTemp;
    data['house_status'] = houseStatus;
    data['apt_no'] = aptNo;
    data['elevator_status'] = elevatorStatus;
    data['floor'] = floor;
    data['delivery_status'] = deliveryStatus;
    data['help_status'] = helpStatus;
    data['confirm_order_pic'] = confirmOrderPic;
    data['due_to'] = dueTo;
    data['delivery_time'] = deliveryTime;
    data['collected_amount'] = collectedAmount;
    data['payment_status'] = paymentStatus;
    data['payment_type'] = paymentType;
    data['laundromat_name'] = laundromatName;
    data['customer_name'] = customerName;
    data['customer_mobile'] = customerMobile;
    return data;
  }
}

class CustomerDetails {
  String? name;
  String? mobile;

  CustomerDetails({this.name, this.mobile});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['mobile'] = mobile;
    return data;
  }
}

class LaundromatDetails {
  String? name;

  LaundromatDetails({this.name});

  LaundromatDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}
