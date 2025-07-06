


import 'package:controller_stories/features/Clips/data/models/response/fetch_clips_dto.dart';

class FetchClipsEntity {

  final String? status;

  final String? message;

  final int? count;

  final List<Clips>? clips;

  FetchClipsEntity ({
    this.status,
    this.message,
    this.count,
    this.clips,
  });


}