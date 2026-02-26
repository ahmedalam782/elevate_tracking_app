import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/orders_tap/data/datasources/orders_remote_data_source_contract.dart';
import 'package:elevate_tracking_app/features/orders_tap/data/mapper/orders_mapper.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/entities/orders_page_entity.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/repositories/orders_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrdersRepository)
class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSourceContract remoteDataSource;
  OrdersRepositoryImpl(this.remoteDataSource);
  @override
  Future<Result<OrdersPageEntity>> getOrders({required int page}) async {
    final result = await remoteDataSource.getOrders(page: page);
    return result.when(
      success: (value) => Success(data: value?.toEntity()),
      error: (failure) => Error(exception: failure as Exception),
    );
  }
}
