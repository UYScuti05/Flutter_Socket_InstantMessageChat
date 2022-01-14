import 'package:app121/controller/chat_controller.dart';
import 'package:app121/model/message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class ChatScreen extends StatefulWidget {
  const ChatScreen({ Key? key }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Color purple = Color(0xFF6c5ce7);
  Color black = Color(0xFF191919);
  TextEditingController msgInputController = TextEditingController();

  late IO.Socket socket;
  ChatController chatController = ChatController();


  @override
  void initState() {
    this.socket = IO.io('http://localhost:4000',IO.OptionBuilder()
    .setTransports(['websocket'])
    .disableAutoConnect()
    .build());

    this.socket.connect();

    setUpSocketListener();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex:9, 
              child: Obx(
                ()=> ListView.builder(
                  itemCount: chatController.chatMessages.length,
                  itemBuilder: (context,index){
                     var currentItem = chatController.chatMessages[index];
                    return MessageItem(
                      sentByMe: currentItem.sentMyMe == socket.id,
                      message: currentItem.message,
                    );
                  }),
              )
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  style: TextStyle(
                    color: Colors.white
                  ),
                  cursorColor: purple,
                  controller: msgInputController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Container(
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: purple,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: IconButton(onPressed: ()=>{
                        sendMessage(msgInputController.text)
                      }, 
                      icon: Icon(Icons.send,color: Colors.white,),),
                    ),
                  ),
                ),
            )),

          ],
        )
      ),
    );
  }

  sendMessage(String text) {
    var messageJson = {
      "message":text,
      "sentByMe":socket.id
    };
    socket.emit('message',messageJson);
    chatController.chatMessages.add(Message.fromJson(messageJson));

  }

  void setUpSocketListener() {
    socket.on('message-receive',(data){
      print(data);
      chatController.chatMessages.add(Message.fromJson(data));
    });
  }
}



// Message Tile StateLess Widget

class MessageItem extends StatelessWidget {
  const MessageItem({ Key? key, required this.sentByMe,required this.message }) : super(key: key);
  final bool sentByMe;
  final String message;
  @override

  


  Widget build(BuildContext context) {
    Color purple = Color(0xFF6c5ce7);
    Color black = Color(0xFF191919);

    return Align(
      alignment: sentByMe?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 3,horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: sentByMe?purple:Colors.white,

        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(message,
              style: TextStyle(
              color: sentByMe?Colors.white:purple,
              fontSize: 18,
              ),
            ),
            SizedBox(width: 5,),
            Text("1:10 AM",
              style: TextStyle(
              color: (sentByMe?Colors.white:purple).withOpacity(0.7),
              fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}