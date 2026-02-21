// TODO: data HomeRepositoryImpl

import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/home/data/datasources/home_remote_data_source_contract.dart';
import 'package:elevate_tracking_app/features/home/data/models/accept_order_response/accept_order_response.dart';
import 'package:elevate_tracking_app/features/home/data/models/pending_orders_response/pending_orders_response.dart';
import 'package:elevate_tracking_app/features/home/domain/entities/pending_orders_entity.dart';
import 'package:elevate_tracking_app/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSourceContract remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<List<OrderEntity>>> getPendingOrders() async {
    List<OrderEntity> pendingOrders = [];
    final result = await remoteDataSource.getAllPendingOrders();
    return result.when(
      success: (data) {
        for (PendingOrderData item in data?.orders ?? []) {
          pendingOrders.add(item.toPendingOrderEntity());
        }
        return Success<List<OrderEntity>>(data: pendingOrders);
      },
      error: (exception) {
        return Error(exception: exception);
      },
    );
  }

  @override
  Future<Result<AcceptOrderResponse>> acceptOrder(String id) async {
    final result = await remoteDataSource.acceptOrder(id);
    return result.when(
      success: (data) {
        return Success<AcceptOrderResponse>(data: data);
      },
      error: (exception) {
        return Error(exception: exception);
      },
    );
  }
}
