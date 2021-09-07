

class UserModel{

  String _userId;
  String _userEmail;
  String _userName;
  String _userImageUrl;
  bool _isSeller = false;
  List<String> _userSubscriptions;

  static UserModel _userInstance;

  UserModel();

  UserModel.withInfo({String userId, String userName, String userEmail, String userImageUrl, bool isSeller, List<String> userSubs}){
    this._userId = userId ?? '';
    this._userName = userName ?? 'John Doe';
    this._userEmail = userEmail ?? 'JohnDoe@example.com';
    this._isSeller = isSeller ?? false;
    this._userImageUrl = userImageUrl ?? null;
    this._userSubscriptions = userSubs ?? null;
  }

  UserModel getInstance(){
    if(_userInstance == null)
      _userInstance = new UserModel();

    return _userInstance;
  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "userId": this._userId,
      "userName": this._userName ?? "John Doe",
      "userEmail": this._userEmail ?? "JohnDoe@example.com",
      "userImageUrl": this._userImageUrl ?? null,
      "isSeller": this._isSeller ?? false
    };

    return map;
  }

  void fromMap(Map<String, dynamic> map){
    this._userId = map["userId"];
    this._userName = map["userName"] ?? "John Doe";
    this._userEmail = map["userEmail"] ?? "JohnDoe@example.com";
    this._userImageUrl = map["userImageUrl"] ?? null;
    this._isSeller = map["isSeller"] ?? false;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get userEmail => _userEmail;


  String get userImageUrl => _userImageUrl;

  set userImageUrl(String value) {
    _userImageUrl = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }

  set userEmail(String value) {
    _userEmail = value;
  }


  bool get isSeller => _isSeller;

  set isSeller(bool value) {
    _isSeller = value;
  }

  List<String> get userSubscriptions => _userSubscriptions;

  set userSubscriptions(List<String> value) {
    _userSubscriptions = value;
  }
}