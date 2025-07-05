import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Categories/data/models/request/update_category_request.dart';
import 'package:controller_stories/features/Categories/domain/entities/delete_categories_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/fetch_categories_entity.dart';

import 'package:controller_stories/features/Categories/domain/entities/insert_category_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/update_categories_entity.dart';

abstract class CategoriesUseCaseRepo {




  Future<Result<FetchCategoriesEntity?>>fetchCategories();
  Future<Result<InsertCategoryEntity?>>insertCategory(
      {required String categoryName,required String categoryDescription,required int isActive});
  Future<Result<UpdateCategoryEntity?>>updateCategory(UpdateCategoryRequest updateCategoryRequest);
  Future<Result<DeleteCategoryEntity?>>deleteCategory(int categoryId);
}
