import 'package:dio/dio.dart';
import 'package:elevate_tracking_app/features/order_details/data/models/order_details_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:elevate_tracking_app/core/config/api/end_points.dart';

part 'order_details_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: EndPoints.baseUrl)
abstract class OrderDetailsApiClient {
  @factoryMethod
  factory OrderDetailsApiClient(Dio dio) = _OrderDetailsApiClient;

  @GET(EndPoints.orderDetails) // e.g. '/orders/driver-orders/{id}'
  Future<OrderDetailsResponse> getOrderDetails(
    @Path('id') String driverOrderId,
  );
}