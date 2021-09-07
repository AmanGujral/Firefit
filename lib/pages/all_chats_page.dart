import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myfitnessfire/models/customer_model.dart';
import 'package:myfitnessfire/pages/chat_page.dart';
import 'package:myfitnessfire/structures/user_model.dart';

class AllChatsPage extends StatefulWidget {
  static const tag = "all_chats_page";
  @override
  _AllChatsPageState createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  List<CustomerModel> customerList = new List();
  UserModel _userInstance = UserModel().getInstance();

  @override
  Widget build(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    CollectionReference customers = FirebaseFirestore.instance
        .collection('Users')
        .doc(_userInstance.userId)
        .collection('customers');

    return Scaffold(
      appBar: PreferredSize(
        child: _appBarTitle(isLight),
        preferredSize: Size.fromHeight(56),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: customers.orderBy('lastMsgTimestamp', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Center(child: Text('Something went wrong!'),);
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: Text('Loading'),);
          }
          if(snapshot.hasData) {
            customerList.clear();
            snapshot.data.docs.forEach((document) {
              customerList.add(CustomerModel().fromMap(document.data()));
            });
          }
          if(customerList.length == 0){
            return Center(
              child: Text("You don't have any chats yet!"),
            );
          }
          else {
            return ListView.builder(
              itemCount: customerList.length,
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                return _customerContainer(customerList[index], isLight);
              },
            );
          }
        },
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
          "Chats",
          style: TextStyle(),
        ),
      ),
    );
  }

  Widget _customerContainer(CustomerModel customer, bool isLight){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
      elevation: 4.0,
      child: ListTile(
        tileColor: isLight ? Colors.white : Colors.black54,
        leading: customer.customerImageUrl != null
            ? CircleAvatar(
          backgroundColor: isLight ? Colors.redAccent : Colors.white,
          child: Text(
            customer.getInitials(),
            style: TextStyle(
              color: isLight ? Colors.white : Colors.redAccent,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : CircleAvatar(
          backgroundColor: isLight ? Colors.redAccent : Colors.white70,
          child: Text(
            customer.getInitials(),
            style: TextStyle(
              color: isLight ? Colors.white : Colors.redAccent,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        title: Text(
          customer.customerName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        trailing: Text(
          customer.lastMsgTime ?? '',
          maxLines: 1,
          style: TextStyle(
            fontSize: 12.0,
            color: isLight ? Colors.black54 : Colors.white54,
          ),
        ),

        subtitle: Text(
          customer.lastMsg ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isLight ? Colors.black54 : Colors.white54,
            fontSize: 12.0
          ),
        ),

        onTap: () {
          Navigator.of(context)
              .pushNamed(ChatPage.tag, arguments: [
            customer.customerProgramId,
            customer.customerId,
            AllChatsPage.tag,
            customer.customerName,
          ]);
        },
      ),
    );
  }

}
