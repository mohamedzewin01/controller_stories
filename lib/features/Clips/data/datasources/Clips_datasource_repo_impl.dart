import 'dart:io';

import 'package:controller_stories/core/api/api_extentions.dart';
import 'package:controller_stories/core/api/api_manager/api_manager.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/Clips/data/models/request/clip_model_request.dart';
import 'package:controller_stories/features/Clips/data/models/request/delete_clip_request.dart';
import 'package:controller_stories/features/Clips/data/models/request/fetch_clips_request.dart';
import 'package:controller_stories/features/Clips/data/models/response/add_clips_dto.dart';
import 'package:controller_stories/features/Clips/domain/entities/delete_clip.dart';
import 'package:controller_stories/features/Clips/domain/entities/fetch_clips_entity.dart';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'Clips_datasource_repo.dart';
import 'package:injectable/injectable.dart';
import 'dart:convert';

@Injectable(as: ClipsDatasourceRepo)
class ClipsDatasourceRepoImpl implements ClipsDatasourceRepo {
  final ApiService apiService;

  ClipsDatasourceRepoImpl(this.apiService);

  @override
  Future<AddClipsDto?> addClips({
    required List<ClipModelRequest> clips,
    required List<File> images,
    required List<File> audios,
  }) async {
    try {
      // تأكد من عدد الصور والصوتيات مطابق لعدد المقاطع
      if (images.length != clips.length || audios.length != clips.length) {
        throw Exception('عدد الصور أو الصوتيات لا يطابق عدد المقاطع');
      }

      // 1. تحويل JSON الخاص بـ clips إلى String
      final clipsJson = clips.map((e) => e.toJson()).toList();
      final clipsJsonString = jsonEncode(clipsJson);

      // 2. تجهيز FormData
      final formData = FormData();

      // clips (كـ JSON)
      formData.fields.add(MapEntry('clips', clipsJsonString));

      // رفع الصور والصوت
      for (int i = 0; i < clips.length; i++) {
        // صور
        final imageFile = await MultipartFile.fromFile(
          images[i].path,
          filename: 'image_$i.png',
          contentType: MediaType('image', 'png'),
        );
        formData.files.add(MapEntry('image_$i', imageFile));

        // صوتيات
        final audioFile = await MultipartFile.fromFile(
          audios[i].path,
          filename: 'audio_$i.mp3',
          contentType: MediaType('audio', 'mpeg'),
        );
        formData.files.add(MapEntry('audio_$i', audioFile));
      }

      // 3. إرسال الطلب إلى السيرفر
      final response = await Dio().post(
        'controller/clips/add_clips_story',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      // 4. تحويل الاستجابة إلى كيان AddClipsEntity
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return AddClipsDto.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('addClips error: $e');
      return null;
    }
  }

  @override
  Future<Result<FetchClipsEntity?>> fetchClips(int storyId) {
    return executeApi(() async {
      var response = await apiService.fetchClips(
        FetchClipsRequest(storyId: storyId),
      );
      return response?.toEntity();
    });
  }

  @override
  Future<Result<DeleteClipEntity?>> deleteClip(int clipGroupId) {
    return executeApi(() async {
      var response = await apiService.deleteClip(
        DeleteClipRequest(clipGroupId: clipGroupId),
      );
      return response?.toEntity();
    },);
  }

  @override
  Future<bool> updateClips({
    required List<ClipModelRequest> clips,
    List<File?>? images,
    List<File?>? audios,
  }) async {
    try {
      // تأكد من الصور والصوت (لو موجودين) بعدد مطابق للمقاطع
      if ((images != null && images.length != clips.length) ||
          (audios != null && audios.length != clips.length)) {
        throw Exception('عدد الصور أو الصوتيات لا يطابق عدد المقاطع');
      }

      // 1. تحويل JSON الخاص بالمقاطع
      final clipsJson = clips.map((e) => e.toJson()).toList();
      final clipsJsonString = jsonEncode(clipsJson);

      // 2. تجهيز FormData
      final formData = FormData();
      formData.fields.add(MapEntry('clips', clipsJsonString));

      // 3. رفع الصور والصوتيات حسب المتوفر
      for (int i = 0; i < clips.length; i++) {
        // صور
        if (images != null && images[i] != null) {
          final imageFile = await MultipartFile.fromFile(
            images[i]!.path,
            filename: 'image_$i.png',
            contentType: MediaType('image', 'png'),
          );
          formData.files.add(MapEntry('image_$i', imageFile));
        }

        // صوتيات
        if (audios != null && audios[i] != null) {
          final audioFile = await MultipartFile.fromFile(
            audios[i]!.path,
            filename: 'audio_$i.mp3',
            contentType: MediaType('audio', 'mpeg'),
          );
          formData.files.add(MapEntry('audio_$i', audioFile));
        }
      }

      // 4. إرسال الطلب
      final response = await Dio().post(
        'controller/clips/update_clips_story.php',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      // 5. التحقق من الاستجابة
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return true;
      }

      print('updateClips failed: ${response.data}');
      return false;
    } catch (e) {
      print('updateClips error: $e');
      return false;
    }
  }

}
