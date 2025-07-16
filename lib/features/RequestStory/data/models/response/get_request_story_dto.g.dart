// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_request_story_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetRequestStoryDto _$GetRequestStoryDtoFromJson(Map<String, dynamic> json) =>
    GetRequestStoryDto(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DataRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetRequestStoryDtoToJson(GetRequestStoryDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

DataRequest _$DataRequestFromJson(Map<String, dynamic> json) => DataRequest(
  request: json['request'] == null
      ? null
      : RequestUser.fromJson(json['request'] as Map<String, dynamic>),
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  child: json['child'] == null
      ? null
      : Child.fromJson(json['child'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DataRequestToJson(DataRequest instance) =>
    <String, dynamic>{
      'request': instance.request,
      'user': instance.user,
      'child': instance.child,
    };

RequestUser _$RequestUserFromJson(Map<String, dynamic> json) => RequestUser(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['user_id'] as num?)?.toInt(),
  idChildren: (json['id_children'] as num?)?.toInt(),
  problemTitle: json['problem_title'] as String?,
  problemText: json['problem_text'] as String?,
  notes: json['notes'] as String?,
  status: json['status'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$RequestUserToJson(RequestUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'id_children': instance.idChildren,
      'problem_title': instance.problemTitle,
      'problem_text': instance.problemText,
      'notes': instance.notes,
      'status': instance.status,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  gender: json['gender'],
  age: (json['age'] as num?)?.toInt(),
  email: json['email'] as String?,
  role: json['role'] as String?,
  profileImage: json['profile_image'] as String?,
  password: json['password'],
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'gender': instance.gender,
  'age': instance.age,
  'email': instance.email,
  'role': instance.role,
  'profile_image': instance.profileImage,
  'password': instance.password,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

Child _$ChildFromJson(Map<String, dynamic> json) => Child(
  idChildren: (json['id_children'] as num?)?.toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  gender: json['gender'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  imageUrl: json['imageUrl'] as String?,
  emailChildren: json['email_children'] as String?,
  userId: (json['user_id'] as num?)?.toInt(),
  siblingsCount: (json['siblings_count'] as num?)?.toInt(),
  friendsCount: (json['friends_count'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$ChildToJson(Child instance) => <String, dynamic>{
  'id_children': instance.idChildren,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'gender': instance.gender,
  'date_of_birth': instance.dateOfBirth,
  'imageUrl': instance.imageUrl,
  'email_children': instance.emailChildren,
  'user_id': instance.userId,
  'siblings_count': instance.siblingsCount,
  'friends_count': instance.friendsCount,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
