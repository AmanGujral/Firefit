class ProgramModel {
  static List<String> urls = [];
  static List<dynamic> days = [];

  Future<void> initPrograms(
      {List<dynamic> daysProject, List<String> urlsProject}) {
    String nullValue = "...";
    if (urlsProject != null) {
      urls = [];
      urls = urlsProject;
    }

    if (daysProject != null) {
      days = [];
      days = daysProject;
    }

    return null;
  }
}
