import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/home/data/models/pending_orders_response/pending_orders_response.dart';
import 'package:elevate_tracking_app/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPendingOrdersUseCase {
  final HomeRepository homeRepository;

  GetPendingOrdersUseCase({required this.homeRepository});
  Future<Result<List<PendingOrderData>>> call() {
    return homeRepository.getPendingOrders();
  }
}
