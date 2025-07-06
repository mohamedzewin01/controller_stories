import 'package:json_annotation/json_annotation.dart';

part 'delete_clip_request.g.dart';

@JsonSerializable()
class DeleteClipRequest {
  @JsonKey(name: "clip_group_id")
  final int? clipGroupId;

  DeleteClipRequest ({
    this.clipGroupId,
  });

  factory DeleteClipRequest.fromJson(Map<String, dynamic> json) {
    return _$DeleteClipRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DeleteClipRequestToJson(this);
  }
}


