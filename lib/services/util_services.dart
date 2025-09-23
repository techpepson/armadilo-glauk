class UtilService {
  List<Map<String, dynamic>> getSlidesByStatus(
    String status,
    List<Map<String, dynamic>> arrayValues,
  ) {
    return arrayValues
        .where((slide) => slide['solutionStatus'] == status)
        .toList();
  }
}
