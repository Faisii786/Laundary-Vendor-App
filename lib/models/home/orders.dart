// single order model used every where in the code for orders
// not using this model for drop off orders.
class OrdersModel {
  String? responseCode;
  String? result;
  String? responseMsg;
  List<Orders>? orders;
  Pagination? pagination;

  OrdersModel({
    this.responseCode,
    this.result,
    this.responseMsg,
    this.orders,
    this.pagination,
  });

  OrdersModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
    if (json['Orders'] != null && json['Orders'] is List) {
      orders = (json['Orders'] as List)
          .map((order) => Orders.fromJson(order))
          .toList();
    } else {
      orders = [];
    }
    if (json['Pagination'] != null && json['Pagination'] is Map) {
      pagination = Pagination.fromJson(json['Pagination']);
    } else {
      pagination = Pagination(currentPage: 1, totalPages: 1);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'ResponseCode': responseCode,
      'Result': result,
      'ResponseMsg': responseMsg,
      'Orders': orders?.map((v) => v.toJson()).toList(),
      'Pagination': pagination?.toJson(),
    };
  }
}

class Orders {
  int? orderId;
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
  LaundromatDetails? laundromatDetails;
  String? driverName;

  Orders({
    this.orderId,
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
    this.laundromatDetails,
    this.driverName,
  });

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'] is int
        ? json['order_id']
        : int.tryParse(json['order_id']?.toString() ?? '');
    laundryId = json['laundry_id'] is int
        ? json['laundry_id']
        : json['laundromat_id'] is int
            ? json['laundromat_id']
            : int.tryParse(json['laundry_id']?.toString() ??
                json['laundromat_id']?.toString() ??
                '');
    orderType = json['order_type']?.toString() ?? 'N/A';
    orderTime = json['order_time']?.toString() ?? 'N/A';
    orderStatus = json['order_status']?.toString() ?? 'N/A';
    orderPrice = json['order_price']?.toString() ?? 'N/A';
    totalBags = json['total_bags']?.toString() ?? 'N/A';
    weight = json['weight']?.toString() ?? 'N/A';
    createdAt = json['created_at']?.toString() ?? 'N/A';
    if (json['products'] != null && json['products'] is List) {
      products =
          (json['products'] as List).map((v) => Products.fromJson(v)).toList();
    } else {
      products = [];
    }
    customer =
        json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    laundromatDetails = json['laundromat_details'] != null
        ? LaundromatDetails.fromJson(json['laundromat_details'])
        : null;
    driverName = json['driver_name']?.toString() ?? 'Not Assigned';
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'laundry_id': laundryId,
      'order_type': orderType,
      'order_time': orderTime,
      'order_status': orderStatus,
      'order_price': orderPrice,
      'total_bags': totalBags,
      'weight': weight,
      'created_at': createdAt,
      'products': products?.map((v) => v.toJson()).toList(),
      'customer': customer?.toJson(),
      'laundromat_details': laundromatDetails?.toJson(),
      'driver_name': driverName,
    };
  }
}

class Products {
  String? productName;
  String? variationName;
  dynamic quantity; // Can be int or String
  dynamic price; // Can be int, String, or empty

  Products({this.productName, this.variationName, this.quantity, this.price});

  Products.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'] ?? 'N/A';
    variationName = json['variation_name'] ?? 'N/A';
    quantity = json['quantity'] ?? 'N/A';
    price = json['price'] ?? 'N/A';
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'variation_name': variationName,
      'quantity': quantity,
      'price': price,
    };
  }
}

class Customer {
  int? userId;
  String? name;
  String? email;
  String? mobile;
  String? address;

  Customer({this.userId, this.name, this.email, this.mobile, this.address});

  Customer.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'] is int
        ? json['user_id']
        : int.tryParse(json['user_id']?.toString() ?? '');
    name = json['name']?.toString() ?? 'N/A';
    email = json['email']?.toString() ?? 'N/A';
    mobile = json['mobile']?.toString() ?? 'N/A';
    address = json['address']?.toString() ?? 'N/A';
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'address': address,
    };
  }
}

class LaundromatDetails {
  String? name;
  String? city;
  String? state;
  String? zipCode;

  LaundromatDetails({this.name, this.city, this.state, this.zipCode});

  LaundromatDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? 'N/A';
    city = json['city'] ?? 'N/A';
    state = json['state'] ?? 'N/A';
    zipCode = json['zip_code'] ?? 'N/A';
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'city': city,
      'state': state,
      'zip_code': zipCode,
    };
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalOrders;

  Pagination({this.currentPage, this.totalPages, this.totalOrders});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    totalPages = json['total_pages'];
    totalOrders = json['total_orders'];
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_orders': totalOrders,
    };
  }
}
