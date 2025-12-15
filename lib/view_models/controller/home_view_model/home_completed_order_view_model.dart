import 'package:get/get.dart';
import 'package:vendor_app/data/response/status.dart'; // Assuming you have this enum for states
import 'package:vendor_app/models/home/orders.dart';
import 'package:vendor_app/repository/home_repository/home_completed_orders_repository.dart';

class HomeCompletedOrderController extends GetxController {
  final HomeCompletedOrdersRepository _repository =
      HomeCompletedOrdersRepository();

  /// Observable request status (Loading, Completed, Error)
  final rxRequestStatus = Status.LOADING.obs;

  /// Observable list of completed orders
  final completedOrdersList =
      <Orders>[].obs; // List of orders (not wrapped in a model)

  /// Observable variables for pagination
  final currentPage = 1.obs; // Track current page
  final totalPages = 1.obs; // Track total pages
  final totalCompletedOrders = 0.obs; // Track total completed orders

  /// Method to set the status of the request (loading, completed, error)
  void setRxRequestStatus(Status status) => rxRequestStatus.value = status;

  /// Method to set the completed orders list
  void setCompletedOrdersList(List<Orders> orders) =>
      completedOrdersList.assignAll(orders); // Update list of orders

  /// Method to set pagination details
  void setPagination(Pagination pagination) {
    totalPages.value = pagination.totalPages ?? 1;
    totalCompletedOrders.value = pagination.totalOrders ?? 0;
  }

  /// Getter to access orders list directly
  List<Orders> get completedOrders => completedOrdersList;

  @override
  void onReady() {
    super.onReady();
    fetchCompletedOrders(); // Fetch orders when the controller is ready
  }

  @override
  void onClose() {
    // Dispose Rx variables if necessary
    // rxRequestStatus.close();
    // completedOrdersList.close();
    // completedOrdersList.clear(); // Clear the list when closing
    // currentPage.close();
    // totalPages.close();
    // totalCompletedOrders.close();
    // completedOrders.clear(); // Clear the list when closing
    super.onClose();
  }

  /// Fetch completed orders with pagination
  void fetchCompletedOrders({int page = 1}) async {
    try {
      setRxRequestStatus(Status.LOADING);

      // Call repository to fetch orders
      final response = await _repository.fetchOrders(page: page);

      if (response != null) {
        // Set orders and pagination data
        if (response.orders != null && response.orders!.isNotEmpty) {
          setCompletedOrdersList(response.orders!);
        } else {
          setCompletedOrdersList([]);
        }

        if (response.pagination != null) {
          setPagination(response.pagination!);
        }

        // Set request status to completed (even if empty list)
        setRxRequestStatus(Status.COMPLETED);
      } else {
        setCompletedOrdersList([]);
        setRxRequestStatus(Status.ERROR);
      }
    } catch (error) {
      print("❌ Error fetching orders in home model: $error");
      setRxRequestStatus(Status.ERROR);
    }
  }

  /// Load next page if available
  void loadNextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchCompletedOrders(page: currentPage.value);
    }
  }

  /// Load previous page if available
  void loadPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchCompletedOrders(page: currentPage.value);
    }
  }
}
