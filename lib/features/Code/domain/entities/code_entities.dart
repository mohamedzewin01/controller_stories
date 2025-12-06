
import 'package:controller_stories/features/Code/data/models/response/get_user_codes_dto.dart';

class CreateActiveCodeEntity {
  final String? status;

  final String? message;

  final String? code;

  final int? allowedChildren;

  final int? durationMonths;

  CreateActiveCodeEntity({
    this.status,
    this.message,
    this.code,
    this.allowedChildren,
    this.durationMonths,
  });
}




class GetUserCodesEntity {

  final String? status;

  final List<Codes>? codes;

  final Pagination? pagination;

  GetUserCodesEntity ({
    this.status,
    this.codes,
    this.pagination,
  });


}