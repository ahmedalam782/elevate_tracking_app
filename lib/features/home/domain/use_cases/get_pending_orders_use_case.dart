import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/home/domain/entities/pending_orders_entity.dart';
import 'package:elevate_tracking_app/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPendingOrdersUseCase {
  final HomeRepository homeRepository;

  GetPendingOrdersUseCase({required this.homeRepository});
  Future<Result<List<PendingOrdersEntity>>> call() {
    return homeRepository.getPendingOrders();
  }
}
