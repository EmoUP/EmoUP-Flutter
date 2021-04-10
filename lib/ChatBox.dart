import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoup/Services/auth.dart';
import 'package:emoup/const.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:google_fonts/google_fonts.dart';
import 'package:encrypt/encrypt.dart';

class ChatBox extends StatefulWidget {
  final String chatRoomId, uid, name, pfp;
  ChatBox({this.chatRoomId, this.uid, this.name, this.pfp});
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  Auth auth = new Auth();
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  String uid;
  final encrypter = Encrypter(AES(Key.fromUtf8('my 32 length key................')));

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    Stream<QuerySnapshot> temp = await auth.getChats(widget.chatRoomId);
    setState(() {
      chats = temp;
    });
    setState(() {
      uid = widget.uid;
    });
  }

  double w,h;

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: eblue,
        title: Row(
          children: [
            CircleAvatar(
              radius: 15.0,
              child: ClipOval(
                child: widget.pfp != null ? Image.network(
                  widget.pfp,
                  fit: BoxFit.cover,
                  width: 30.0,
                  height: 30.0,
                ) : Image.asset(
                  "assets/images/person.png",
                    fit: BoxFit.cover,
                    width: 30.0,
                    height: 30.0,
                  ) 
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.name)
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: null,
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 0.01 * h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 0.8 * w,
                    height: 0.06 * h,
                    child: new Theme(
                      data: new ThemeData(
                        primaryColor: eblue,
                        primaryColorDark: eblue,
                      ),
                      child: TextField(
                        controller: messageEditingController,
                        textAlignVertical: TextAlignVertical.bottom,
                        cursorColor: eblue,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: eblue),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: eblue)
                          ),
                          hintText: "Type a message",
                          suffixIcon: Icon(Icons.camera, color: eblue),
                        ),
                      ),
                    )
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: eblue, size: 32),
                    onPressed: () => {
                      addMessage()
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return MessageTile(
              message: encrypter.decrypt(Encrypted.fromBase64(snapshot.data.docs[index]["message"]), iv: IV.fromLength(16)),
              sendByMe: uid == snapshot.data.docs[index]["sendBy"],
            );
          }
        ) : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      final message = encrypter.encrypt(messageEditingController.text, iv: IV.fromLength(16));
      Map<String, dynamic> chatMessageMap = {
        "sendBy": uid,
        "message": message.base64,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      auth.addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: sendByMe ? eblue : Colors.white
        ),
        child: Text(
          message,
          textAlign: TextAlign.start,
          style: GoogleFonts.ptSans(
            fontSize: 20,
            color: sendByMe ? Colors.white : eblue
          )
        ),
      ),
    );
  }
}