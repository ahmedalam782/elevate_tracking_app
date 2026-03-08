sealed class HomeEvents {}

class GetPendingOrdersEvent extends HomeEvents {}

class RejectOrderEvent extends HomeEvents {
  final int index;

  RejectOrderEvent({required this.index});
}

class AcceptOrderEvent extends HomeEvents {
  final int index;

  AcceptOrderEvent({required this.index});
}
