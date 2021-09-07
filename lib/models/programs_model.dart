class ProgramsModel {
  static List<String> uidPrograms = _uidPrograms;
  static List<String> storages = _storages;
  static List<String> sellerNames = _sellerNames;
  static List<dynamic> programs = _programs;
  static List<String> programNames = _programsNames;
  static List<double> price = _price;

  static List<String> _uidPrograms = [];
  static List<String> _storages = [];
  static List<String> _sellerNames = [];
  static List<dynamic> _programs = [];
  static List<String> _programsNames = [];
  static List<double> _price = [];

  static String nullValue = "...";

  Future<void> initPrograms(
      {List<dynamic> documents, List<String> documentsIds}) {
    if (documentsIds != null) {
      _uidPrograms = [];
      _uidPrograms = documentsIds;
    }

    if (documents != null) {
      _storages = [];
      _sellerNames = [];
      _programs = [];
      _programsNames = [];
      _price = [];
      documents.forEach((document) {
        _storages.add(document["storage"] ?? nullValue);
        _sellerNames.add(document["sellerName"] ?? nullValue);
        _programsNames.add(document["programName"] ?? nullValue);
        _programs.add(document["days"] ?? []);
        _price.add(document["price"] ?? 99.95);
      });
    }

    return null;
  }
}
