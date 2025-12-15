class CreateDropOffOrderModel {
  String? responseCode;
  String? result;
  String? title;
  String? orderId; // Keep as String to avoid type issues
  String? orderType;
  String? orderTime;

  CreateDropOffOrderModel({
    this.responseCode,
    this.result,
    this.title,
    this.orderId,
    this.orderType,
    this.orderTime,
  });

  CreateDropOffOrderModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    title = json['title'];

    /// ✅ Fix: Convert `order_id` to a String regardless of type
    orderId = json['order_id']?.toString();

    orderType = json['order_type'];
    orderTime = json['order_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['title'] = title;

    /// ✅ Ensure `order_id` is stored as a String
    data['order_id'] = orderId?.toString();

    data['order_type'] = orderType;
    data['order_time'] = orderTime;
    return data;
  }
}
