import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Categories/data/datasources/Categories_datasource_repo.dart';
import 'package:controller_stories/features/Categories/data/models/request/update_category_request.dart';
import 'package:controller_stories/features/Categories/domain/entities/delete_categories_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/fetch_categories_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/insert_category_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/update_categories_entity.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/Categories_repository.dart';

@Injectable(as: CategoriesRepository)
class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesDatasourceRepo categoriesDatasourceRepo;
  CategoriesRepositoryImpl(this.categoriesDatasourceRepo);

  @override
  Future<Result<InsertCategoryEntity?>> insertCategory(String categoryName, String categoryDescription, int isActive) {
   return categoriesDatasourceRepo.insertCategory(categoryName, categoryDescription, isActive);
  }

  @override
  Future<Result<FetchCategoriesEntity?>> fetchCategories() {
    return categoriesDatasourceRepo.fetchCategories();
  }

  @override
  Future<Result<DeleteCategoryEntity?>> deleteCategory(int categoryId) {
    return categoriesDatasourceRepo.deleteCategory(categoryId);
  }

  @override
  Future<Result<UpdateCategoryEntity?>> updateCategory(UpdateCategoryRequest updateCategoryRequest) {
 return categoriesDatasourceRepo.updateCategory(updateCategoryRequest);
  }

}
