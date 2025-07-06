import 'package:controller_stories/features/Clips/domain/entities/delete_clip.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delete_clip_dto.g.dart';

@JsonSerializable()
class DeleteClipDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  DeleteClipDto ({
    this.status,
    this.message,
  });

  factory DeleteClipDto.fromJson(Map<String, dynamic> json) {
    return _$DeleteClipDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteClipDtoToJson(this);
  }
  DeleteClipEntity toEntity() {
    return DeleteClipEntity(
      status: status,
      message: message,
    );
  }
}


