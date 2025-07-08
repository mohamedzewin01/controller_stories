


import '../../data/models/response/audio_file_empty_dto.dart';
import '../../data/models/response/get_names_audio_dto.dart';
import '../../data/models/response/search_name_audio_dto.dart';

class AddAudioNameEntity {

  final String? status;

  final String? message;

  AddAudioNameEntity ({
    this.status,
    this.message,
  });


}

class UpdateChildNameEntity  {

  final String? status;

  final String? message;

UpdateChildNameEntity ({
    this.status,
    this.message,
  });


}

class DeleteAudioNameEntity {

  final String? status;

  final String? message;

  DeleteAudioNameEntity ({
    this.status,
    this.message,
  });


}

class AudioFileEmptyEntity {

  final String? status;

  final int? total;

  final List<DataFileEmpty>? data;

  AudioFileEmptyEntity ({
    this.status,
    this.total,
    this.data,
  });


}

class SearchNameAudioEntity{

  final String? status;

  final int? count;

  final List<DataSearch>? data;

  SearchNameAudioEntity ({
    this.status,
    this.count,
    this.data,
  });


}

class GetNamesAudioEntity {

  final String? status;

  final int? currentPage;

  final int? perPage;

  final int? total;

  final int? totalPages;

  final List<DataAudio>? data;

  GetNamesAudioEntity ({
    this.status,
    this.currentPage,
    this.perPage,
    this.total,
    this.totalPages,
    this.data,
  });


}