import 'package:controller_stories/features/Code/data/models/response/get_user_codes_dto.dart';

class CreateActiveCodeEntity {

  final String? status;

  final String? message;

  final String? code;

  final int? allowedChildren;

  final int? durationMonths;

  CreateActiveCodeEntity ({
    this.status,
    this.message,
    this.code,
    this.allowedChildren,
    this.durationMonths,
  });


}

class GetUserCodesEntity {

  final String? status;

  final int? page;

  final int? perPage;

  final int? totalPages;

  final int? totalCodes;

  final List<Codes>? codes;

  GetUserCodesEntity ({
    this.status,
    this.page,
    this.perPage,
    this.totalPages,
    this.totalCodes,
    this.codes,
  });


}