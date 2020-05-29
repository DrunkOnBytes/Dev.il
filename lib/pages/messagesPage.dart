import 'package:flutter/material.dart';
import 'package:flutter_chat_app/custom/messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/custom/auth.dart';


class MessagesFromFriend extends StatefulWidget {

  final String from;
  MessagesFromFriend(this.from);

  @override
  _MessagesFromFriendState createState() => _MessagesFromFriendState(from);
}

class _MessagesFromFriendState extends State<MessagesFromFriend> {

  final String from;
  _MessagesFromFriendState(this.from);
  List<Widget> received, sent;
  String message;
  final _messageFormKey = new GlobalKey<FormState>();

  bool validateAndSave() {
    final form = _messageFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget messageInput(){
    return new Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Form(
              key: _messageFormKey,
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 5,
                decoration: new InputDecoration(
                    hintText: ' Enter Message......',
                    icon: new Icon(
                      Icons.message,
                      color: Colors.grey,
                    )),
                validator: (value) => value.isEmpty ? 'Message can\'t be empty' : null,
                onSaved: (value) => message = value,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Colors.grey,
            tooltip: 'Send Message to database',
            onPressed: (){
              setState(() {
                if(validateAndSave()){
                  var m = Message(uid, from, message);
                  addMessageToDatabase(m);
                  _messageFormKey.currentState.reset();
                }
              });
            },
          )
        ],
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade700, Colors.deepOrange.shade400],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40 ),
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('messages').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');

                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting: return new Text('Loading...');
                    default:
                      received = List<Widget>();
                      sent = List<Widget>();
                      for (DocumentSnapshot document in snapshot.data.documents){
                        if(document['to']==uid && document['from']==from) {
                          received.add(MessageTilesFriend(
                              document['message'], document['time'], 1));
                          sent.add(MessageTilesMe(
                              document['message'], document['time'], 0));
                        }
                        if(document['to']==from && document['from']==uid) {
                          sent.add(MessageTilesMe(
                              document['message'], document['time'], 1));
                          received.add(MessageTilesFriend(
                              document['message'], document['time'], 0));
                        }
                      }
                      return new SingleChildScrollView(
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: received,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: sent,
                            )
                          ],
                        ),
                      );
                  }
                },
              ),
            ),
            Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                  child: messageInput(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
