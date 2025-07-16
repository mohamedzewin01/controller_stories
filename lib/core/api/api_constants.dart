class ApiConstants {
  static const String baseUrl = "https://artawiya.com/wisechild/api/";
  static const String urlImage = "https://artawiya.com/wisechild/api/upload/";
  static const String urlAudio = "https://artawiya.com/wisechild/api/audio/";

  ///--------------------------------------------------------------------------///
  static const String insertCategory = "controller/category/insert_category";
  static const String fetchCategories = "controller/category/fetch_categories";
  static const String updateCategory = "controller/category/update_category";
  static const String deleteCategory = "controller/category/delete_category";
  ///-
  static const String addStory = "controller/story/add_story";
  static const String fetchStoriesByCategory = "controller/story/fetch_stories_by_category";
  static const String deleteStory = "controller/story/delete_story";
  static const String updateStory = "controller/story/update_story";
  ///-
  static const String fetchClips = "controller/clips/fetch_clips_by_story";
  static const String addClip = "controller/clips/add_clip_story";
  static const String deleteClip = "controller/clips/delete_clip";
  static const String editClip = "controller/clips/update_clip_story";
  ///-
  static const String addChildName = "controller/audio_name/add_child_name";
  static const String deleteChildName = "controller/audio_name/delete_child_name";
  static const String updateChildName = "controller/audio_name/update_child_name";
  static const String searchAudioName = "controller/audio_name/search";
  static const String nameAudioEmpty = "controller/audio_name/name_null";
  static const String fetchNamesAudio = "controller/audio_name/fetch_names_audio";
  ///-
  static const String addProblem = "controller/problems/add_problem";
  static const String getProblems = "controller/problems/get_problems";
  static const String deleteProblem = "controller/problems/delete_problem";
  static const String updateProblem = "controller/problems/update_problem";
  ///-
 static const String getStoryRequests = "story_requests/get_requests_stories";
 static const String addReplies = "story_requests/story_request_replies";
 static const String getAllStories = "story_requests/get_all_stories";
}
