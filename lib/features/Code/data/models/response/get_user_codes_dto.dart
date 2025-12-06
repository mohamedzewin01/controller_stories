import 'package:controller_stories/features/Code/domain/entities/code_entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_user_codes_dto.g.dart';

@JsonSerializable()
class GetUserCodesDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "page")
  final int? page;
  @JsonKey(name: "per_page")
  final int? perPage;
  @JsonKey(name: "total_pages")
  final int? totalPages;
  @JsonKey(name: "total_codes")
  final int? totalCodes;
  @JsonKey(name: "codes")
  final List<Codes>? codes;

  GetUserCodesDto ({
    this.status,
    this.page,
    this.perPage,
    this.totalPages,
    this.totalCodes,
    this.codes,
  });

  factory GetUserCodesDto.fromJson(Map<String, dynamic> json) {
    return _$GetUserCodesDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetUserCodesDtoToJson(this);
  }
  GetUserCodesEntity toEntity() {
    return GetUserCodesEntity (
      status: status,
      page: page,
      perPage: perPage,
      totalPages: totalPages,
      totalCodes: totalCodes,
      codes: codes,
    );
  }
}

@JsonSerializable()
class Codes {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "user_id")
  final String? userId;
  @JsonKey(name: "code")
  final String? code;
  @JsonKey(name: "allowed_children")
  final int? allowedChildren;
  @JsonKey(name: "duration_months")
  final int? durationMonths;
  @JsonKey(name: "used_children")
  final int? usedChildren;
  @JsonKey(name: "start_date")
  final String? startDate;
  @JsonKey(name: "end_date")
  final String? endDate;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "admin_status")
  final String? adminStatus;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  Codes ({
    this.id,
    this.userId,
    this.code,
    this.allowedChildren,
    this.durationMonths,
    this.usedChildren,
    this.startDate,
    this.endDate,
    this.status,
    this.adminStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory Codes.fromJson(Map<String, dynamic> json) {
    return _$CodesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CodesToJson(this);
  }
}


