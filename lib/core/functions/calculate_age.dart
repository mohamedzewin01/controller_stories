






String calculateAgeInYearsAndMonths(String birthDateString, String languageCode) {
  // إزالة الوقت إن وجد
  String cleanDateString = birthDateString.split(' ')[0]; // يحتفظ فقط بالتاريخ "yyyy-MM-dd"

  // تحويل النص إلى كائن تاريخ
  DateTime birthDate = DateTime.parse(cleanDateString);
  DateTime today = DateTime.now();

  int years = today.year - birthDate.year;
  int months = today.month - birthDate.month;

  if (months < 0) {
    years--;
    months += 12;
  }

  if (languageCode == 'ar') {
    return '$years سنة - \u200E $months شهر';
  } else {
    return '$years years - $months months';
  }
}
