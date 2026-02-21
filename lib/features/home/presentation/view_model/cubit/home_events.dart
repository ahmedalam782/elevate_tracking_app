// TODO: presentation HomeEvents
sealed class HomeEvents {}

class GetPendingOrdersEvent extends HomeEvents {}

class RejectOrderEventt extends HomeEvents {
  final int index;

  RejectOrderEventt({required this.index});
}
