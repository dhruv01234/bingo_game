import 'package:bingo_game/components/roomlist.dart';
import 'package:bingo_game/components/timer.dart';
import 'package:bingo_game/pages/gamepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class PlayerRoom extends StatefulWidget {
  PlayerRoom({required this.roomCode,required this.name,required this.id});
String roomCode;
String name;
int id;
  @override
  State<PlayerRoom> createState() => _PlayerRoomState();
}


class _PlayerRoomState extends State<PlayerRoom> {
  @override
  String firstName="";
  String secondName="";
  // late QuerySnapshot m1;
  Widget build(BuildContext context) {
    bool exit = false;
    late QuerySnapshot m;
    return  WillPopScope(
        onWillPop: () async {
          await showDialog(context: context, builder: (context)=>AlertDialog(
            title: Text("Are you want to exit"),
            actions: [
          StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("room").snapshots(),
              builder: (context,snapshot) {
                if (snapshot.hasData) {
                  m = snapshot.requireData;
                }

                return Text("");
              }),
              MaterialButton(
              color: Colors.grey,
                onPressed: (){
                Navigator.pop(context);
              },
                child: Text("No"),
              ),
              MaterialButton(
                color: Colors.grey,
                child: Text("Yes"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                DocumentReference<Map<String,dynamic>> type = FirebaseFirestore.instance.collection("room").doc(widget.roomCode);
                if(widget.id==1) {
                  type.delete();
                  setState((){
                    exit = true;
                  });
                }
                else{
                    for(int i=0;i<m.docs.length;i++){
                      if(m.docs[i].id==widget.roomCode){
                        FirebaseFirestore.instance.collection("room").doc(widget.roomCode).update(
                            RoomList(m.docs[i]['first'], "waiting...")
                        );
                      }
                    }
                }
              })
            ],
          ));

          return Future.value(false);
        },
          child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset : false,
              backgroundColor: Color.fromRGBO(7, 224, 189, 1),
              body: Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Container(
                        child: Column(
                          children: [
                            Text(widget.roomCode,style: TextStyle(fontSize: MediaQuery.of(context).size.height*.04),),
                            MaterialButton(
                              height: MediaQuery.of(context).size.height*.04,
                              color: Colors.grey,
                              onPressed:()async {
                                print(firstName);
                                await Clipboard.setData(ClipboardData(text: widget.roomCode));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor:Color.fromRGBO(158, 158, 158, .5),
                                        duration:Duration(seconds: 1),
                                        content: Text("Code copied succesfully"))
                                );
                              },
                              child: Text("Copy Code"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height*.2,),
                      Container(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection("room").snapshots(),
                          builder: (context,snapshot){
                            if(snapshot.hasData){
                              final m = snapshot.requireData;
                              for(int i=0;i<m.docs.length;i++){
                                if(widget.roomCode==m.docs[i].id){
                                  firstName = m.docs[i]['first'];
                                  secondName = m.docs[i]['second'];
                                }
                              }
                            }
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          'images/profile.png',
                                          width: 60,
                                          height: 60,
                                        ),
                                        Text(firstName)
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("images/vslgo.png",width: MediaQuery.of(context).size.width*.5,)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      children: [
                                        Image.asset(
                                          'images/profile.png',
                                          width: 60,
                                          height: 60,
                                        ),
                                        Text(secondName),
                                      ],
                                    )
                                  ],
                                ),
                               SizedBox(height: 20,),
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection("room").snapshots(),
                                    builder: (context,snapshot){
                                      if (snapshot.hasData){
                                        QuerySnapshot m1 = snapshot.requireData;
                                        return StartButton(id: widget.id,roomCode: widget.roomCode,m: m1,);
                                      }
                                      return Text("");
                                    }),
                              ],
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
      );

  }
}

class StartButton extends StatelessWidget {
  StartButton({required this.id, required this.roomCode, required this.m});

  int id;
  String roomCode;
  QuerySnapshot m;

  @override
  Widget build(BuildContext context) {
    int j = 0;
    bool get=false;
    for (int i = 0; i < m.docs.length; i++) {
      if (m.docs[i].id == roomCode) {
        j = i;
        get = true;
        break;
      }
    }
    if (get && m.docs[j]['start']) {
      return StatusIndicator(duration: 5,
        width: 30,
        height: 30,
        fontsize: 20,
        strokewidth: 10,
        onComplete: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => GamePage(m: m,roomNum:j,id:id)));
        },
      );
    }
    else {
      if (id == 1) {
        if (m.docs[j]['second'] == "waiting...") {
          return Text('Waiting for other player to join...');
        }
        else {
          return MaterialButton(
            color: Colors.grey,
            onPressed: () {
              Map<String, dynamic> updatedroomstatus = RoomList(
                  m.docs[j]['first'], m.docs[j]['second']);
              updatedroomstatus['start'] = true;
              FirebaseFirestore.instance.collection("room")
                  .doc(roomCode)
                  .update(updatedroomstatus);
            },
            child: Text("Start Game"),
          );
        }
      }
      else {
        return Text("Waiting for host to start...");
      }

    }
  }
}