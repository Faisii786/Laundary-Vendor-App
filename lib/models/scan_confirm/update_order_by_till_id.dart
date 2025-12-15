class UpadateTillIdOderModel {
  String? responseCode;
  String? result;
  String? title;
  int? orderId;
  String? orderType;

  UpadateTillIdOderModel(
      {this.responseCode,
        this.result,
        this.title,
        this.orderId,
        this.orderType});

  UpadateTillIdOderModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    title = json['title'];
    orderId = json['order_id'];
    orderType = json['order_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['title'] = title;
    data['order_id'] = orderId;
    data['order_type'] = orderType;
    return data;
  }
}
