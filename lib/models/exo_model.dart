class ExoModel{

  String _exoNumber;
  String _exoName;
  String _reps;
  bool _isCompleted;

  ExoModel({String exoNumber, String exoName, String reps, bool isCompleted}){
    this._exoNumber = exoNumber;
    this._exoName = exoName;
    this._reps = reps;
    this._isCompleted = isCompleted;
  }

  Map<String, dynamic> toMap(ExoModel exo) {
    Map<String, dynamic> map = {
      "exoNumber": exo._exoNumber ?? "1",
      "exoName": exo._exoName ?? "Test Exo",
      "reps": exo._reps ?? "4,6,8",
      "isCompleted": exo._isCompleted ?? false,
    };

    return map;
  }

  ExoModel fromMap(Map<String, dynamic> map) {
    return new ExoModel(
      exoNumber: map["exoNumber"],
      exoName: map["exoName"],
      reps: map["reps"],
      isCompleted: map["isCompleted"],
    );
  }

  List<String> getReps(String repSheet){
    return repSheet.split(",");
  }

  String get reps => _reps;

  set reps(String value) {
    _reps = value;
  }

  String get exoName => _exoName;

  set exoName(String value) {
    _exoName = value;
  }

  String get exoNumber => _exoNumber;

  set exoNumber(String value) {
    _exoNumber = value;
  }

  bool get isCompleted => _isCompleted;

  set isCompleted(bool value) {
    _isCompleted = value;
  }
}