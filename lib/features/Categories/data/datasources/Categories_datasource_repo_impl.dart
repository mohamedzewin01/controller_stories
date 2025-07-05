import 'package:controller_stories/core/api/api_extentions.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Categories/data/models/request/delete_category_request.dart';

import 'package:controller_stories/features/Categories/data/models/request/insert_category_request.dart';
import 'package:controller_stories/features/Categories/data/models/request/update_category_request.dart';
import 'package:controller_stories/features/Categories/domain/entities/delete_categories_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/fetch_categories_entity.dart';

import 'package:controller_stories/features/Categories/domain/entities/insert_category_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/update_categories_entity.dart';

import 'Categories_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/api/api_manager/api_manager.dart';

@Injectable(as: CategoriesDatasourceRepo)
class CategoriesDatasourceRepoImpl implements CategoriesDatasourceRepo {
  final ApiService apiService;

  CategoriesDatasourceRepoImpl(this.apiService);

  @override
  Future<Result<InsertCategoryEntity?>> insertCategory(
    String categoryName,
    String categoryDescription,
    int isActive,
  ) {
    return executeApi(() async {
      InsertCategoryRequest insertCategoryRequest = InsertCategoryRequest(
        categoryName: categoryName,
        categoryDescription: categoryDescription,
        isActive: isActive,
      );
      var response = await apiService.insertCategory(insertCategoryRequest);
      return response?.toEntity();
    });
  }

  @override
  Future<Result<FetchCategoriesEntity?>> fetchCategories() {
    return executeApi(() async {
      var response = await apiService.fetchCategories();
      return response?.toEntity();
    });
  }

  @override
  Future<Result<DeleteCategoryEntity?>> deleteCategory(int categoryId) {
    return executeApi(() async {
      DeleteCategoryRequest deleteCategoryRequest = DeleteCategoryRequest(
        categoryId: categoryId,
      );
      var response = await apiService.deleteCategory(deleteCategoryRequest);
      return response?.toEntity();
    });
  }

  @override
  Future<Result<UpdateCategoryEntity?>> updateCategory(
    UpdateCategoryRequest updateCategoryRequest,
  ) {
    return executeApi(() async {
      var response = await apiService.updateCategory(updateCategoryRequest);
      return response?.toEntity();
    });
  }
}
