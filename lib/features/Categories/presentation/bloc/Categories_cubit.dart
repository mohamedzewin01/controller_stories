import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Categories/data/models/request/update_category_request.dart';
import 'package:controller_stories/features/Categories/data/models/response/fetch_categories_dto.dart';
import 'package:controller_stories/features/Categories/domain/entities/delete_categories_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/fetch_categories_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/insert_category_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/update_categories_entity.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Categories_useCase_repo.dart';

part 'Categories_state.dart';

@injectable
class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._categoriesUseCaseRepo) : super(CategoriesInitial());
  final CategoriesUseCaseRepo _categoriesUseCaseRepo;

  // Store current categories for local operations
  List<Categories?> _currentCategories = [];

  // Fetch Categories
  Future<void> fetchCategories() async {
    emit(CategoriesLoading());
    var result = await _categoriesUseCaseRepo.fetchCategories();
    switch (result) {
      case Success<FetchCategoriesEntity?>():
        if (!isClosed && result.data != null) {
          _currentCategories = result.data!.categories ?? [];
          emit(CategoriesSuccess(result.data!));
        }
        break;
      case Fail<FetchCategoriesEntity?>():
        if (!isClosed) {
          emit(CategoriesFailure(result.exception));
        }
        break;
    }
  }

  // Insert Category
  Future<void> insertCategory({
    required String categoryName,
    required String categoryDescription,
    required bool isActive,
  }) async {
    emit(CategoriesLoadingAction());

    var result = await _categoriesUseCaseRepo.insertCategory(
      categoryName: categoryName,
      categoryDescription: categoryDescription,
      isActive: isActive ? 1 : 0,
    );

    switch (result) {
      case Success<InsertCategoryEntity?>():
        if (!isClosed) {
          emit(CategoriesInsertSuccess(result.data!));
          // Refresh the categories list
          await fetchCategories();
        }
        break;
      case Fail<InsertCategoryEntity?>():
        if (!isClosed) {
          emit(CategoriesFailure(result.exception));
        }
        break;
    }
  }

  // Update Category
  Future<void> updateCategory({
    required int categoryId,
    required String categoryName,
    required String categoryDescription,
    required bool isActive,
  }) async {
    emit(CategoriesLoadingAction());

    UpdateCategoryRequest updateRequest = UpdateCategoryRequest(
      categoryId: categoryId,
      categoryName: categoryName,
      categoryDescription: categoryDescription,
      isActive: isActive ? 1 : 0,
    );

    var result = await _categoriesUseCaseRepo.updateCategory(updateRequest);

    switch (result) {
      case Success<UpdateCategoryEntity?>():
        if (!isClosed) {
          emit(CategoriesUpdateSuccess(result.data!));
          // Refresh the categories list
          await fetchCategories();
        }
        break;
      case Fail<UpdateCategoryEntity?>():
        if (!isClosed) {
          emit(CategoriesFailure(result.exception));
        }
        break;
    }
  }

  // Delete Category
  Future<void> deleteCategory(int categoryId) async {
    emit(CategoriesLoadingAction());

    var result = await _categoriesUseCaseRepo.deleteCategory(categoryId);

    switch (result) {
      case Success<DeleteCategoryEntity?>():
        if (!isClosed) {
          emit(CategoriesDeleteSuccess(result.data!));
          // Refresh the categories list
          await fetchCategories();
        }
        break;
      case Fail<DeleteCategoryEntity?>():
        if (!isClosed) {
          emit(CategoriesFailure(result.exception));
        }
        break;
    }
  }

  // // Search Categories (Local filtering)
  // void searchCategories(String query) {
  //   if (query.isEmpty) {
  //     // If search is empty, show all categories
  //     if (_currentCategories.isNotEmpty) {
  //       final categoriesEntity = FetchCategoriesEntity(
  //         status: "success",
  //         message: "Categories loaded",
  //         count: _currentCategories.length,
  //         categories: _currentCategories,
  //       );
  //       emit(CategoriesSuccess(categoriesEntity));
  //     }
  //   } else {
  //     // Filter categories based on search query
  //     final filteredCategories = _currentCategories.where((category) {
  //       final name = category.categoryName?.toLowerCase() ?? '';
  //       final description = category.categoryDescription?.toLowerCase() ?? '';
  //       final searchLower = query.toLowerCase();
  //
  //       return name.contains(searchLower) || description.contains(searchLower);
  //     }).toList();
  //
  //     final categoriesEntity = FetchCategoriesEntity(
  //       status: "success",
  //       message: "Filtered categories",
  //       count: filteredCategories.length,
  //       categories: filteredCategories,
  //     );
  //
  //     emit(CategoriesSearchResult(categoriesEntity, query));
  //   }
  // }
  //
  // // Filter Categories by Status
  // void filterCategoriesByStatus(bool? isActive) {
  //   if (isActive == null) {
  //     // Show all categories
  //     if (_currentCategories.isNotEmpty) {
  //       final categoriesEntity = FetchCategoriesEntity(
  //         status: "success",
  //         message: "All categories",
  //         count: _currentCategories.length,
  //         categories: _currentCategories,
  //       );
  //       emit(CategoriesSuccess(categoriesEntity));
  //     }
  //   } else {
  //     // Filter by status
  //     final filteredCategories = _currentCategories.where((category) {
  //       return category.isActive == (isActive ? '1' : '0');
  //     }).toList();
  //
  //     final categoriesEntity = FetchCategoriesEntity(
  //       status: "success",
  //       message: "Filtered categories",
  //       count: filteredCategories.length,
  //       categories: filteredCategories,
  //     );
  //
  //     emit(CategoriesFilterResult(categoriesEntity, isActive));
  //   }
  // }
  //
  // // Get Category by ID
  // dynamic getCategoryById(int categoryId) {
  //   try {
  //     return _currentCategories.firstWhere(
  //           (category) => category.categoryId == categoryId,
  //     );
  //   } catch (e) {
  //     return null;
  //   }
  // }
  //
  // // Get Categories Count
  // int getCategoriesCount() => _currentCategories.length;
  //
  // // Get Active Categories Count
  // int getActiveCategoriesCount() {
  //   return _currentCategories.where((category) => category.isActive == '1').length;
  // }
  //
  // // Get Inactive Categories Count
  // int getInactiveCategoriesCount() {
  //   return _currentCategories.where((category) => category.isActive == '0').length;
  // }
  //
  // // Clear Search/Filter
  // void clearFilters() {
  //   if (_currentCategories.isNotEmpty) {
  //     final categoriesEntity = FetchCategoriesEntity(
  //       status: "success",
  //       message: "All categories",
  //       count: _currentCategories.length,
  //       categories: _currentCategories,
  //     );
  //     emit(CategoriesSuccess(categoriesEntity));
  //   }
  // }

  // Refresh Categories
  Future<void> refreshCategories() async {
    await fetchCategories();
  }
}