import 'package:emoup/ChatBox.dart';
import 'package:emoup/Services/auth.dart';
import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class Chat extends StatefulWidget {

  final String uid, name;
  Chat({this.uid, this.name});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Stream chatRooms;
  String uid;
  Auth auth = new Auth();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getUserInfogetChats();
  }

  getUserInfogetChats() async {
    setState(() {
      uid = widget.uid;
    });
    auth.getUserChats(widget.name).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        print("we got the data + ${chatRooms.toString()} this is name  $uid");
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF405CC7),
        title: Text("Chat History",
          style: GoogleFonts.poppins(
            fontSize: 24,
            color: white
          ),
        ),
        centerTitle: true,
      ),
      body: loading ? Center(
          child: SpinKitWanderingCubes(
            color: Colors.red,
            size: 20,
          )
        ) : Column(
        children: [
          Card(
            margin: EdgeInsets.only(bottom: 0.02 * MediaQuery.of(context).size.height),
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Image.asset("assets/images/header.png", fit: BoxFit.fill),
          ),
          chatRoomsList()
        ]
      )
    );
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ChatRoomsTile(
              userName: snapshot.data.docs[index]['users'][1],
              chatRoomId: snapshot.data.docs[index]["chatRoomId"],
              uid: uid,
            );
          }
        ) : Container();
      },
    );
  }

}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  final String uid;
  final String pfp;
  ChatRoomsTile({this.userName,@required this.chatRoomId, this.uid, this.pfp});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Color(0x80405CC7),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        leading: CircleAvatar(
          radius: 29.0,
          child: ClipOval(
            child: pfp != null ? Image.network(
              pfp,
              fit: BoxFit.cover,
              width: 60.0,
              height: 60.0,
            ) : Image.asset(
            "assets/images/person.png",
              fit: BoxFit.cover,
              width: 60.0,
              height: 60.0,
            ) 
          ),
        ),
        title: Text(
          userName
        ),
        trailing: IconButton(
          icon: Icon(Icons.message),
          color: eblue,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => ChatBox(
                chatRoomId: chatRoomId,
                uid: uid,
                name: userName,
                pfp: pfp,
              )
            ));
          },
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      )
    );
  }
}