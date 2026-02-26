sealed class OrdersEvents {}

class GetOrdersEvent extends OrdersEvents {
  final int? page;
  GetOrdersEvent({this.page});
}

class GetMoreOrders extends OrdersEvents {
  final int page;
  GetMoreOrders({required this.page});
}
