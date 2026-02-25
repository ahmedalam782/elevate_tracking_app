import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/orders_tap/data/datasources/orders_remote_data_source_contract.dart';
import 'package:elevate_tracking_app/features/orders_tap/data/models/my_orders_response.dart';
import 'package:elevate_tracking_app/features/orders_tap/data/repositories/orders_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'orders_repository_impl_test.mocks.dart';

@GenerateMocks([OrdersRemoteDataSourceContract])
void main() {
  late OrdersRepositoryImpl repository;
  late MockOrdersRemoteDataSourceContract mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockOrdersRemoteDataSourceContract();
    repository = OrdersRepositoryImpl(mockRemoteDataSource);
  });

  group("test getOrders", () {
    const page = 1;

    test("getOrders success case returns Success with mapped data", () async {
      // Arrange
      final dummyResponse = OrdersResponse(
        metadata: Metadata(totalPages: 5),
        orders: [
          Orders(
            driver: "John Doe",
            order: Order(
              orderNumber: "123",
              totalPrice: 100,
              paymentType: "Cash",
              isPaid: true,
              isDelivered: false,
              state: "Pending",
              user: User(firstName: "Alice", lastName: "Smith"),
            ),
            store: Store(
              name: "My Store",
              image: "logo.png",
              address: "123 St",
            ),
          ),
        ],
      );

      provideDummy<Result<OrdersResponse>>(const Success<OrdersResponse>());

      when(
        mockRemoteDataSource.getOrders(page: page),
      ).thenAnswer((_) async => Success(data: dummyResponse));

      // Act
      final result = await repository.getOrders(page: page);

      // Assert
      expect(result, isA<Success>());
      final successResult = result as Success;
      expect(successResult.data.totalPages, 5);
      expect(successResult.data.orders.length, 1);
      expect(successResult.data.orders[0].driver, "John Doe");
      expect(successResult.data.orders[0].orderDetails.orderNumber, "123");
      expect(successResult.data.orders[0].store.name, "My Store");
      expect(successResult.data.orders[0].orderDetails.user.firstName, "Alice");

      verify(mockRemoteDataSource.getOrders(page: page)).called(1);
    });

    test("getOrders error case returns Error", () async {
      // Arrange
      final exception = Exception("Failed to fetch orders");
      provideDummy<Result<OrdersResponse>>(const Error<OrdersResponse>());

      when(
        mockRemoteDataSource.getOrders(page: page),
      ).thenAnswer((_) async => Error(exception: exception));

      // Act
      final result = await repository.getOrders(page: page);

      // Assert
      expect(result, isA<Error>());
      final errorResult = result as Error;
      expect(errorResult.exception, exception);

      verify(mockRemoteDataSource.getOrders(page: page)).called(1);
    });
  });
}
