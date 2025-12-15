class UserModel {
  UserLogin? userLogin;
  String? responseCode;
  String? result;
  String? responseMsg;

  UserModel({this.userLogin, this.responseCode, this.result, this.responseMsg});

  UserModel.fromJson(Map<String, dynamic> json) {
    userLogin = json['UserLogin'] != null
        ? UserLogin.fromJson(json['UserLogin'])
        : null;
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userLogin != null) {
      data['UserLogin'] = userLogin!.toJson();
    }
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    return data;
  }
}

class UserLogin {
  String? id;
  String? laundryId;
  String? name;
  String? email;
  String? mobile;
  String? securityToken;

  UserLogin(
      {this.id,
      this.laundryId,
      this.name,
      this.email,
      this.mobile,
      this.securityToken});

  UserLogin.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    laundryId = json['laundry_id']?.toString();
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    securityToken = json['security_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['laundry_id'] = laundryId;
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['security_token'] = securityToken;
    return data;
  }
}


// class UserModel {
//   String? token;
//   bool? isLogin;
//
//   UserModel({this.token, this.isLogin});
//
//   UserModel.fromJson(Map<String, dynamic> json) {
//     token = json['token'];
//     isLogin = json['isLogin'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['token'] = this.token;
//     data['isLogin'] = this.token;
//     return data;
//   }
// }

