import 'package:controller_stories/features/Stories/data/models/response/fetch_stories_by_category_dto.dart';

class FetchStoriesByCategoryEntity {

  final String? status;

  final String? message;

  final int? count;

  final List<Stories>? stories;

  FetchStoriesByCategoryEntity ({
    this.status,
    this.message,
    this.count,
    this.stories,
  });

}