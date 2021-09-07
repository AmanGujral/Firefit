import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myfitnessfire/models/customer_model.dart';
import 'package:myfitnessfire/pages/all_chats_page.dart';
import 'package:myfitnessfire/structures/message_model.dart';
import 'package:myfitnessfire/structures/user_model.dart';

class ChatPage extends StatefulWidget {
  static const tag = "chat_page";
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<MessageModel> messageList = new List();
  bool sent = true;
  bool isLoading = false;
  String currentProgramUid;
  String currentCustomerId;
  String pageThatCalledThisPage;
  String chatName;
  int messageLimit = 20;
  TextEditingController messageController = new TextEditingController();
  UserModel _userInstance = UserModel().getInstance();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    messageController.text = "";
    List<dynamic> arguments = ModalRoute.of(context).settings.arguments;
    currentProgramUid = arguments[0];
    currentCustomerId = arguments[1];
    pageThatCalledThisPage = arguments[2];
    chatName = arguments[3];

    CollectionReference messages;

    _userInstance.isSeller && pageThatCalledThisPage == AllChatsPage.tag
        ? messages = FirebaseFirestore.instance
        .collection('Users')
        .doc(_userInstance.userId)
        .collection('customers')
        .doc(currentCustomerId)
        .collection('messages')
        : messages = FirebaseFirestore.instance
        .collection('Users')
        .doc(_userInstance.userId)
        .collection('purchased')
        .doc(currentProgramUid)
        .collection('messages');

    return Scaffold(
      appBar: PreferredSize(
        child: _appBarTitle(isLight),
        preferredSize: Size.fromHeight(56),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              //stream: messages.orderBy('timestamp', descending: true).limit(messageLimit).snapshots(),
              stream: messages.orderBy('timestamp', descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasError){
                  return Center(child: Text('Something went wrong!'),);
                }
                /*if(snapshot.connectionState == ConnectionState.waiting){
                  return Container(
                    height: 50,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }*/
                if(snapshot.hasData) {
                  messageList.clear();
                  snapshot.data.docs.forEach((document) {
                    messageList.add(MessageModel().fromMap(document.data()));
                  });
                }
                return ListView.builder(
                  itemCount: messageList.length,
                  reverse: true,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  itemBuilder: (context, index){
                    return new Align(
                      alignment: messageList[index].sent ? Alignment.topRight : Alignment.topLeft,
                      child: _messageContainer(messageList[index]),);
                  },
                );
              },
            ),
          ),

          Container(height: 8.0,),

          Align(
            alignment: Alignment.bottomLeft,
            child: _messageBox(isLight),),
        ],
      ),
    );
  }

  Widget _appBarTitle(isLight) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor
          ],
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          capitalize(chatName),
          style: TextStyle(),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
    );
  }

  Widget _messageContainer(MessageModel msg){
    return new Container(
      constraints: BoxConstraints(
        maxWidth: 260.0,
      ),
      margin: EdgeInsets.only(left: 12.0, top: 8.0, right: 12.0),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: msg.sent ? Color(0xFFF5BF98) : Color(0xFFF5A098),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
              child: Text(
                msg.message,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0
                ),
              )
          ),
          SizedBox(width: 10.0,),
          Text(
            msg.time,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 10.0
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageBox(isLight){
    return Container(
      constraints: BoxConstraints(
        maxHeight: 120.0,
        minHeight: 50.0,
      ),
      padding: EdgeInsets.only(left: 10),
      width: double.infinity,
      color: isLight ? Colors.white : Colors.black38,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: messageController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  hintText: "Write message...",
                  hintStyle: TextStyle(color: isLight ? Colors.black54 : Colors.white54),
                  border: InputBorder.none
              ),
            ),
          ),
          SizedBox(width: 15,),
          IconButton(
            onPressed: (){
              setState(() {
                _sendMessage();
              });
            },
            icon: Icon(Icons.send_rounded,color: Colors.redAccent,),
            iconSize: 26,
          ),
        ],

      ),
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  /*bool _scrollListener(ScrollNotification scrollInfo){
    if(scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent){
      setState(() {
        //isLoading = true;
        messageLimit += messageLimit;
      });
      return true;
    }
    return false;
  }*/

  _sendMessage() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat.Hm().format(now);
    String text = messageController.text;

    //Message sent by us
    MessageModel msgSent = new MessageModel(
      message: messageController.text,
      time: formattedDate,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      sent: true
    );

    //Message received by the recipient
    MessageModel msgReceived = new MessageModel(
        message: messageController.text,
        time: formattedDate,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        sent: false
    );


    //If current user is a seller
    if(_userInstance.isSeller && pageThatCalledThisPage == AllChatsPage.tag) {

      //SELLER

      //send message to sender's DB
      FirebaseFirestore.instance
          .collection('Users')
          .doc(_userInstance.userId)
          .collection('customers')
          .doc(currentCustomerId)
          .collection('messages')
          .add(MessageModel().toMap(msgSent));

      //send message to receiver's DB
      FirebaseFirestore.instance
          .collection('Users')
          .doc(currentCustomerId)
          .collection('purchased')
          .doc(currentProgramUid)
          .collection('messages')
          .add(MessageModel().toMap(msgReceived));

      //update all_chats_page data on seller's db
      FirebaseFirestore.instance
          .collection('Users')
          .doc(_userInstance.userId)
          .collection('customers')
          .doc(currentCustomerId)
          .update({
        'lastMsgTime': formattedDate,
        'lastMsgTimestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'lastMsg': messageController.text
      });
    }

    else{

      //CUSTOMER
      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentProgramUid.split('Program')[0])
          .collection('customers')
          .doc(_userInstance.userId)
          .get();

      //check if the customer document exists in the seller's db
      if(!snapshot.exists){
        CustomerModel customer = new CustomerModel(
          customerId: _userInstance.userId,
          customerName: _userInstance.userName,
          customerEmail: _userInstance.userEmail,
          customerImageUrl: _userInstance.userImageUrl,
          customerProgramId: currentProgramUid,
          lastMsgTime: formattedDate,
          lastMsgTimestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        );

        //add the customer document to seller's db, if not exists already
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentProgramUid.split('Program')[0])
            .collection('customers')
            .doc(_userInstance.userId)
            .set(customer.toMap(customer));
      }

      //send message to our DB
      FirebaseFirestore.instance
          .collection('Users')
          .doc(_userInstance.userId)
          .collection('purchased')
          .doc(currentProgramUid)
          .collection('messages')
          .add(MessageModel().toMap(msgSent));

      //send message to receiver's DB
      FirebaseFirestore.instance
          .collection('Users')
          .doc(currentProgramUid.split('Program')[0])
          .collection('customers')
          .doc(_userInstance.userId)
          .collection('messages')
          .add(MessageModel().toMap(msgReceived));

      //update all_chats_page data on seller's db
      FirebaseFirestore.instance
          .collection('Users')
          .doc(currentProgramUid.split('Program')[0])
          .collection('customers')
          .doc(_userInstance.userId)
          .update({
        'lastMsgTime': formattedDate,
        'lastMsgTimestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'lastMsg': text
      });
    }
  }
}
