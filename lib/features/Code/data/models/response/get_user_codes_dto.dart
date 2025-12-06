import 'package:controller_stories/features/Code/domain/entities/code_entities.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_user_codes_dto.g.dart';

@JsonSerializable()
class GetUserCodesDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "codes")
  final List<Codes>? codes;
  @JsonKey(name: "pagination")
  final Pagination? pagination;

  GetUserCodesDto ({
    this.status,
    this.codes,
    this.pagination,
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
      pagination: pagination,
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
  @JsonKey(name: "user_data")
  final UserData? userData;

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
    this.userData,
  });

  factory Codes.fromJson(Map<String, dynamic> json) {
    return _$CodesFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$CodesToJson(this);
  }
}

@JsonSerializable()
class UserData {
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "gender")
  final dynamic? gender;
  @JsonKey(name: "age")
  final dynamic? age;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "role")
  final String? role;
  @JsonKey(name: "profile_image")
  final String? profileImage;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  UserData ({
    this.firstName,
    this.lastName,
    this.gender,
    this.age,
    this.email,
    this.role,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return _$UserDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserDataToJson(this);
  }
}

@JsonSerializable()
class Pagination {
  @JsonKey(name: "page")
  final int? page;
  @JsonKey(name: "per_page")
  final int? perPage;
  @JsonKey(name: "total_pages")
  final int? totalPages;
  @JsonKey(name: "total_records")
  final int? totalRecords;

  Pagination ({
    this.page,
    this.perPage,
    this.totalPages,
    this.totalRecords,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return _$PaginationFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PaginationToJson(this);
  }
}


