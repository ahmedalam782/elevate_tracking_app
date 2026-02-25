import 'package:bloc_test/bloc_test.dart';
import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/core/config/base_state/base_state.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/entities/orders_page_entity.dart';
import 'package:elevate_tracking_app/features/orders_tap/domain/use_cases/get_orders_use_case.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view_model/cubit/orders_cubit.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view_model/cubit/orders_events.dart';
import 'package:elevate_tracking_app/features/orders_tap/presentation/view_model/cubit/orders_states.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'orders_cubit_test.mocks.dart';

@GenerateMocks([GetOrdersUseCase])
void main() {
  late OrdersCubit cubit;
  late MockGetOrdersUseCase mockGetOrdersUseCase;

  setUp(() {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    cubit = OrdersCubit(mockGetOrdersUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group("test OrdersCubit", () {
    const page = 1;

    OrdersPageEntity createDummyOrders({int count = 1}) {
      return OrdersPageEntity(
        totalPages: 5,
        orders: List.generate(
          count,
          (index) => OrderEntity(
            driver: "Driver $index",
            orderDetails: OrderDetailsEntity(
              orderNumber: "ORD-$index",
              totalPrice: 100,
              paymentType: "Cash",
              isPaid: true,
              isDelivered: false,
              state: "completed",
              user: OrderUserEntity(
                firstName: "User $index",
                lastName: "Last",
                email: "user$index@example.com",
                gender: "Male",
                phone: "123456",
                photo: "photo.jpg",
              ),
            ),
            store: StoreEntity(
              name: "Store $index",
              image: "img.png",
              address: "Addr $index",
            ),
          ),
        ),
      );
    }

    blocTest<OrdersCubit, OrdersState>(
      "emits Success result with correctly calculated counts when getOrders succeeds",
      build: () {
        final dummyOrders = createDummyOrders();
        provideDummy<Result<OrdersPageEntity>>(
          const Success<OrdersPageEntity>(),
        );
        when(
          mockGetOrdersUseCase(page: page),
        ).thenAnswer((_) async => Success(data: dummyOrders));
        return cubit;
      },
      act: (cubit) => cubit.doInit(GetOrdersEvent(page: page)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<OrdersState>().having(
          (s) => s.orders.state,
          'loading state',
          StateType.loading,
        ),
        isA<OrdersState>()
            .having(
              (s) => s.orders.state,
              'success state initial',
              StateType.success,
            )
            .having((s) => s.page, 'page', page),
        isA<OrdersState>()
            .having(
              (s) => s.orders.state,
              'success state with counts',
              StateType.success,
            )
            .having((s) => s.completedOrdersCount, 'completed count', 1),
      ],
    );

    blocTest<OrdersCubit, OrdersState>(
      "emits Error result when getOrders fails",
      build: () {
        provideDummy<Result<OrdersPageEntity>>(const Error<OrdersPageEntity>());
        when(
          mockGetOrdersUseCase(page: page),
        ).thenAnswer((_) async => Error(exception: Exception("Failed")));
        return cubit;
      },
      act: (cubit) => cubit.doInit(GetOrdersEvent(page: page)),
      expect: () => [
        isA<OrdersState>().having(
          (s) => s.orders.state,
          'loading state',
          StateType.loading,
        ),
        isA<OrdersState>().having(
          (s) => s.orders.state,
          'error state',
          StateType.error,
        ),
      ],
    );

    blocTest<OrdersCubit, OrdersState>(
      "emits MoreLoading and then Success with appended data when getMoreOrders succeeds",
      build: () {
        final newOrders = createDummyOrders();
        provideDummy<Result<OrdersPageEntity>>(
          const Success<OrdersPageEntity>(),
        );
        when(
          mockGetOrdersUseCase(page: 2),
        ).thenAnswer((_) async => Success(data: newOrders));
        return cubit;
      },
      seed: () => OrdersState(
        orders: BaseState.success(createDummyOrders()),
        page: 1,
        completedOrdersCount: 1,
      ),
      act: (cubit) => cubit.doInit(GetMoreOrders(page: 2)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        isA<OrdersState>().having(
          (s) => s.orders.state,
          'more loading state',
          StateType.moreLoading,
        ),
        isA<OrdersState>()
            .having(
              (s) => s.orders.state,
              'success state combined',
              StateType.success,
            )
            .having((s) => s.orders.data?.orders.length, 'orders length', 2)
            .having((s) => s.page, 'page', 2),
        isA<OrdersState>()
            .having(
              (s) => s.orders.state,
              'success state with updated counts',
              StateType.success,
            )
            .having((s) => s.completedOrdersCount, 'completed count', 2),
      ],
    );
  });
}
