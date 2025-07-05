import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Categories/domain/entities/fetch_categories_entity.dart';
import 'package:controller_stories/features/Categories/domain/entities/insert_category_entity.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/Categories_useCase_repo.dart';

part 'Categories_state.dart';

@injectable
class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._categoriesUseCaseRepo) : super(CategoriesInitial());
  final CategoriesUseCaseRepo _categoriesUseCaseRepo;


  Future<void>fetchCategories() async {
    emit(CategoriesLoading());
    var result = await _categoriesUseCaseRepo.fetchCategories();
    switch (result) {
      case Success<FetchCategoriesEntity?>():
        if (!isClosed) {
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
}
