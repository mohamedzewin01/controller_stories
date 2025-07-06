import 'package:json_annotation/json_annotation.dart';

part 'clip_model_request.g.dart';

@JsonSerializable()
class ClipModelRequest {
  @JsonKey(name: 'story_id')
  final int storyId;

  @JsonKey(name: 'clip_text')
  final String clipText;

  @JsonKey(name: 'image_url')
  final String imageUrl;

  @JsonKey(name: 'audio_url')
  final String audioUrl;

  @JsonKey(name: 'sort_order')
  final int sortOrder;

  @JsonKey(name: 'insert_child_name', fromJson: _boolFromString, toJson: _boolToString)
  final bool insertChildName;

  @JsonKey(name: 'pause_after_name')
  final int pauseAfterName;

  @JsonKey(name: 'insert_siblings_name', fromJson: _boolFromString, toJson: _boolToString)
  final bool insertSiblingsName;

  @JsonKey(name: 'insert_friends_name', fromJson: _boolFromString, toJson: _boolToString)
  final bool insertFriendsName;

  @JsonKey(name: 'insert_best_playmate', fromJson: _boolFromString, toJson: _boolToString)
  final bool insertBestPlaymate;

  ClipModelRequest({
    required this.storyId,
    required this.clipText,
    required this.imageUrl,
    required this.audioUrl,
    required this.sortOrder,
    this.insertChildName = false,
    this.pauseAfterName = 1000,
    this.insertSiblingsName = false,
    this.insertFriendsName = false,
    this.insertBestPlaymate = false,
  });

  factory ClipModelRequest.fromJson(Map<String, dynamic> json) => _$ClipModelRequestFromJson(json);
  Map<String, dynamic> toJson() => _$ClipModelRequestToJson(this);

  static bool _boolFromString(String value) => value.toLowerCase() == 'true';
  static String _boolToString(bool value) => value ? 'true' : 'false';
}
