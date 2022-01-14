class Message{
  String message;
  String sentMyMe;

  Message({required this.message,required this.sentMyMe});
  factory Message.fromJson(Map<String,dynamic> json){
    return Message(message: json["message"], sentMyMe: json["sentByMe"]);
  }
}