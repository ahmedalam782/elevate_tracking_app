import 'package:dio/dio.dart';
import 'package:elevate_tracking_app/core/config/api/end_points.dart';
import 'package:elevate_tracking_app/features/orders_tap/data/models/my_orders_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'orders_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: EndPoints.baseUrl)
abstract class OrdersApiClient {
  @factoryMethod
  factory OrdersApiClient(Dio dio) = _OrdersApiClient;

  @GET(EndPoints.ordersPage)
  Future<OrdersResponse> getOrders(@Query(QueryParameter.page) int page);
}
