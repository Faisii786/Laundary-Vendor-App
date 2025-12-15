// class HomeCompletedOrderModel {
//   String? responseCode;
//   String? result;
//   String? responseMsg;
//   List<Orders>? orders;
//   Pagination? pagination;

//   HomeCompletedOrderModel(
//       {this.responseCode,
//       this.result,
//       this.responseMsg,
//       this.orders,
//       this.pagination});

//   HomeCompletedOrderModel.fromJson(Map<String, dynamic> json) {
//     responseCode = json['ResponseCode'];
//     result = json['Result'];
//     responseMsg = json['ResponseMsg'];
//     if (json['Orders'] != null) {
//       orders = <Orders>[];
//       json['Orders'].forEach((v) {
//         orders!.add(new Orders.fromJson(v));
//       });
//     }
//     pagination = json['Pagination'] != null
//         ? new Pagination.fromJson(json['Pagination'])
//         : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ResponseCode'] = responseCode;
//     data['Result'] = result;
//     data['ResponseMsg'] = responseMsg;
//     if (orders != null) {
//       data['Orders'] = orders!.map((v) => v.toJson()).toList();
//     }
//     if (pagination != null) {
//       data['Pagination'] = pagination!.toJson();
//     }
//     return data;
//   }
// }

// class Orders {
//   int? orderId;
//   int? laundryId;
//   String? orderType;
//   String? orderTime;
//   String? orderStatus;
//   String? orderPrice;
//   String? totalBags;
//   String? weight;
//   String? due;
//   String? createdAt;
//   List<Products>? products;
//   Customer? customer;
//   LaundromatDetails? laundromatDetails;
//   String? driverName;

//   Orders(
//       {this.orderId,
//       this.laundryId,
//       this.orderType,
//       this.orderTime,
//       this.orderStatus,
//       this.orderPrice,
//       this.totalBags,
//       this.weight,
//       this.due,
//       this.createdAt,
//       this.products,
//       this.customer,
//       this.laundromatDetails,
//       this.driverName});

//   Orders.fromJson(Map<String, dynamic> json) {
//     orderId = json['order_id'];
//     laundryId = json['laundry_id'];
//     orderType = json['order_type'];
//     orderTime = json['order_time'];
//     orderStatus = json['order_status'];
//     orderPrice = json['order_price'];
//     totalBags = json['total_bags'];
//     weight = json['weight'];
//     due = json['due'];
//     createdAt = json['created_at'];
//     if (json['products'] != null) {
//       products = <Products>[];
//       json['products'].forEach((v) {
//         products!.add(new Products.fromJson(v));
//       });
//     }
//     customer = json['customer'] != null
//         ? new Customer.fromJson(json['customer'])
//         : null;
//     laundromatDetails = json['laundromat_details'] != null
//         ? new LaundromatDetails.fromJson(json['laundromat_details'])
//         : null;
//     driverName = json['driver_name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['order_id'] = orderId;
//     data['laundry_id'] = laundryId;
//     data['order_type'] = orderType;
//     data['order_time'] = orderTime;
//     data['order_status'] = orderStatus;
//     data['order_price'] = orderPrice;
//     data['total_bags'] = totalBags;
//     data['weight'] = weight;
//     data['due'] = due;
//     data['created_at'] = createdAt;
//     if (products != null) {
//       data['products'] = products!.map((v) => v.toJson()).toList();
//     }
//     if (customer != null) {
//       data['customer'] = customer!.toJson();
//     }
//     if (laundromatDetails != null) {
//       data['laundromat_details'] = laundromatDetails!.toJson();
//     }
//     data['driver_name'] = driverName;
//     return data;
//   }
// }

// class Products {
//   String? productName;
//   String? variationName;
//   int? quantity;
//   int? price;
//   String? weight;

//   Products(
//       {this.productName,
//       this.variationName,
//       this.quantity,
//       this.price,
//       this.weight});

//   Products.fromJson(Map<String, dynamic> json) {
//     productName = json['product_name'];
//     variationName = json['variation_name'];
//     quantity = json['quantity'];
//     price = json['price'];
//     weight = json['weight'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_name'] = productName;
//     data['variation_name'] = variationName;
//     data['quantity'] = quantity;
//     data['price'] = price;
//     data['weight'] = weight;
//     return data;
//   }
// }

// class Customer {
//   int? userId;
//   String? name;
//   String? email;
//   String? mobile;

//   Customer({this.userId, this.name, this.email, this.mobile});

//   Customer.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     name = json['name'];
//     email = json['email'];
//     mobile = json['mobile'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user_id'] = userId;
//     data['name'] = name;
//     data['email'] = email;
//     data['mobile'] = mobile;
//     return data;
//   }
// }

// class LaundromatDetails {
//   String? name;
//   String? city;
//   String? state;
//   String? zipCode;

//   LaundromatDetails({this.name, this.city, this.state, this.zipCode});

//   LaundromatDetails.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     city = json['city'];
//     state = json['state'];
//     zipCode = json['zip_code'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = name;
//     data['city'] = city;
//     data['state'] = state;
//     data['zip_code'] = zipCode;
//     return data;
//   }
// }

// class Pagination {
//   int? currentPage;
//   int? totalPages;
//   int? totalOrders;

//   Pagination({this.currentPage, this.totalPages, this.totalOrders});

//   Pagination.fromJson(Map<String, dynamic> json) {
//     currentPage = json['current_page'];
//     totalPages = json['total_pages'];
//     totalOrders = json['total_orders'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['current_page'] = currentPage;
//     data['total_pages'] = totalPages;
//     data['total_orders'] = totalOrders;
//     return data;
//   }
// }
