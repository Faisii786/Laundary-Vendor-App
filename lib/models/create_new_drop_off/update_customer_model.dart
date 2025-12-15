class UpdateCustomerModel {
  String? responseCode;
  String? result;
  String? responseMsg;

  UpdateCustomerModel({this.responseCode, this.result, this.responseMsg});

  UpdateCustomerModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    return data;
  }
}
