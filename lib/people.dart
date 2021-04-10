import 'package:emoup/Chat.dart';
import 'package:emoup/ChatBox.dart';
import 'package:emoup/Services/auth.dart';
import 'package:emoup/Services/people.dart';
import 'package:emoup/const.dart';
import 'package:flutter/material.dart';
import 'package:emoup/Models/people.dart' as Peeps;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class People extends StatefulWidget {

  final String uid, name;
  People({this.uid, this.name});

  @override
  _PeopleState createState() => _PeopleState();
}

class _PeopleState extends State<People> {

  List<Peeps.People> lst;
  double w,h;
  bool loading = true;
  Auth auth = new Auth();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    List<Peeps.People> temp = await getPeople();
    setState(() {
      lst = temp;  
      loading = false;    
    });
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF405CC7),
        title: Text("People",
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
            margin: EdgeInsets.only(bottom: 0.02 * h),
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Image.asset("assets/images/header.png", fit: BoxFit.fill),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: lst.length,
              itemBuilder: (context, index) {
                return lst[index].uid != widget.uid ? Card(
                  shadowColor: Color(0x80405CC7),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                   contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                   leading: CircleAvatar(
                      radius: 29.0,
                      child: ClipOval(
                        child: lst[index].profilePic != null ? Image.network(
                          lst[index].profilePic,
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
                      lst[index].name
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.message),
                      color: eblue,
                      onPressed: () {
                        sendMessage(lst[index]);
                      },
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  )
                ) : Container();
              }
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.history),
        onPressed: () {
          navigateTo(context, Chat(uid: widget.uid, name: widget.name,));
        },
      ),
    );
  }

  sendMessage(Peeps.People selected) async {
    List<String> users = [widget.name, selected.name];
    String chatRoomId = getChatRoomId(widget.uid, selected.uid);
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
      "updatedAt": DateTime.now()
    };
    auth.addChatRoom(chatRoom, chatRoomId);
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ChatBox(
        chatRoomId: chatRoomId,
        uid: widget.uid,
        name: selected.name,
        pfp: selected.profilePic
      )
    ));
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}