import 'package:dio/dio.dart';
import 'package:elevate_tracking_app/core/config/api/end_points.dart';
import 'package:elevate_tracking_app/features/apply/data/models/apply_response.dart';
import 'package:elevate_tracking_app/features/apply/data/models/vehicles_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'apply_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: EndPoints.baseUrl)
abstract class ApplyApiClient {
  @factoryMethod
  factory ApplyApiClient(Dio dio) => _ApplyApiClient(dio);

  @GET(EndPoints.vehicles)
  Future<VehiclesResponse> getVehicles();

  @POST(EndPoints.apply)
  @MultiPart()
  Future<ApplyResponse> apply(@Body() dynamic formData);
}
