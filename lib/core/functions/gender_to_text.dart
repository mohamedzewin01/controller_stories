



String genderToText(String gender, String languageCode) {
  gender = gender.toLowerCase(); // لتفادي مشاكل الحروف الكبيرة

  if (languageCode == 'ar') {
    if (gender == 'male') return 'ولد';
    if (gender == 'female') return 'بنت';
  } else {
    if (gender == 'male') return 'Boy';
    if (gender == 'female') return 'Girl';
  }

  return '';
}