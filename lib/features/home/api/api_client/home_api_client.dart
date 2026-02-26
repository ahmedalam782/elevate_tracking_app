// TODO: api HomeApiClient

import 'package:dio/dio.dart';
import 'package:elevate_tracking_app/core/config/api/end_points.dart';
import 'package:elevate_tracking_app/features/home/data/models/accept_order_response/accept_order_response.dart';
import 'package:elevate_tracking_app/features/home/data/models/pending_orders_response/pending_orders_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
part "home_api_client.g.dart";

@injectable
@RestApi(baseUrl: EndPoints.baseUrl)
abstract class HomeApiClient {
  @factoryMethod
  factory HomeApiClient(Dio dio) => _HomeApiClient(dio);

  @GET(EndPoints.pendingOrders)
  Future<PendingOrdersResponse> getAllPendingOrders();
  @PUT("${EndPoints.startOrder}/{id}")
  Future<AcceptOrderResponse> acceptOrder(@Path() String id);
}
