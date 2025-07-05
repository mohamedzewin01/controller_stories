import 'package:controller_stories/features/Categories/data/models/response/fetch_categories_dto.dart';

class FetchCategoriesEntity {

  final String? status;

  final String? message;

  final int? count;

  final List<Categories>? categories;

  FetchCategoriesEntity ({
    this.status,
    this.message,
    this.count,
    this.categories,
  });


}