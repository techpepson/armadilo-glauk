import 'package:glauk/core/constants/constants.dart';

class UtilService {
  List<Map<String, dynamic>> getSlidesByStatus(
    String? status,
    List<Map<String, dynamic>>? arrayValues,
  ) {
    return arrayValues
            ?.where((slide) => slide['solutionStatus'] == status)
            .toList() ??
        [];
  }

  DateTime convertStringToDateTime(String? stringDate) {
    DateTime parsedDate = DateTime.parse(stringDate ?? "2025-01-01");
    return parsedDate;
  }

  // Safely parse a date string; returns null if invalid
  DateTime? _tryParseDate(String? stringDate) {
    if (stringDate == null) return null;
    try {
      return DateTime.parse(stringDate);
    } catch (_) {
      return null;
    }
  }

  List<Map<String, dynamic>> valuesByWeek(
    List<Map<String, dynamic>>? array,
    String? dateParam,
  ) {
    if (array == null || dateParam == null) return [];

    final now = DateTime.now();
    final start = now.subtract(Duration(days: 7));

    bool isOnOrAfter(DateTime a, DateTime b) =>
        a.isAtSameMomentAs(b) || a.isAfter(b);
    bool isOnOrBefore(DateTime a, DateTime b) =>
        a.isAtSameMomentAs(b) || a.isBefore(b);

    final returnedArray = array.where((value) {
      final date = _tryParseDate(value[dateParam] as String?);
      if (date == null) return false;
      // Keep only dates in [start, now]
      return isOnOrAfter(date, start) && isOnOrBefore(date, now);
    });

    return returnedArray.toList();
  }

  List<Map<String, dynamic>> valuesByMonth(
    List<Map<String, dynamic>>? array,
    String? dateParam,
  ) {
    final now = DateTime.now();
    final earlier = now.subtract(Duration(days: 28));
    final returnedArray = array?.where((value) {
      final date = _tryParseDate(value[dateParam] as String?);
      if (date == null) return false;
      return earlier.isBefore(date);
    });

    return returnedArray?.toList() ?? [];
  }

  //reduce uses the function or rule you define
  double highestScore(List<Map<String, dynamic>> array, String scoreParam) {
    return array.isEmpty
        ? 0.0
        : (array.reduce(
                  (a, b) =>
                      (a[scoreParam] as num? ?? 0).toDouble() >
                              (b[scoreParam] as num? ?? 0).toDouble()
                          ? a
                          : b,
                )[scoreParam]
                as num)
            .toDouble();
  }

  double lowestScore(List<Map<String, dynamic>> array, String scoreParam) {
    return array.isEmpty
        ? 0.0
        : (array.reduce(
                  (a, b) =>
                      (a[scoreParam] as num? ?? 0).toDouble() <
                              (b[scoreParam] as num? ?? 0).toDouble()
                          ? a
                          : b,
                )[scoreParam]
                as num)
            .toDouble();
  }

  // Average score across all items for the given scoreParam
  double overallScore(List<Map<String, dynamic>> array, String scoreParam) {
    if (array.isEmpty) return 0.0;
    final sum = array.fold<double>(0.0, (acc, e) {
      final v = e[scoreParam];
      final asNum = (v is num) ? v.toDouble() : 0.0;
      return acc + asNum;
    });
    return sum / array.length;
  }

  String getDisplayImage(String studyField) {
    String courseDisplayImage;
    switch (studyField) {
      case 'science':
        courseDisplayImage = Constants.scienceImage;
        break;
      case 'computing':
        courseDisplayImage = Constants.computingImage;
        break;
      case 'business':
        courseDisplayImage = Constants.businessImage;
        break;
      case 'arts':
        courseDisplayImage = Constants.artsImage;
        break;
      case 'english':
        courseDisplayImage = Constants.englishImage;
        break;
      case 'humanities':
        courseDisplayImage = Constants.humanitiesImage;
        break;
      case 'languages':
        courseDisplayImage = Constants.languagesImage;
        break;
      case 'maths':
        courseDisplayImage = Constants.mathsImage;
        break;
      case 'others':
        courseDisplayImage = Constants.othersImage;
        break;
      case 'statistics':
        courseDisplayImage = Constants.statisticsImage;
        break;
      default:
        courseDisplayImage = Constants.scienceImage;
    }
    return courseDisplayImage;
  }

  dynamic getCurrentStreak() {}
  dynamic getLongestStreak() {}
}
