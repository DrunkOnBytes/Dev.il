import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_app/custom/auth.dart';
import 'package:flutter_chat_app/pages/messagesPage.dart';


class Message{
  final String from, to, message;
  DateTime time;
  Message(this.from,this.to, this.message){
    time=DateTime.now();
  }
}

void addMessageToDatabase(Message m){
  Firestore.instance.collection('messages').document()
      .setData({ 'from': m.from, 'to': m.to, 'message': m.message, 'time': m.time });
}

class ActiveUserTile extends StatelessWidget {

  final String username, photoUrl, uid;
  ActiveUserTile(this.username,this.photoUrl,this.uid);

  ImageProvider avatar(String photoUrl){
    if (photoUrl==null)
      return new AssetImage('images/avatar.png');
    else
      return new NetworkImage(photoUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: avatar(photoUrl),
          radius: 25,
          backgroundColor: Colors.transparent,
        ),
        title: Text(
          '\t\t' + username,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => MessagesFromFriend(uid)));
        },
      ),
    );
  }
}


class ActiveUsers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                if(document['id']!=uid)
                  return new ActiveUserTile(document['username'], document['photoUrl'], document['id']);
                else
                  return SizedBox(width: 0,height: 0,);
              }).toList(),
            );
        }
      },
    );
  }
}

class MessageTilesFriend extends StatelessWidget {

  final String message;
  final Timestamp time;
  final double show;
  MessageTilesFriend(this.message,this.time,this.show);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: show,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Card(
            elevation: 3,
            color: Colors.deepOrange.shade100,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    message,
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                  Text(
                      time.toDate().hour>12?
                      (time.toDate().hour-12).toString() + " : " + time.toDate().minute.toString()+' pm'
                      :time.toDate().hour.toString() + " : " + time.toDate().minute.toString()+' am',
                    style: TextStyle(color: Colors.black45, fontSize: 15),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}

class MessageTilesMe extends StatelessWidget {

  final String message;
  final Timestamp time;
  final double show;

  MessageTilesMe(this.message,this.time,this.show);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: show,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Card(
            elevation: 3,
            color: Colors.deepOrange.shade100,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    message,
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                  Text(
                    time.toDate().hour>12?
                    (time.toDate().hour-12).toString() + " : " + time.toDate().minute.toString()+' pm'
                        :time.toDate().hour.toString() + " : " + time.toDate().minute.toString()+' am',
                    style: TextStyle(color: Colors.black45, fontSize: 15),
                  )
                ],
              ),
            )
        ),
      ),
    );
  }
}
