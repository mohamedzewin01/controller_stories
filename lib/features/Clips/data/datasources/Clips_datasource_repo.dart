import 'dart:io';

import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Clips/data/models/request/clip_model_request.dart';
import 'package:controller_stories/features/Clips/data/models/response/add_clips_dto.dart';
import 'package:controller_stories/features/Clips/domain/entities/delete_clip.dart';
import 'package:controller_stories/features/Clips/domain/entities/fetch_clips_entity.dart';



abstract class ClipsDatasourceRepo {

  Future<Result<FetchClipsEntity?>>fetchClips(int storyId);
  Future<AddClipsDto?> addClips({
    required List<ClipModelRequest> clips,
    required List<File> images,
    required List<File> audios,
  });
  Future<Result<DeleteClipEntity?>> deleteClip(int clipGroupId);
  Future<bool> updateClips({
    required List<ClipModelRequest> clips,
    List<File?>? images,
    List<File?>? audios,
  });


}
