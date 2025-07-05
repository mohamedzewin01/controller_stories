import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Categories/data/models/request/update_category_request.dart';
import 'package:controller_stories/features/Categories/domain/entities/delete_categories_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/fetch_categories_entity.dart';

import 'package:controller_stories/features/Categories/domain/entities/insert_category_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/update_categories_entity.dart';

import '../repositories/Categories_repository.dart';
import 'package:injectable/injectable.dart';
import '../useCases/Categories_useCase_repo.dart';

@Injectable(as: CategoriesUseCaseRepo)
class CategoriesUseCase implements CategoriesUseCaseRepo {
  final CategoriesRepository repository;

  CategoriesUseCase(this.repository);

  @override
  Future<Result<InsertCategoryEntity?>> insertCategory(  {required String categoryName,required String categoryDescription,required int isActive}) {
 return repository.insertCategory(categoryName, categoryDescription, isActive);
  }

  @override
  Future<Result<FetchCategoriesEntity?>> fetchCategories() {
   return repository.fetchCategories();
  }

  @override
  Future<Result<DeleteCategoryEntity?>> deleteCategory(int categoryId) {
    return repository.deleteCategory(categoryId);
  }

  @override
  Future<Result<UpdateCategoryEntity?>> updateCategory(UpdateCategoryRequest updateCategoryRequest) {
    return repository.updateCategory(updateCategoryRequest);
  }


}
