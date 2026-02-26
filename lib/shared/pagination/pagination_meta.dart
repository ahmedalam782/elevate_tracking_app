class PaginationMeta {
  final bool isFetching;
  final bool hasMore;
  final int page;

  const PaginationMeta({
    required this.isFetching,
    required this.hasMore,
    required this.page,
  });

  factory PaginationMeta.initial() {
    return const PaginationMeta(isFetching: false, hasMore: true, page: 1);
  }

  PaginationMeta copyWith({bool? isFetching, bool? hasMore, int? page}) {
    return PaginationMeta(
      isFetching: isFetching ?? this.isFetching,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
    );
  }
}
