// class ProgramModel {
//   String _programId;
//   String _programName;
//   String _programOwnerId;
//   String _programOwnerName;
//   String _programPrice;

//   ProgramModel(
//       {String programID,
//       String programName,
//       String programOwnerID,
//       String programOwnerName,
//       String programPrice}) {
//     this._programId = programID;
//     this._programName = programName;
//     this._programOwnerId = programOwnerID;
//     this._programOwnerName = programOwnerName;
//     this._programPrice = programPrice;
//   }

//   Map<String, dynamic> toMap(ProgramModel program) {
//     Map<String, dynamic> map = {
//       "programId": program._programId,
//       "programName": program._programName ?? "@Ronaldo",
//       "programOwnerId": program._programOwnerId ?? "John Doe",
//       "programOwnerName": program.programOwnerName ?? "John Doe",
//       "programPrice": program.programPrice ?? null
//     };

//     return map;
//   }

//   ProgramModel fromMap(Map<String, dynamic> map) {
//     return new ProgramModel(
//         programID: map["programId"],
//         programName: map["programName"],
//         programOwnerID: map["programOwnerId"],
//         programOwnerName: map["programOwnerName"],
//         programPrice: map["programPrice"]);
//   }

//   String get programPrice => _programPrice;

//   set programPrice(String value) {
//     _programPrice = value;
//   }

//   String get programName => _programName;

//   set programName(String value) {
//     _programName = value;
//   }

//   String get programOwnerName => _programOwnerName;

//   set programOwnerName(String value) {
//     _programOwnerName = value;
//   }

//   String get programOwnerID => _programOwnerId;

//   set programOwnerID(String value) {
//     _programOwnerId = value;
//   }

//   String get programID => _programId;

//   set programID(String value) {
//     _programId = value;
//   }
// }
