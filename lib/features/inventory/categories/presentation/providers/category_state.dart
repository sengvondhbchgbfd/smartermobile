import 'package:frontendmobile/features/inventory/categories/domain/entities/category_entity.dart';

class CategoryState {
  final List<CategoryEntity> categories;
  final bool isLoading;
  final String? error;
  final Set<int> loadingIds;

  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
    this.loadingIds = const {},
  });

  CategoryState copyWith({
    List<CategoryEntity>? categories,
    bool? isLoading,
    String? error,
    Set<int>? loadingIds,
    bool clearError = false,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      loadingIds: loadingIds ?? this.loadingIds,
    );
  }
}
