class MessageModel{
  String _message;
  String _time;
  String _timestamp;
  bool _sent;

  MessageModel({String message, String time, String timestamp, bool sent}){
    this._message = message ?? "";
    this._time = time ?? "";
    this._timestamp = timestamp ?? "";
    this._sent = sent ?? true;
  }

  Map<String, dynamic> toMap(MessageModel msg){
    Map<String, dynamic> map = {
      "message": msg._message ?? "",
      "time": msg._time ?? "",
      "timestamp": msg._timestamp ?? "",
      "sent": msg._sent ?? true
    };

    return map;
  }

  MessageModel fromMap(Map<String, dynamic> map){
    return new MessageModel(
        message: map["message"],
        time: map["time"],
        timestamp: map["timestamp"],
        sent: map["sent"],
    );
  }

  bool get sent => _sent;

  set sent(bool value) {
    _sent = value;
  }

  String get timestamp => _timestamp;

  set timestamp(String value) {
    _timestamp = value;
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }
}