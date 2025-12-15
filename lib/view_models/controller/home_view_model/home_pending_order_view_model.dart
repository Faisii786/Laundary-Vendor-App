import 'package:get/get.dart';
import 'package:vendor_app/data/response/status.dart';
import 'package:vendor_app/models/home/orders.dart';
import 'package:vendor_app/repository/home_repository/home_pending_orders_repository.dart';

class HomePendingOrderController extends GetxController {
  final HomePendingOrdersRepository _repository = HomePendingOrdersRepository();

  /// Observable request status (Loading, Completed, Error)
  final rxRequestStatus = Status.LOADING.obs;

  /// Observable list of pending orders
  final pendingOrdersList = <Orders>[].obs;

  /// Observable variables for pagination
  final currentPage = 1.obs;
  final totalPages = 1.obs;
  final totalpendingOrders = 0.obs;

  /// Method to set the status of the request (loading, completed, error)
  void setRxRequestStatus(Status status) => rxRequestStatus.value = status;

  /// Method to set the completed orders list
  void setCompletedOrdersList(List<Orders> orders) =>
      pendingOrdersList.assignAll(orders);

  /// Method to set pagination details
  void setPagination(Pagination? pagination) {
    totalPages.value = pagination?.totalPages ?? 1;
    totalpendingOrders.value = pagination?.totalOrders ?? 0;
  }

  /// Getter to access orders list directly
  List<Orders> get pendingOrders => pendingOrdersList;

  @override
  void onReady() {
    super.onReady();
    fetchPendingOrders();
  }

  @override
  void onClose() {
    // Dispose observables if needed
    // pendingOrdersList.clear();
    // rxRequestStatus.close();
    // currentPage.close();
    // totalPages.close();
    // totalpendingOrders.close();
    // pendingOrders.clear(); // Clear the list when closing
    super.onClose();
  }

  /// Fetch completed orders with pagination
  void fetchPendingOrders({int page = 1}) async {
    try {
      setRxRequestStatus(Status.LOADING);

      final response = await _repository.fetchOrders(page: page);

      if (response == null) {
        print("⚠️ Warning: API response is null");
        setRxRequestStatus(Status.ERROR);
        return;
      }

      // Handle null orders list
      if (response.orders != null && response.orders!.isNotEmpty) {
        setCompletedOrdersList(response.orders!);
      } else {
        print("⚠️ Warning: Orders list is null or empty.");
        setCompletedOrdersList([]); // Set empty list to prevent errors
      }

      // Handle null pagination object
      if (response.pagination != null) {
        setPagination(response.pagination!);
      } else {
        print("⚠️ Warning: Pagination data is missing.");
        setPagination(Pagination(currentPage: page, totalPages: 1));
      }

      // Final status update - COMPLETED even if empty (so UI shows "No orders" not error)
      setRxRequestStatus(Status.COMPLETED);
    } catch (error) {
      print("❌ Error fetching orders: $error");
      setRxRequestStatus(Status.ERROR);
    }
  }

  /// Load next page if available
  void loadNextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchPendingOrders(page: currentPage.value);
    }
  }

  /// Load previous page if available
  void loadPreviousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchPendingOrders(page: currentPage.value);
    }
  }
}
