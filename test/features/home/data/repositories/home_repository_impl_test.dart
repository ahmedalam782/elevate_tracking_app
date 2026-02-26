import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/features/home/data/datasources/home_remote_data_source_contract.dart';
import 'package:elevate_tracking_app/features/home/data/models/accept_order_response/accept_order_response.dart';
import 'package:elevate_tracking_app/features/home/data/models/pending_orders_response/pending_orders_response.dart';
import 'package:elevate_tracking_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeHomeRemoteDataSourceContract
    implements HomeRemoteDataSourceContract {
  Result<PendingOrdersResponse>? _pendingOrdersResponse;
  Result<AcceptOrderResponse>? _acceptOrderResponse;
  int pendingOrdersCallCount = 0;
  int acceptOrderCallCount = 0;
  String? lastAcceptOrderId;

  void setPendingOrdersResponse(Result<PendingOrdersResponse> response) {
    _pendingOrdersResponse = response;
  }

  void setAcceptOrderResponse(Result<AcceptOrderResponse> response) {
    _acceptOrderResponse = response;
  }

  @override
  Future<Result<PendingOrdersResponse>> getAllPendingOrders() async {
    pendingOrdersCallCount++;
    return _pendingOrdersResponse!;
  }

  @override
  Future<Result<AcceptOrderResponse>> acceptOrder(String id) async {
    acceptOrderCallCount++;
    lastAcceptOrderId = id;
    return _acceptOrderResponse!;
  }
}

void main() {
  late FakeHomeRemoteDataSourceContract fakeRemote;
  late HomeRepositoryImpl repository;

  setUp(() {
    fakeRemote = FakeHomeRemoteDataSourceContract();
    repository = HomeRepositoryImpl(remoteDataSource: fakeRemote);
  });

  group('getPendingOrders', () {
    test('maps PendingOrderData into OrderEntity list', () async {
      final response = PendingOrdersResponse(
        message: 'ok',
        orders: [
          PendingOrderData(
            id: 'order-1',
            totalPrice: 25,
            store: PendingStore(
              name: 'Store Name',
              image: 'store.png',
              address: 'Store Address',
            ),
            user: PendingUser(
              firstName: 'User Name',
              photo: 'user.png',
            ),
          ),
        ],
      );

      fakeRemote.setPendingOrdersResponse(Success(data: response));

      final result = await repository.getPendingOrders();

      expect(fakeRemote.pendingOrdersCallCount, 1);

      result.when(
        success: (data) {
          expect(data, isNotNull);
          expect(data!.length, 1);
          final order = data.first;
          expect(order.id, 'order-1');
          expect(order.storeName, 'Store Name');
          expect(order.storeAvatar, 'store.png');
          expect(order.storeAddress, 'Store Address');
          expect(order.userName, 'User Name');
          expect(order.userAvatar, 'user.png');
          expect(order.userAddress, 'User address');
          expect(order.totalPrice, 25.0);
        },
        error: (exception) => fail('Expected success but got error'),
      );
    });

    test('returns empty list when response data is null', () async {
      fakeRemote.setPendingOrdersResponse(const Success(data: null));

      final result = await repository.getPendingOrders();

      expect(fakeRemote.pendingOrdersCallCount, 1);

      result.when(
        success: (data) {
          expect(data, isNotNull);
          expect(data, isEmpty);
        },
        error: (exception) => fail('Expected success but got error'),
      );
    });

    test('returns Error when remote returns Error', () async {
      final exception = Exception('Network failure');
      fakeRemote.setPendingOrdersResponse(Error(exception: exception));

      final result = await repository.getPendingOrders();

      expect(fakeRemote.pendingOrdersCallCount, 1);

      result.when(
        success: (data) => fail('Expected error but got success'),
        error: (ex) {
          expect(ex, isNotNull);
          expect(ex, exception);
        },
      );
    });
  });

  group('acceptOrder', () {
    test('returns Success and passes id to remote', () async {
      final response = AcceptOrderResponse(message: 'accepted');
      fakeRemote.setAcceptOrderResponse(Success(data: response));

      final result = await repository.acceptOrder('order-123');

      expect(fakeRemote.acceptOrderCallCount, 1);
      expect(fakeRemote.lastAcceptOrderId, 'order-123');

      result.when(
        success: (data) {
          expect(data, isNotNull);
          expect(data?.message, 'accepted');
        },
        error: (exception) => fail('Expected success but got error'),
      );
    });

    test('returns Error when remote returns Error', () async {
      final exception = Exception('Accept failed');
      fakeRemote.setAcceptOrderResponse(Error(exception: exception));

      final result = await repository.acceptOrder('order-456');

      expect(fakeRemote.acceptOrderCallCount, 1);

      result.when(
        success: (data) => fail('Expected error but got success'),
        error: (ex) {
          expect(ex, isNotNull);
          expect(ex, exception);
        },
      );
    });
  });
}
