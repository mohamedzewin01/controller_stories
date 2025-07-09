// // lib/features/AudioName/presentation/bloc/AudioName_cubit.dart
// import 'dart:io';
//
// import 'package:bloc/bloc.dart';
// import 'package:controller_stories/core/common/api_result.dart';
// import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:injectable/injectable.dart';
// import '../../domain/useCases/AudioName_useCase_repo.dart';
//
// part 'AudioName_state.dart';
//
// @injectable
// class AudioNameCubit extends Cubit<AudioNameState> {
//   AudioNameCubit(this._audioNameUseCaseRepo) : super(AudioNameInitial());
//   final AudioNameUseCaseRepo _audioNameUseCaseRepo;
//
//   static AudioNameCubit get(context) => BlocProvider.of(context);
//
//   // إضافة اسم مع ملف صوتي
//   Future<void> addAudioName(String childName, File audio) async {
//     emit(AddAudioNameLoading());
//     final result = await _audioNameUseCaseRepo.addAudioName(childName, audio);
//     switch (result) {
//       case Success<AddAudioNameEntity?>():
//         if (!isClosed) {
//           emit(AddAudioNameSuccess(result.data!));
//           // إعادة تحميل البيانات بعد الإضافة بنجاح
//           fetchNamesAudio();
//           nameAudioEmpty();
//         }
//         break;
//       case Fail<AddAudioNameEntity?>():
//         if (!isClosed) {
//           emit(AddAudioNameFailure(result.exception));
//         }
//         break;
//     }
//   }
//
//   Future<void> fetchNamesAudio() async {
//     emit(GetAudioNameLoading());
//     final result = await _audioNameUseCaseRepo.fetchNamesAudio();
//     switch (result) {
//       case Success<GetNamesAudioEntity?>():
//         if (!isClosed) {
//           emit(GetAudioNameSuccess(result.data!));
//         }
//         break;
//       case Fail<GetNamesAudioEntity?>():
//         if (!isClosed) {
//           emit(GetAudioNameFailure(result.exception));
//         }
//         break;
//     }
//   }
//
//   Future<void> editChildName(
//       int nameAudioId,
//       String name,
//       File audioFile,
//       ) async {
//     emit(EditAudioNameLoading());
//     final result = await _audioNameUseCaseRepo.editChildName(
//       nameAudioId,
//       name,
//       audioFile,
//     );
//     switch (result) {
//       case Success<UpdateChildNameEntity?>():
//         if (!isClosed) {
//           emit(EditAudioNameSuccess(result.data!));
//           // إعادة تحميل البيانات بعد التعديل بنجاح
//           fetchNamesAudio();
//           nameAudioEmpty();
//         }
//         break;
//       case Fail<UpdateChildNameEntity?>():
//         if (!isClosed) {
//           emit(EditAudioNameFailure(result.exception));
//         }
//         break;
//     }
//   }
//
//   Future<void> deleteChildName(int nameAudioId) async {
//     emit(DeleteAudioNameLoading());
//     final result = await _audioNameUseCaseRepo.deleteChildName(nameAudioId);
//
//     switch (result) {
//       case Success<DeleteAudioNameEntity?>():
//         if (!isClosed) {
//           emit(DeleteAudioNameSuccess(result.data!));
//           // إعادة تحميل البيانات بعد الحذف بنجاح
//           fetchNamesAudio();
//           nameAudioEmpty();
//         }
//         break;
//       case Fail<DeleteAudioNameEntity?>():
//         if (!isClosed) {
//           emit(DeleteAudioNameFailure(result.exception));
//         }
//         break;
//     }
//   }
//
//   Future<void> nameAudioEmpty() async {
//     emit(EmptyAudioNameLoading());
//     final result = await _audioNameUseCaseRepo.nameAudioEmpty();
//
//     switch (result) {
//       case Success<AudioFileEmptyEntity?>():
//         if (!isClosed) {
//           emit(EmptyAudioNameSuccess(result.data!));
//         }
//         break;
//       case Fail<AudioFileEmptyEntity?>():
//         if (!isClosed) {
//           emit(EmptyAudioNameFailure(result.exception));
//         }
//         break;
//     }
//   }
//
//   Future<void> searchAudioName(String name) async {
//     emit(SearchNameLoading());
//     final result = await _audioNameUseCaseRepo.searchAudioName(name);
//     switch (result) {
//       case Success<SearchNameAudioEntity?>():
//         if (!isClosed) {
//           emit(SearchNameSuccess(result.data!));
//         }
//         break;
//       case Fail<SearchNameAudioEntity?>():
//         if (!isClosed) {
//           emit(SearchNameFailure(result.exception));
//         }
//         break;
//     }
//   }
//
//   // إضافة وظيفة لإعادة تعيين حالة البحث والعودة لقائمة جميع الأسماء
//   void resetToAllNames() {
//     fetchNamesAudio();
//   }
//
//   // إضافة وظيفة لإيقاف أي عمليات جارية
//   void cancelOperations() {
//     if (!isClosed) {
//       emit(AudioNameInitial());
//     }
//   }
// }
// lib/features/AudioName/presentation/bloc/AudioName_cubit.dart
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:controller_stories/core/common/api_result.dart';
import 'package:controller_stories/features/AudioName/domain/entities/audio_name_entities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:injectable/injectable.dart';
import '../../domain/useCases/AudioName_useCase_repo.dart';

part 'AudioName_state.dart';

@injectable
class AudioNameCubit extends Cubit<AudioNameState> {
  AudioNameCubit(this._audioNameUseCaseRepo) : super(AudioNameInitial());
  final AudioNameUseCaseRepo _audioNameUseCaseRepo;

  static AudioNameCubit get(context) => BlocProvider.of(context);

  // إضافة اسم مع ملف صوتي
  Future<void> addAudioName(String childName, File audio) async {
    if (isClosed) return;

    emit(AddAudioNameLoading());

    try {
      final result = await _audioNameUseCaseRepo.addAudioName(childName, audio);

      if (isClosed) return;

      switch (result) {
        case Success<AddAudioNameEntity?>():
          emit(AddAudioNameSuccess(result.data!));
          // إعادة تحميل البيانات بعد الإضافة بنجاح
          await Future.delayed(const Duration(milliseconds: 500));
          if (!isClosed) {
            // await _refreshData();
          }
          break;
        case Fail<AddAudioNameEntity?>():
          emit(AddAudioNameFailure(result.exception));
          break;
      }
    } catch (e) {
      if (!isClosed) {
        emit(AddAudioNameFailure(Exception('خطأ في إضافة الاسم: ${e.toString()}')));
      }
    }
  }

  Future<void> fetchNamesAudio() async {
    if (isClosed) return;

    emit(GetAudioNameLoading());

    try {
      final result = await _audioNameUseCaseRepo.fetchNamesAudio();

      if (isClosed) return;

      switch (result) {
        case Success<GetNamesAudioEntity?>():
          emit(GetAudioNameSuccess(result.data!));
          break;
        case Fail<GetNamesAudioEntity?>():
          emit(GetAudioNameFailure(result.exception));
          break;
      }
    } catch (e) {
      if (!isClosed) {
        emit(GetAudioNameFailure(Exception('خطأ في تحميل البيانات: ${e.toString()}')));
      }
    }
  }

  Future<void> editChildName({ required int nameAudioId,
    String? name,
    File? audioFile,}
      ) async {
    if (isClosed) return;

    emit(EditAudioNameLoading());
    try {
      final result = await _audioNameUseCaseRepo.editChildName(

        nameAudioId,
        name,
        audioFile,
      );


      if (isClosed) return;

      switch (result) {
        case Success<UpdateChildNameEntity?>():
          emit(EditAudioNameSuccess(result.data!));
          // إعادة تحميل البيانات بعد التعديل بنجاح
          await Future.delayed(const Duration(milliseconds: 500));
          if (!isClosed) {
            await _refreshData();
          }
          break;
        case Fail<UpdateChildNameEntity?>():
          emit(EditAudioNameFailure(result.exception));
          break;
      }
    } catch (e) {
      if (!isClosed) {
        emit(EditAudioNameFailure(Exception('خطأ في تعديل الاسم: ${e.toString()}')));
      }
    }
  }

  Future<void> deleteChildName(int nameAudioId) async {
    if (isClosed) return;

    emit(DeleteAudioNameLoading());

    try {
      final result = await _audioNameUseCaseRepo.deleteChildName(nameAudioId);

      if (isClosed) return;

      switch (result) {
        case Success<DeleteAudioNameEntity?>():
          emit(DeleteAudioNameSuccess(result.data!));
          // إعادة تحميل البيانات بعد الحذف بنجاح
          await Future.delayed(const Duration(milliseconds: 500));
          if (!isClosed) {
            await _refreshData();
          }
          break;
        case Fail<DeleteAudioNameEntity?>():
          emit(DeleteAudioNameFailure(result.exception));
          break;
      }
    } catch (e) {
      if (!isClosed) {
        emit(DeleteAudioNameFailure(Exception('خطأ في حذف الاسم: ${e.toString()}')));
      }
    }
  }

  Future<void> nameAudioEmpty() async {
    if (isClosed) return;

    emit(EmptyAudioNameLoading());

    try {
      final result = await _audioNameUseCaseRepo.nameAudioEmpty();

      if (isClosed) return;

      switch (result) {
        case Success<AudioFileEmptyEntity?>():
          emit(EmptyAudioNameSuccess(result.data!));
          if (!isClosed) {
            await _refreshData();
          }
          break;
        case Fail<AudioFileEmptyEntity?>():
          emit(EmptyAudioNameFailure(result.exception));
          break;
      }
    } catch (e) {
      if (!isClosed) {
        emit(EmptyAudioNameFailure(Exception('خطأ في تحميل البيانات الفارغة: ${e.toString()}')));
      }
    }
  }

  Future<void> searchAudioName(String name) async {
    if (isClosed) return;

    if (name.trim().isEmpty) {
      await fetchNamesAudio();
      return;
    }

    emit(SearchNameLoading());

    try {
      final result = await _audioNameUseCaseRepo.searchAudioName(name);

      if (isClosed) return;

      switch (result) {
        case Success<SearchNameAudioEntity?>():
          emit(SearchNameSuccess(result.data!));
          break;
        case Fail<SearchNameAudioEntity?>():
          emit(SearchNameFailure(result.exception));
          break;
      }
    } catch (e) {
      if (!isClosed) {
        emit(SearchNameFailure(Exception('خطأ في البحث: ${e.toString()}')));
      }
    }
  }


  Future<void> _refreshData() async {
    try {
      // تحميل قائمة الأسماء
      await fetchNamesAudio();


    } catch (e) {

    }
  }

  // إضافة وظيفة لإعادة تعيين حالة البحث والعودة لقائمة جميع الأسماء
  void resetToAllNames() {
    if (!isClosed) {
      fetchNamesAudio();
    }
  }

  // إضافة وظيفة لإيقاف أي عمليات جارية
  void cancelOperations() {
    if (!isClosed) {
      emit(AudioNameInitial());
    }
  }

  // إضافة وظيفة لإعادة تحميل جميع البيانات يدوياً
  Future<void> refreshAllData() async {
    if (!isClosed) {
      await _refreshData();
    }
  }
}