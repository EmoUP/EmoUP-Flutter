import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<bool> getUser(String email) async {
    bool existing;
    await users
        .where('email', isEqualTo: email)
        .get()
        .then((value) => value.size == 0 ? existing = false : existing = true);
    return existing;
  }

  addChatRoom(chatRoom, chatRoomId) async {
    firestore.collection("chatRoom").doc(chatRoomId).set(chatRoom)
      .catchError((e) {
        print(e);
      }
    );
  }

  getChats(String chatRoomId) async {
    return firestore.collection("chatRoom").doc(chatRoomId).collection("chats").orderBy('time').snapshots();
  }

  addMessage(String chatRoomId, chatMessageData) async{
    firestore.collection("chatRoom").doc(chatRoomId).collection("chats").add(chatMessageData)
      .catchError((e){
        print(e.toString());
      }
    );
    firestore.collection("chatRoom").doc(chatRoomId).update({
        "updatedAt": DateTime.now()
    }).catchError((e){
        print(e.toString());
      }
    );
  }

  getUserChats(String itIsMyName) async {
    return firestore.collection("chatRoom").where('users', arrayContains: itIsMyName).snapshots();
  }

  Future<String> getName(String uid) async{
    String name;
    await firestore.collection("users").doc(uid).get().then((val) => {
      name = val.data()['name']
    });
    return name;
  }
}
