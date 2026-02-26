import 'package:elevate_tracking_app/shared/pagination/pagination_meta.dart';

class LoadablePaginatedModel<T> {
  final bool isInitialLoading;
  final List<T> items;
  final String? error;
  final PaginationMeta pagination;

  const LoadablePaginatedModel({
    required this.isInitialLoading,
    required this.items,
    required this.error,
    required this.pagination,
  });

  factory LoadablePaginatedModel.initial() {
    return LoadablePaginatedModel(
      isInitialLoading: false,
      items: [],
      error: null,
      pagination: PaginationMeta.initial(),
    );
  }

  LoadablePaginatedModel<T> copyWith({
    bool? isInitialLoading,
    List<T>? items,
    String? error,
    bool clearError = false,
    PaginationMeta? pagination,
  }) {
    return LoadablePaginatedModel<T>(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      items: items ?? this.items,
      error: clearError ? null : (error ?? this.error),
      pagination: pagination ?? this.pagination,
    );
  }
}
