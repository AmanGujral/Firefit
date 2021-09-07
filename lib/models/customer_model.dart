

class CustomerModel{

  String _customerId;
  String _customerName;
  String _customerEmail;
  String _customerImageUrl;
  String _lastMsgTime;
  String _lastMsgTimestamp;
  String _customerProgramId;
  String _lastMsg;


  CustomerModel({String customerId, String customerName, String customerEmail,
    String customerImageUrl, String lastMsgTime, String lastMsgTimestamp,
    String customerProgramId, String lastMsg}){
    this._customerId = customerId;
    this._customerName = customerName;
    this._customerEmail = customerEmail;
    this._customerImageUrl = customerImageUrl;
    this._lastMsgTime = lastMsgTime;
    this._lastMsgTimestamp = lastMsgTimestamp;
    this._customerProgramId = customerProgramId;
    this._lastMsg = lastMsg;
  }

  Map<String, dynamic> toMap(CustomerModel customer){

    Map<String, dynamic> map = {
      "customerId": customer._customerId,
      "customerName": customer._customerName ?? "John Doe",
      "customerEmail": customer._customerEmail ?? "JohnDoe@example.com",
      "customerImageUrl": customer._customerImageUrl ?? null,
      "lastMsgTime": customer._lastMsgTime ?? null,
      "lastMsgTimestamp": customer._lastMsgTimestamp ?? '11111',
      "customerProgramId": customer._customerProgramId,
      "lastMsg": customer._lastMsg,
    };

    return map;
  }

  CustomerModel fromMap(Map<String, dynamic> map){
    return new CustomerModel(
      customerId: map["customerId"],
      customerName: map["customerName"] ?? "John Doe",
      customerEmail: map["customerEmail"] ?? "JohnDoe@example.com",
      customerImageUrl: map["customerImageUrl"] ?? null,
      lastMsgTime: map["lastMsgTime"] ?? null,
      lastMsgTimestamp: map["lastMsgTimestamp"],
      customerProgramId: map["customerProgramId"],
      lastMsg: map["lastMsg"],
    );
  }

  String getInitials(){
    List<String> names = _customerName.split(' ');
    if(names.length > 1)
      return names[0].substring(0, 1) + names[1].substring(0, 1);
    else
      return names[0].substring(0, 1);
  }

  String get customerImageUrl => _customerImageUrl;

  set customerImageUrl(String value) {
    _customerImageUrl = value;
  }

  String get customerEmail => _customerEmail;

  set customerEmail(String value) {
    _customerEmail = value;
  }

  String get customerName => _customerName;

  set customerName(String value) {
    _customerName = value;
  }

  String get customerId => _customerId;

  set customerId(String value) {
    _customerId = value;
  }

  String get lastMsgTimestamp => _lastMsgTimestamp;

  set lastMsgTimestamp(String value) {
    _lastMsgTimestamp = value;
  }

  String get lastMsgTime => _lastMsgTime;

  set lastMsgTime(String value) {
    _lastMsgTime = value;
  }

  String get customerProgramId => _customerProgramId;

  set customerProgramId(String value) {
    _customerProgramId = value;
  }

  String get lastMsg => _lastMsg;

  set lastMsg(String value) {
    _lastMsg = value;
  }
}