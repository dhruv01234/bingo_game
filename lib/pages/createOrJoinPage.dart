import 'package:bingo_game/components/addroom.dart';
import 'package:bingo_game/components/roomcode.dart';
import 'package:bingo_game/components/roomlist.dart';
import 'package:bingo_game/pages/roompage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CRTorJN extends StatelessWidget {
  CRTorJN({required this.name});
  String name;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Color.fromRGBO(7, 224, 189, 1),
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Options(txt: "Create Room",id: 1,name: name,),
            Options(txt: "Join Room",id:2,name: name,),
          ],
        ),
      ),
    ));
  }
}

class Options extends StatelessWidget {
  Options({required this.txt,required this.id,required this.name});
  String txt;
  int id;
  String name;
  @override
  late QuerySnapshot m;
  Widget build(BuildContext context) {
    String enteredCode="";
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade700),
      ),
      margin: EdgeInsets.only(top: 15,bottom: 25),
      width: MediaQuery.of(context).size.width*.7,
      height: MediaQuery.of(context).size.width*.17,
      child: MaterialButton(onPressed: (){
        if(id==1){
          String roomCode = GenerateCode();
          addRoom(roomCode, name,"waiting...");
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayerRoom(roomCode: roomCode,id: 1,name:name,)));
        }
        else{
          showDialog(context: context, builder: (context)=>AlertDialog(
            title: Text("Enter Room Code"),
            actions: [
          StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("room").snapshots(),
            builder: (context,snapshot) {
              if (snapshot.hasData) {
                m = snapshot.requireData;
              }
              return Text("");
            }),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (code){
                    enteredCode = code;
                },
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,

                style: TextStyle(fontSize: MediaQuery.of(context).size.width*.06),
                maxLength: 4,
                maxLines: 1,
                enableSuggestions: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  counterText: "",
                ),
              ),
              MaterialButton(
                onPressed: (){
                      Navigator.pop(context);
                      bool check = false;
                      int j=0;
                      for(int i=0;i<m.docs.length;i++){
                        if(enteredCode==m.docs[i].id){
                          j = i;
                          check = true;
                          break;
                        }
                      }
                      if(check && m.docs[j]['start']){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor:Color.fromRGBO(158, 158, 158, .5),
                                duration:Duration(seconds: 1),
                                content: Text("Room has already started"))
                        );
                      }
                      else if(check && m.docs[j]['second']!="waiting..."){
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor:Color.fromRGBO(158, 158, 158, .5),
                                duration:Duration(seconds: 1),
                                content: Text("Room is full"))
                        );
                      }
                      else if(check){
                        String host = m.docs[j]['first'];
                        Map<String,dynamic> updatedroom = RoomList(host, name);
                        FirebaseFirestore.instance.collection('room').doc(
                            enteredCode).update(updatedroom);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayerRoom(roomCode: enteredCode,id: 2,name:name,)));
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor:Color.fromRGBO(158, 158, 158, .5),
                                duration:Duration(seconds: 1),
                                content: Text("Room doest not exist"))
                        );
                      }
                  },
                color: Color.fromRGBO(7, 224, 189, 1),
                child: Text("Join"),
              )
            ],
          ));
        }
      },
        child: Text(txt,style: TextStyle(fontSize: 27,letterSpacing: 3,),
      ),
    )
    );
  }
}
