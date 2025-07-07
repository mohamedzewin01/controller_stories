import 'package:controller_stories/features/Problems/data/models/response/get_problems_dto.dart';

class GetProblemsEntity {

  final String? status;

  final List<DataProblems>? data;

  GetProblemsEntity ({
    this.status,
    this.data,
  });


}