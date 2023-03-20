import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bingo_game/components/roomlist.dart';

Future addRoom(String quizcode,String hostname,String second) async {
  Map<String,dynamic> quiz = RoomList(hostname,second);
  await FirebaseFirestore.instance.collection('room').doc(quizcode).set(quiz);
}