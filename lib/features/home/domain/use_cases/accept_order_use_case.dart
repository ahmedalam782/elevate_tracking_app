import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/home/data/models/accept_order_response/accept_order_response.dart';
import 'package:elevate_tracking_app/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class AcceptOrderUsercase {
  final HomeRepository homeRepository;

  AcceptOrderUsercase({required this.homeRepository});
  Future<Result<AcceptOrderResponse>> call(String id) {
    return homeRepository.acceptOrder(id);
  }
}
