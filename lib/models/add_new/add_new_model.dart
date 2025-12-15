// class AddNewModel {
//   String? responseCode;
//   String? result;
//   String? title;
//   String? message;
//   String? action;
//
//   AddNewModel(
//       {this.responseCode, this.result, this.title, this.message, this.action});
//
//   AddNewModel.fromJson(Map<String, dynamic> json) {
//     responseCode = json['ResponseCode'];
//     result = json['Result'];
//     title = json['title'];
//     message = json['message'];
//     action = json['action'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ResponseCode'] = this.responseCode;
//     data['Result'] = this.result;
//     data['title'] = this.title;
//     data['message'] = this.message;
//     data['action'] = this.action;
//     return data;
//   }
// }
class AddNewModel {
  String? responseCode;
  String? result;
  String? title;
  String? message;
  String? action;

  AddNewModel(
      {this.responseCode, this.result, this.title, this.message, this.action});

  AddNewModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    title = json['title'];
    message = json['message'];
    action = json['action'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['title'] = title;
    data['message'] = message;
    data['action'] = action;
    return data;
  }
}
