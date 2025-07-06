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
  static const String fetchClips = "controller/clips/fetch_clips_by_story.php";
  static const String addClip = "controller/clips/add_clip_story";
  static const String deleteClip = "controller/clips/delete_clip";
  static const String editClip = "controller/clips/update_clip_story";
  ///-


}
