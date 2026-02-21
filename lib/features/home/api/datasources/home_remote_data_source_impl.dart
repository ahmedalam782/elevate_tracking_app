// TODO: api HomeRemoteDataSourceImpl

import 'package:elevate_tracking_app/core/config/api/api_executer.dart';
import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/home/api/api_client/home_api_client.dart';
import 'package:elevate_tracking_app/features/home/data/datasources/home_remote_data_source_contract.dart';
import 'package:elevate_tracking_app/features/home/data/models/accept_order_response/accept_order_response.dart';
import 'package:elevate_tracking_app/features/home/data/models/pending_orders_response/pending_orders_response.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: HomeRemoteDataSourceContract)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSourceContract {
  final HomeApiClient homeApiClient;

  HomeRemoteDataSourceImpl({required this.homeApiClient});
  @override
  Future<Result<PendingOrdersResponse>> getAllPendingOrders() async {
    return await executeApi<PendingOrdersResponse>(
      () => homeApiClient.getAllPendingOrders(),
    );
  }

  @override
  Future<Result<AcceptOrderResponse>> acceptOrder(String id) async {
    return await executeApi<AcceptOrderResponse>(
      () => homeApiClient.acceptOrder(id),
    );
  }
}
