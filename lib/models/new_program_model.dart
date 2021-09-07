class NewProgramModel {
  String _programId;
  String _programName;
  String _sellerName;
  String _price;
  String _programDuration;
  String _storage;

  static String nullValue = "...";

  NewProgramModel(
      {String programID,
        String programName,
        String sellerName,
        String price,
        String programDuration,
        String storage}) {
    this._programId = programID;
    this._programName = programName;
    this._sellerName = sellerName;
    this._price = price;
    this._programDuration = programDuration;
    this._storage = storage;
  }

  Map<String, dynamic> toMap(NewProgramModel program) {
    Map<String, dynamic> map = {
      "programId": program._programId ?? "test_program_id",
      "programName": program._programName ?? "Test Program",
      "sellerName": program._sellerName ?? "@Test",
      "price": program._price ?? "0.0",
      "programDuration": program._programDuration ?? "1",
      "storage": program._storage ?? "Firefit",
    };

    return map;
  }

  NewProgramModel fromMap(Map<String, dynamic> map) {
    return new NewProgramModel(
        programID: map["programId"],
        programName: map["programName"],
        sellerName: map["sellerName"],
        price: map["price"],
        programDuration: map["programDuration"],
        storage: map["storage"]);
  }

  String get storage => _storage;

  set storage(String value) {
    _storage = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  String get sellerName => _sellerName;

  set sellerName(String value) {
    _sellerName = value;
  }

  String get programName => _programName;

  set programName(String value) {
    _programName = value;
  }

  String get programId => _programId;

  set programId(String value) {
    _programId = value;
  }

  String get programDuration => _programDuration;

  set programDuration(String value) {
    _programDuration = value;
  }
}
