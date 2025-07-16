import 'package:controller_stories/features/RequestStory/domain/entities/request_story_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_request_story_dto.g.dart';

@JsonSerializable()
class GetRequestStoryDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "data")
  final List<DataRequest>? data;

  GetRequestStoryDto ({
    this.status,
    this.message,
    this.data,
  });

  factory GetRequestStoryDto.fromJson(Map<String, dynamic> json) {
    return _$GetRequestStoryDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$GetRequestStoryDtoToJson(this);
  }
  GetRequestStoryEntity toEntity() {
    return GetRequestStoryEntity(
      status: status,
      message: message,
      data: data,
    );
  }
}

@JsonSerializable()
class DataRequest {
  @JsonKey(name: "request")
  final RequestUser? request;
  @JsonKey(name: "user")
  final User? user;
  @JsonKey(name: "child")
  final Child? child;

  DataRequest ({
    this.request,
    this.user,
    this.child,
  });

  factory DataRequest.fromJson(Map<String, dynamic> json) {
    return _$DataRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DataRequestToJson(this);
  }
}

@JsonSerializable()
class RequestUser {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "user_id")
  final int? userId;
  @JsonKey(name: "id_children")
  final int? idChildren;
  @JsonKey(name: "problem_title")
  final String? problemTitle;
  @JsonKey(name: "problem_text")
  final String? problemText;
  @JsonKey(name: "notes")
  final String? notes;
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  RequestUser ({
    this.id,
    this.userId,
    this.idChildren,
    this.problemTitle,
    this.problemText,
    this.notes,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory RequestUser.fromJson(Map<String, dynamic> json) {
    return _$RequestUserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$RequestUserToJson(this);
  }
}

@JsonSerializable()
class User {
  @JsonKey(name: "id")
  final int? id;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "gender")
  final dynamic? gender;
  @JsonKey(name: "age")
  final int? age;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "role")
  final String? role;
  @JsonKey(name: "profile_image")
  final String? profileImage;
  @JsonKey(name: "password")
  final dynamic? password;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  User ({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.age,
    this.email,
    this.role,
    this.profileImage,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }
}

@JsonSerializable()
class Child {
  @JsonKey(name: "id_children")
  final int? idChildren;
  @JsonKey(name: "first_name")
  final String? firstName;
  @JsonKey(name: "last_name")
  final String? lastName;
  @JsonKey(name: "gender")
  final String? gender;
  @JsonKey(name: "date_of_birth")
  final String? dateOfBirth;
  @JsonKey(name: "imageUrl")
  final String? imageUrl;
  @JsonKey(name: "email_children")
  final String? emailChildren;
  @JsonKey(name: "user_id")
  final int? userId;
  @JsonKey(name: "siblings_count")
  final int? siblingsCount;
  @JsonKey(name: "friends_count")
  final int? friendsCount;
  @JsonKey(name: "created_at")
  final String? createdAt;
  @JsonKey(name: "updated_at")
  final String? updatedAt;

  Child ({
    this.idChildren,
    this.firstName,
    this.lastName,
    this.gender,
    this.dateOfBirth,
    this.imageUrl,
    this.emailChildren,
    this.userId,
    this.siblingsCount,
    this.friendsCount,
    this.createdAt,
    this.updatedAt,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return _$ChildFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$ChildToJson(this);
  }
}