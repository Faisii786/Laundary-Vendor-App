class AppUrl {
  // For iOS Simulator use: 'http://localhost:8000/'
  // For Android Emulator use: 'http://93.127.202.7:8080/'
  // For Physical Device use your computer's IP: 'http://YOUR_IP:8000/'
  static const String baseUrl = 'http://93.127.202.7/';
  static const String loginApi = '$baseUrl/laundry_api/laundry_login.php';
  static const String signupApi = '$baseUrl/laundry_api/laundry_reg.php';
  static const String pickUpApi = '$baseUrl/laundry_api/laundry_orders.php';
  static const String onlypickupApi =
      '$baseUrl/laundry_api/laundry_pickup_orders.php';
  static const String dropOffApi =
      '$baseUrl/laundry_api/laundry_dropofforders.php';
  static const String orderconfirmApi =
      '$baseUrl/laundry_api/change_status.php';
  static const String pickDropApi =
      '$baseUrl/laundry_api/laundry_pickup_delivery_orders.php';
  //static const String addNewApi ='$baseUrl/order_api/order.php';
  static const String addNewApi = '$baseUrl/drylaun_api/add_order.php';
  static const String homeCompleteOdrApi =
      '$baseUrl/laundry_api/laundry_completed_orders.php';
  static const String homePendingOdrApi =
      '$baseUrl/laundry_api/get_all_pending_orders.php';
  static const String serchByNumberApi =
      '$baseUrl/laundry_api/search_user_by_laundry.php';
  static const String registerCustomerApi =
      '$baseUrl/laundry_api/u_user_register.php';
  static const String createDropOffOrderApi =
      '$baseUrl/laundry_api/add_order.php';
  static const String updateCustomerApi =
      '$baseUrl/laundry_api/update_user.php';
  static const String dropoffReceiptApi =
      '$baseUrl/laundry_api/generate_reci.php';
  static const String scanConfirmOrderTillID =
      '$baseUrl/laundry_api/get_order_details_using_till_id.php';
  static const String updateOrderTillID =
      '$baseUrl/laundry_api/update_order_by_till_id.php';
  static const String activityApi =
      '$baseUrl/laundry_api/laundry_by_filter_orders.php';
  static const String laundryProductApi =
      '$baseUrl/user_api/get_products_laundry.php';

  // static const String  baseUrl='https://reqres.in'; //reqres.in  website for login api
  // static const String loginApi = '$baseUrl/api/login';
  // static const String  baseUrl='https://laundry.saleselevation.tech'; //reqres.in  website for login api
  // static const String loginApi = '$baseUrl/user_api/u_login_user.php';
  static const String userListApi = 'https://reqres.in/api/users?page=2';
}
