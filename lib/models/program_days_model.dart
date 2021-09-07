class ProgramDaysModel{

  String _dayId;
  String _dayNumber;
  String _dayName;

  ProgramDaysModel({String dayId, String dayNumber, String dayName}){
    this._dayId = dayId;
    this._dayNumber = dayNumber;
    this._dayName = dayName;
  }

  Map<String, dynamic> toMap(ProgramDaysModel program) {
    Map<String, dynamic> map = {
      "dayId": program._dayId ?? "",
      "dayNumber": program._dayNumber ?? "1",
      "dayName": program._dayName ?? "Test Day",
    };

    return map;
  }

  ProgramDaysModel fromMap(Map<String, dynamic> map) {
    return new ProgramDaysModel(
        dayId: map["dayId"],
        dayNumber: map["dayNumber"],
        dayName: map["dayName"]
    );
  }

  String get dayName => _dayName;

  set dayName(String value) {
    _dayName = value;
  }

  String get dayNumber => _dayNumber;

  set dayNumber(String value) {
    _dayNumber = value;
  }

  String get dayId => _dayId;

  set dayId(String value) {
    _dayId = value;
  }
}