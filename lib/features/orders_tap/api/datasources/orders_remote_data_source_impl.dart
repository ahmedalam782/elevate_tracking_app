import 'package:elevate_tracking_app/core/config/api/api_executer.dart';
import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/orders_tap/api/api_client/orders_api_client.dart';
import 'package:elevate_tracking_app/features/orders_tap/data/datasources/orders_remote_data_source_contract.dart';
import 'package:elevate_tracking_app/features/orders_tap/data/models/my_orders_response.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrdersRemoteDataSourceContract)
class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSourceContract {
  final OrdersApiClient _apiClient;

  OrdersRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Result<OrdersResponse>> getOrders({required int page}) async {
    return executeApi(
      () async {
        return await _apiClient.getOrders(page);
      },
    );
  }
}
