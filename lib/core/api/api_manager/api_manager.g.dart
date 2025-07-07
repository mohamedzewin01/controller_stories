// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_manager.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter

class _ApiService implements ApiService {
  _ApiService(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://artawiya.com/wisechild/api/';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<FetchCategoriesDto?> fetchCategories() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<FetchCategoriesDto>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'controller/category/fetch_categories',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late FetchCategoriesDto? _value;
    try {
      _value = _result.data == null
          ? null
          : FetchCategoriesDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<InsertCategoryDto?> insertCategory(
    InsertCategoryRequest insertCategoryRequest,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(insertCategoryRequest.toJson());
    final _options = _setStreamType<InsertCategoryDto>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'controller/category/insert_category',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late InsertCategoryDto? _value;
    try {
      _value = _result.data == null
          ? null
          : InsertCategoryDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<UpdateCategoryDto?> updateCategory(
    UpdateCategoryRequest updateCategoryRequest,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateCategoryRequest.toJson());
    final _options = _setStreamType<UpdateCategoryDto>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'controller/category/update_category',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late UpdateCategoryDto? _value;
    try {
      _value = _result.data == null
          ? null
          : UpdateCategoryDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DeleteCategoryDto?> deleteCategory(
    DeleteCategoryRequest deleteCategoryRequest,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(deleteCategoryRequest.toJson());
    final _options = _setStreamType<DeleteCategoryDto>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'controller/category/delete_category',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late DeleteCategoryDto? _value;
    try {
      _value = _result.data == null
          ? null
          : DeleteCategoryDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<FetchStoriesByCategoryDto?> fetchStoriesByCategory(
    FetchStoriesByCategoryRequest fetchStoriesByCategoryRequest,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(fetchStoriesByCategoryRequest.toJson());
    final _options = _setStreamType<FetchStoriesByCategoryDto>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'controller/story/fetch_stories_by_category',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late FetchStoriesByCategoryDto? _value;
    try {
      _value = _result.data == null
          ? null
          : FetchStoriesByCategoryDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DeleteStoryDto?> deleteStory(
    DeleteStoryRequest deleteStoryRequest,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(deleteStoryRequest.toJson());
    final _options = _setStreamType<DeleteStoryDto>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'controller/story/delete_story',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late DeleteStoryDto? _value;
    try {
      _value = _result.data == null
          ? null
          : DeleteStoryDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AddStoryDto?> addStory(
    String? title,
    String? storyDescription,
    int? problemId,
    String? gender,
    String? ageGroup,
    int? categoryId,
    int? isActive,
    File? imageCover,
    String? bestFriendGender,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (title != null) {
      _data.fields.add(MapEntry('story_title', title));
    }
    if (storyDescription != null) {
      _data.fields.add(MapEntry('story_description', storyDescription));
    }
    if (problemId != null) {
      _data.fields.add(MapEntry('problem_id', problemId.toString()));
    }
    if (gender != null) {
      _data.fields.add(MapEntry('gender', gender));
    }
    if (ageGroup != null) {
      _data.fields.add(MapEntry('age_group', ageGroup));
    }
    if (categoryId != null) {
      _data.fields.add(MapEntry('category_id', categoryId.toString()));
    }
    if (isActive != null) {
      _data.fields.add(MapEntry('is_active', isActive.toString()));
    }
    if (imageCover != null) {
      _data.files.add(
        MapEntry(
          'image_cover',
          MultipartFile.fromFileSync(
            imageCover.path,
            filename: imageCover.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    if (bestFriendGender != null) {
      _data.fields.add(MapEntry('best_friend_gender', bestFriendGender));
    }
    final _options = _setStreamType<AddStoryDto>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'controller/story/add_story',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late AddStoryDto? _value;
    try {
      _value = _result.data == null
          ? null
          : AddStoryDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<UpdateStoryDto?> updateStory(
    int storyId,
    String? title,
    String? storyDescription,
    int? problemId,
    String? gender,
    String? ageGroup,
    int? categoryId,
    int? isActive,
    File? imageCover,
    String? bestFriendGender,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('story_id', storyId.toString()));
    if (title != null) {
      _data.fields.add(MapEntry('story_title', title));
    }
    if (storyDescription != null) {
      _data.fields.add(MapEntry('story_description', storyDescription));
    }
    if (problemId != null) {
      _data.fields.add(MapEntry('problem_id', problemId.toString()));
    }
    if (gender != null) {
      _data.fields.add(MapEntry('gender', gender));
    }
    if (ageGroup != null) {
      _data.fields.add(MapEntry('age_group', ageGroup));
    }
    if (categoryId != null) {
      _data.fields.add(MapEntry('category_id', categoryId.toString()));
    }
    if (isActive != null) {
      _data.fields.add(MapEntry('is_active', isActive.toString()));
    }
    if (imageCover != null) {
      _data.files.add(
        MapEntry(
          'image_cover',
          MultipartFile.fromFileSync(
            imageCover.path,
            filename: imageCover.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    if (bestFriendGender != null) {
      _data.fields.add(MapEntry('best_friend_gender', bestFriendGender));
    }
    final _options = _setStreamType<UpdateStoryDto>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'controller/story/update_story',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late UpdateStoryDto? _value;
    try {
      _value = _result.data == null
          ? null
          : UpdateStoryDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<FetchClipsDto?> fetchClips(FetchClipsRequest fetchClipsRequest) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(fetchClipsRequest.toJson());
    final _options = _setStreamType<FetchClipsDto>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'controller/clips/fetch_clips_by_story',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late FetchClipsDto? _value;
    try {
      _value = _result.data == null
          ? null
          : FetchClipsDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DeleteClipDto?> deleteClip(DeleteClipRequest deleteClipRequest) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(deleteClipRequest.toJson());
    final _options = _setStreamType<DeleteClipDto>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'controller/clips/delete_clip',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late DeleteClipDto? _value;
    try {
      _value = _result.data == null
          ? null
          : DeleteClipDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AddClipsDto?> addClip(
    int storyId,
    String? clipText,
    String? sortOrder,
    int? afterName,
    bool? childName,
    bool? siblingsName,
    bool? friendsName,
    bool? bestFriendGender,
    bool? imageFavorite,
    File? image,
    File? audio,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('story_id', storyId.toString()));
    if (clipText != null) {
      _data.fields.add(MapEntry('clip_text', clipText));
    }
    if (sortOrder != null) {
      _data.fields.add(MapEntry('sort_order', sortOrder));
    }
    if (afterName != null) {
      _data.fields.add(MapEntry('pause_after_name', afterName.toString()));
    }
    if (childName != null) {
      _data.fields.add(MapEntry('insert_child_name', childName.toString()));
    }
    if (siblingsName != null) {
      _data.fields.add(
        MapEntry('insert_siblings_name', siblingsName.toString()),
      );
    }
    if (friendsName != null) {
      _data.fields.add(MapEntry('insert_friends_name', friendsName.toString()));
    }
    if (bestFriendGender != null) {
      _data.fields.add(
        MapEntry('insert_best_playmate', bestFriendGender.toString()),
      );
    }
    if (imageFavorite != null) {
      _data.fields.add(
        MapEntry('kids_favorite_images', imageFavorite.toString()),
      );
    }
    if (image != null) {
      _data.files.add(
        MapEntry(
          'image',
          MultipartFile.fromFileSync(
            image.path,
            filename: image.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    if (audio != null) {
      _data.files.add(
        MapEntry(
          'audio',
          MultipartFile.fromFileSync(
            audio.path,
            filename: audio.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    final _options = _setStreamType<AddClipsDto>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'controller/clips/add_clip_story',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late AddClipsDto? _value;
    try {
      _value = _result.data == null
          ? null
          : AddClipsDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<EditClipDto?> editClip(
    int clipGroupId,
    String? clipText,
    int? afterName,
    int? sortOrder,
    bool? childName,
    bool? siblingsName,
    bool? friendsName,
    bool? bestFriendGender,
    bool? imageFavorite,
    File? image,
    File? audio,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('clip_group_id', clipGroupId.toString()));
    if (clipText != null) {
      _data.fields.add(MapEntry('clip_text', clipText));
    }
    if (afterName != null) {
      _data.fields.add(MapEntry('pause_after_name', afterName.toString()));
    }
    if (sortOrder != null) {
      _data.fields.add(MapEntry('sort_order', sortOrder.toString()));
    }
    if (childName != null) {
      _data.fields.add(MapEntry('insert_child_name', childName.toString()));
    }
    if (siblingsName != null) {
      _data.fields.add(
        MapEntry('insert_siblings_name', siblingsName.toString()),
      );
    }
    if (friendsName != null) {
      _data.fields.add(MapEntry('insert_friends_name', friendsName.toString()));
    }
    if (bestFriendGender != null) {
      _data.fields.add(
        MapEntry('insert_best_playmate', bestFriendGender.toString()),
      );
    }
    if (imageFavorite != null) {
      _data.fields.add(
        MapEntry('kids_favorite_images', imageFavorite.toString()),
      );
    }
    if (image != null) {
      _data.files.add(
        MapEntry(
          'image',
          MultipartFile.fromFileSync(
            image.path,
            filename: image.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    if (audio != null) {
      _data.files.add(
        MapEntry(
          'audio',
          MultipartFile.fromFileSync(
            audio.path,
            filename: audio.path.split(Platform.pathSeparator).last,
          ),
        ),
      );
    }
    final _options = _setStreamType<EditClipDto>(
      Options(
            method: 'POST',
            headers: _headers,
            extra: _extra,
            contentType: 'multipart/form-data',
          )
          .compose(
            _dio.options,
            'controller/clips/update_clip_story',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late EditClipDto? _value;
    try {
      _value = _result.data == null
          ? null
          : EditClipDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<GetProblemsDto?> getProblems() async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<GetProblemsDto>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'controller/problems/get_problems',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late GetProblemsDto? _value;
    try {
      _value = _result.data == null
          ? null
          : GetProblemsDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<AddProblemDto?> addProblem(AddProblemRequest addProblemRequest) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(addProblemRequest.toJson());
    final _options = _setStreamType<AddProblemDto>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'controller/problems/add_problem',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late AddProblemDto? _value;
    try {
      _value = _result.data == null
          ? null
          : AddProblemDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<UpdateProblemDto?> updateProblem(
    UpdateProblemRequest updateProblemRequest,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateProblemRequest.toJson());
    final _options = _setStreamType<UpdateProblemDto>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'controller/problems/update_problem',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late UpdateProblemDto? _value;
    try {
      _value = _result.data == null
          ? null
          : UpdateProblemDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<DeleteProblemDto?> deleteProblem(
    DeleteProblemRequest updateProblemRequest,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(updateProblemRequest.toJson());
    final _options = _setStreamType<DeleteProblemDto>(
      Options(method: 'POST', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            'controller/problems/delete_problem',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>?>(_options);
    late DeleteProblemDto? _value;
    try {
      _value = _result.data == null
          ? null
          : DeleteProblemDto.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
