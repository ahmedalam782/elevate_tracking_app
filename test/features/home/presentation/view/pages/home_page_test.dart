import 'package:elevate_tracking_app/core/config/base_response/result.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_button.dart';
import 'package:elevate_tracking_app/core/shared/widgets/custom_skeltonizer_widget.dart';
import 'package:elevate_tracking_app/features/home/data/models/accept_order_response/accept_order_response.dart';
import 'package:elevate_tracking_app/features/home/domain/entities/pending_orders_entity.dart';
import 'package:elevate_tracking_app/features/home/domain/repositories/home_repository.dart';
import 'package:elevate_tracking_app/features/home/domain/use_cases/accept_order_use_case.dart';
import 'package:elevate_tracking_app/features/home/domain/use_cases/get_pending_orders_use_case.dart';
import 'package:elevate_tracking_app/features/home/presentation/view/pages/home_page.dart';
import 'package:elevate_tracking_app/features/home/presentation/view/widgets/adress_container.dart';
import 'package:elevate_tracking_app/features/home/presentation/view/widgets/home_order_widget.dart';
import 'package:elevate_tracking_app/features/home/presentation/view_model/cubit/home_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeHomeRepository implements HomeRepository {
  FakeHomeRepository({
    required this.pendingOrdersResult,
    Result<AcceptOrderResponse>? acceptOrderResult,
    this.pendingOrdersDelay = Duration.zero,
  }) : acceptOrderResult =
           acceptOrderResult ??
           Success<AcceptOrderResponse>(
             data: AcceptOrderResponse(message: 'accepted'),
           );

  Result<List<OrderEntity>> pendingOrdersResult;
  Result<AcceptOrderResponse> acceptOrderResult;
  Duration pendingOrdersDelay;

  int getPendingOrdersCallCount = 0;
  int acceptOrderCallCount = 0;
  String? lastAcceptedOrderId;

  @override
  Future<Result<AcceptOrderResponse>> acceptOrder(String id) async {
    acceptOrderCallCount++;
    lastAcceptedOrderId = id;
    return acceptOrderResult;
  }

  @override
  Future<Result<List<OrderEntity>>> getPendingOrders() async {
    getPendingOrdersCallCount++;
    if (pendingOrdersDelay > Duration.zero) {
      await Future<void>.delayed(pendingOrdersDelay);
    }
    return pendingOrdersResult;
  }
}

HomeCubit _buildCubit(FakeHomeRepository repository) {
  return HomeCubit(
    getPendingOrdersUseCase: GetPendingOrdersUseCase(
      homeRepository: repository,
    ),
    acceptOrderUsercase: AcceptOrderUsercase(homeRepository: repository),
  );
}

Widget _buildTestWidget(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (_, Widget? _) {
      return MaterialApp(home: Scaffold(body: child));
    },
  );
}

Widget _buildHomePageWithCubit(HomeCubit cubit) {
  return _buildTestWidget(
    BlocProvider<HomeCubit>.value(value: cubit, child: const HomePage()),
  );
}

Future<void> _pumpUntil(
  WidgetTester tester, {
  required bool Function() condition,
  int maxIterations = 30,
}) async {
  for (var i = 0; i < maxIterations; i++) {
    if (condition()) {
      return;
    }
    await tester.pump(const Duration(milliseconds: 100));
  }
}

OrderEntity _buildOrder({
  String id = 'order-1',
  String storeName = 'Store Name',
  String storeAddress = 'Store Address',
  String userName = 'User Name',
  String userAddress = 'User Address',
  double totalPrice = 250.5,
}) {
  return OrderEntity(
    id: id,
    storeAvatar: 'https://example.com/store.png',
    storeName: storeName,
    storeAddress: storeAddress,
    userAvatar: 'https://example.com/user.png',
    userName: userName,
    userAddress: userAddress,
    totalPrice: totalPrice,
  );
}

void main() {
  group('HomePage widget tests', () {
    testWidgets('fetches pending orders on first frame and renders page', (
      tester,
    ) async {
      final repository = FakeHomeRepository(
        pendingOrdersResult: Success<List<OrderEntity>>(
          data: <OrderEntity>[_buildOrder(id: 'order-1')],
        ),
      );
      final cubit = _buildCubit(repository);
      addTearDown(cubit.close);

      await tester.pumpWidget(_buildHomePageWithCubit(cubit));
      await _pumpUntil(
        tester,
        condition: () => repository.getPendingOrdersCallCount == 1,
      );
      await _pumpUntil(
        tester,
        condition: () {
          final skel = tester.widgetList<CustomSkeltonizerWidget>(
            find.byType(CustomSkeltonizerWidget),
          );
          if (skel.isEmpty) return false;
          return skel.first.isLoading == false;
        },
      );

      expect(repository.getPendingOrdersCallCount, 1);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(HomeOrderWidget), findsOneWidget);
    });

    testWidgets('shows skeleton while loading then disables it', (
      tester,
    ) async {
      final repository = FakeHomeRepository(
        pendingOrdersResult: Success<List<OrderEntity>>(
          data: <OrderEntity>[_buildOrder()],
        ),
        pendingOrdersDelay: const Duration(milliseconds: 300),
      );
      final cubit = _buildCubit(repository);
      addTearDown(cubit.close);

      await tester.pumpWidget(_buildHomePageWithCubit(cubit));
      await _pumpUntil(
        tester,
        condition: () => find.byType(HomePage).evaluate().isNotEmpty,
      );

      final loadingSkeleton = tester.widget<CustomSkeltonizerWidget>(
        find.byType(CustomSkeltonizerWidget),
      );
      expect(loadingSkeleton.isLoading, isTrue);

      await tester.pump(const Duration(milliseconds: 300));
      await _pumpUntil(
        tester,
        condition: () {
          final skel = tester.widgetList<CustomSkeltonizerWidget>(
            find.byType(CustomSkeltonizerWidget),
          );
          if (skel.isEmpty) return false;
          return skel.first.isLoading == false;
        },
      );

      final loadedSkeleton = tester.widget<CustomSkeltonizerWidget>(
        find.byType(CustomSkeltonizerWidget),
      );
      expect(loadedSkeleton.isLoading, isFalse);
    });

    testWidgets('pull to refresh triggers another pending orders request', (
      tester,
    ) async {
      final repository = FakeHomeRepository(
        pendingOrdersResult: Success<List<OrderEntity>>(
          data: <OrderEntity>[
            _buildOrder(id: 'order-1'),
            _buildOrder(id: 'order-2'),
            _buildOrder(id: 'order-3'),
            _buildOrder(id: 'order-4'),
          ],
        ),
      );
      final cubit = _buildCubit(repository);
      addTearDown(cubit.close);

      await tester.pumpWidget(_buildHomePageWithCubit(cubit));
      await _pumpUntil(
        tester,
        condition: () => find.byType(HomePage).evaluate().isNotEmpty,
      );
      await _pumpUntil(
        tester,
        condition: () {
          final skel = tester.widgetList<CustomSkeltonizerWidget>(
            find.byType(CustomSkeltonizerWidget),
          );
          if (skel.isEmpty) return false;
          return skel.first.isLoading == false;
        },
      );

      expect(repository.getPendingOrdersCallCount, 1);

      final refreshState = tester.state<RefreshIndicatorState>(
        find.byType(RefreshIndicator),
      );
      // Don't await show() because it deadlocks until refresh finishes (which needs pumping)
      refreshState.show();
      await _pumpUntil(
        tester,
        condition: () => repository.getPendingOrdersCallCount == 2,
      );

      expect(repository.getPendingOrdersCallCount, 2);
    });

    testWidgets('tap reject removes order card', (tester) async {
      final repository = FakeHomeRepository(
        pendingOrdersResult: Success<List<OrderEntity>>(
          data: <OrderEntity>[_buildOrder(id: 'order-1')],
        ),
      );
      final cubit = _buildCubit(repository);
      addTearDown(cubit.close);

      await tester.pumpWidget(_buildHomePageWithCubit(cubit));
      await _pumpUntil(
        tester,
        condition: () => find.byType(HomePage).evaluate().isNotEmpty,
      );
      await _pumpUntil(
        tester,
        condition: () {
          final skel = tester.widgetList<CustomSkeltonizerWidget>(
            find.byType(CustomSkeltonizerWidget),
          );
          if (skel.isEmpty) return false;
          return skel.first.isLoading == false;
        },
      );

      expect(find.byType(HomeOrderWidget), findsOneWidget);

      final buttons = find.byType(CustomButton);
      expect(buttons, findsNWidgets(2));
      await tester.tap(buttons.at(0));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(HomeOrderWidget), findsNothing);
    });

    testWidgets('tap accept calls use case and removes order card', (
      tester,
    ) async {
      final order = _buildOrder(id: 'order-accepted');
      final repository = FakeHomeRepository(
        pendingOrdersResult: Success<List<OrderEntity>>(
          data: <OrderEntity>[order],
        ),
      );
      final cubit = _buildCubit(repository);
      addTearDown(cubit.close);

      await tester.pumpWidget(_buildHomePageWithCubit(cubit));
      await _pumpUntil(
        tester,
        condition: () => find.byType(HomePage).evaluate().isNotEmpty,
      );
      await _pumpUntil(
        tester,
        condition: () {
          final skel = tester.widgetList<CustomSkeltonizerWidget>(
            find.byType(CustomSkeltonizerWidget),
          );
          if (skel.isEmpty) return false;
          return skel.first.isLoading == false;
        },
      );

      expect(find.byType(HomeOrderWidget), findsOneWidget);

      final buttons = find.byType(CustomButton);
      expect(buttons, findsNWidgets(2));
      await tester.tap(buttons.at(1));
      await tester.pump(const Duration(milliseconds: 100));

      expect(repository.acceptOrderCallCount, 1);
      expect(repository.lastAcceptedOrderId, 'order-accepted');
      expect(find.byType(HomeOrderWidget), findsNothing);
    });
  });

  group('HomeOrderWidget tests', () {
    testWidgets('renders content and triggers button callbacks', (
      tester,
    ) async {
      var rejectTapped = false;
      var acceptTapped = false;
      final order = _buildOrder(
        storeName: 'Flower Store',
        storeAddress: 'Nasr City',
        userName: 'Ahmed',
        userAddress: 'Maadi',
        totalPrice: 99.9,
      );

      await tester.pumpWidget(
        _buildTestWidget(
          HomeOrderWidget(
            order: order,
            onRejectCallback: () => rejectTapped = true,
            onAcceptCallback: () => acceptTapped = true,
          ),
        ),
      );
      await _pumpUntil(
        tester,
        condition: () => find.byType(HomeOrderWidget).evaluate().isNotEmpty,
      );

      expect(find.text('Flower Store'), findsOneWidget);
      expect(find.text('Ahmed'), findsOneWidget);
      expect(find.text('Nasr City'), findsOneWidget);
      expect(find.text('Maadi'), findsOneWidget);
      expect(find.byType(AddressContainer), findsNWidgets(2));
      final buttons = find.byType(CustomButton);
      expect(buttons, findsNWidgets(2));

      await tester.tap(buttons.at(0));
      await tester.pump(const Duration(milliseconds: 100));
      expect(rejectTapped, isTrue);

      await tester.tap(buttons.at(1));
      await tester.pump(const Duration(milliseconds: 100));
      expect(acceptTapped, isTrue);
    });
  });

  group('AddressContainer tests', () {
    testWidgets('renders address type, name and address text', (tester) async {
      await tester.pumpWidget(
        _buildTestWidget(
          const AddressContainer(
            addressTypText: 'Pickup address',
            image: 'https://example.com/image.png',
            name: 'My Store',
            address: 'Main Street',
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Pickup address'), findsOneWidget);
      expect(find.text('My Store'), findsOneWidget);
      expect(find.text('Main Street'), findsOneWidget);
    });
  });
}
