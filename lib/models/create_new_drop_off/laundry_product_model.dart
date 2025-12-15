class LaundroyProductModel {
  String? responseCode;
  String? result;
  String? responseMsg;
  List<Products>? products;

  LaundroyProductModel(
      {this.responseCode, this.result, this.responseMsg, this.products});

  LaundroyProductModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
    if (json['Products'] != null) {
      products = <Products>[];
      json['Products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    if (products != null) {
      data['Products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? productEntryId;
  String? laundromatId;
  String? productId;
  String? basePrice;
  String? appPrice;
  String? productName;

  Products(
      {this.productEntryId,
        this.laundromatId,
        this.productId,
        this.basePrice,
        this.appPrice,
        this.productName});

  Products.fromJson(Map<String, dynamic> json) {
    productEntryId = json['product_entry_id'];
    laundromatId = json['laundromat_id'];
    productId = json['product_id'];
    basePrice = json['base_price'];
    appPrice = json['app_price'];
    productName = json['product_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_entry_id'] = productEntryId;
    data['laundromat_id'] = laundromatId;
    data['product_id'] = productId;
    data['base_price'] = basePrice;
    data['app_price'] = appPrice;
    data['product_name'] = productName;
    return data;
  }
}
