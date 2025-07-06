import 'package:controller_stories/features/Clips/domain/entities/edit_clip_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'edit_clip_dto.g.dart';

@JsonSerializable()
class EditClipDto {
  @JsonKey(name: "status")
  final String? status;
  @JsonKey(name: "message")
  final String? message;

  EditClipDto ({
    this.status,
    this.message,
  });

  factory EditClipDto.fromJson(Map<String, dynamic> json) {
    return _$EditClipDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$EditClipDtoToJson(this);
  }
  EditClipEntity toEntity() {
    return EditClipEntity(
      status: status,
      message: message,
    );
  }
}


