import 'package:json_annotation/json_annotation.dart';

part 'fetch_clips_request.g.dart';

@JsonSerializable()
class FetchClipsRequest {
  @JsonKey(name: "story_id")
  final int? storyId;

  FetchClipsRequest ({
    this.storyId,
  });

  factory FetchClipsRequest.fromJson(Map<String, dynamic> json) {
    return _$FetchClipsRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$FetchClipsRequestToJson(this);
  }
}


