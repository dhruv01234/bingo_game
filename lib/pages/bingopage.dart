import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/updateBingo.dart';
import '../components/winner.dart';

class BINGO extends StatefulWidget {
  BINGO({required this.roomCode, required this.id});
  int id;
  String roomCode;
  @override
  State<BINGO> createState() => _BINGOState();
}

class _BINGOState extends State<BINGO> {
  @override
  Widget build(BuildContext context) {
    int playerid = widget.id;
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(7, 224, 189, 1),
          appBar: AppBar(
            backgroundColor: Colors.white60,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Text(
              'BINGO',
              style: TextStyle(
                  color: Colors.black, letterSpacing: 5, fontSize: 20),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("room")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final m = snapshot.requireData;
                        Map<String, dynamic> board = {};
                        int x = 0;
                        for (int i = 0; i < m.docs.length; i++) {
                          if (m.docs[i].id == widget.roomCode) {
                            x = i;
                            if (playerid == 1) {
                              board = m.docs[i]['firstBox'];
                            } else {
                              board = m.docs[i]['secondBox'];
                            }
                          }
                        }
                        return Column(
                          children: [
                            m.docs[x]['chance']==widget.id?Text("Your chance",style: TextStyle(
                                color: Colors.black, letterSpacing: 5, fontSize: 20)):Text("Opponent chance",style: TextStyle(
                                color: Colors.black, letterSpacing: 5, fontSize: 20)),
                            SizedBox(height: 50,),
                            DisplayBoard(
                                board: board,
                                roomCode: widget.roomCode,
                                id: widget.id),
                          ],
                        );
                      }
                      return Text("");
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DisplayBoard extends StatefulWidget {
  DisplayBoard({required this.board, required this.id, required this.roomCode});
  Map<String, dynamic> board;
  String roomCode;
  int id;
  @override
  State<DisplayBoard> createState() => _DisplayBoardState();
}

class _DisplayBoardState extends State<DisplayBoard> {
  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> bingoBoard = [];
    int winnerid=3;
    for (int i = 1; i <= 5; i++) {
      bingoBoard.add(widget.board[i.toString()]);
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(left: 16,right: 16),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("room").snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) return Text("");
                String pl = widget.id==1?"firstcut":"secondcut";
                Map<String,dynamic> bingo={};
                for (int v =0; v < snapshot.requireData.docs.length; v++) {
                  if (snapshot.requireData.docs[v].id == widget.roomCode) {
                    bingo = snapshot.requireData.docs[v][pl];
                    break;
                  }
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("B",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * .06,
                          decoration: bingo['B']==1?TextDecoration.lineThrough:TextDecoration.none,
                            decorationThickness: 2
                        )),
                    Text("I",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * .06,
                          decoration: bingo['I']==1?TextDecoration.lineThrough:TextDecoration.none,
                            decorationThickness: 2
                        )),
                    Text("N",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * .06,
                          decoration: bingo['N']==1?TextDecoration.lineThrough:TextDecoration.none,
                            decorationThickness: 2
                        )),
                    Text("G",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * .06,
                          decoration: bingo['G']==1?TextDecoration.lineThrough:TextDecoration.none,
                            decorationThickness: 2
                        )),
                    Text("O",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * .06,
                          decoration: bingo['O']==1?TextDecoration.lineThrough:TextDecoration.none,
                            decorationThickness: 2
                        )),
                  ],
                );
              }
            ),
          ),
          ...List.generate(
              5,
              (i) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...List.generate(
                          5,
                          (j) => StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("room")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Text("");
                                }
                                int k = 0;
                                final dataStream = snapshot.requireData.docs;
                                for (k = 0; k < dataStream.length; k++) {
                                  if (dataStream[k].id == widget.roomCode) {
                                    break;
                                  }
                                }

                                return Container(
                                    height:
                                        MediaQuery.of(context).size.width * .14,
                                    width:
                                        MediaQuery.of(context).size.width * .14,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            width: 2, color: Colors.grey)),
                                    child: Center(
                                      child: MaterialButton(
                                        onPressed: () {
                                          Map<String, dynamic> updatechance =
                                              {};
                                          updatechance['start'] =
                                              dataStream[k]['start'];
                                          updatechance['end'] =
                                              dataStream[k]['end'];
                                          updatechance['first'] =
                                              dataStream[k]['first'];
                                          updatechance['second'] =
                                              dataStream[k]['second'];
                                          updatechance['secondBox'] =
                                              dataStream[k]['secondBox'];
                                          updatechance['firstBox'] =
                                              dataStream[k]['firstBox'];
                                          updatechance['chance'] =
                                              dataStream[k]['chance'];
                                          updatechance['cut'] =
                                              dataStream[k]['cut'];
                                          updatechance['firstcut'] =
                                              dataStream[k]['firstcut'];
                                          updatechance['secondcut'] =
                                              dataStream[k]['secondcut'];
                                          updatechance['winner'] = dataStream[k]['winner'];
                                          int chance = dataStream[k]['chance'];
                                          if (chance == widget.id) {
                                            setState(() {
                                              int p = 0, q = 0;
                                              String number = bingoBoard[i][j];
                                              updatechance['cut'][number] = 1;
                                            });
                                              // if(widget.id==1){
                                                updatechance['firstcut']=updateBingo(updatechance['firstcut'],updatechance['cut'],updatechance['firstBox']);
                                                updatechance['winner'] = getwinner(updatechance['firstcut'])==5?1:3;
                                              // }
                                              // else{
                                                updatechance['secondcut']=updateBingo(updatechance['secondcut'],updatechance['cut'],updatechance['secondBox']);
                                                updatechance['winner'] = getwinner(updatechance['secondcut'])==5?2:3;
                                              // }
                                        winnerid = updatechance['winner'];

                                            if (chance == 1) {
                                              updatechance['chance'] = 2;
                                            } else {
                                              updatechance['chance'] = 1;
                                            }

                                            FirebaseFirestore.instance
                                                .collection("room")
                                                .doc(widget.roomCode)
                                                .update(updatechance);

                                          }
                                          else{
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    backgroundColor:
                                                        Color.fromRGBO(
                                                            158, 158, 158, .5),
                                                    duration:
                                                        Duration(seconds: 2),
                                                    content: Text(
                                                        'It is not your turn')));
                                          }

                                          if(winnerid!=3){
                                            print(winnerid);
                                            if(widget.id==winnerid){
                                              showDialog(context: context, builder: (context)=>AlertDialog(
                                                title: Text("You Win the game",style: TextStyle(color: Colors.green),),
                                                actions: [
                                                  exitbutton(roomCode: widget.roomCode,)
                                                ],
                                              ));
                                            }
                                            else{
                                              showDialog(context: context, builder: (context)=>AlertDialog(
                                                title: Text("You Lost the game",style: TextStyle(color: Colors.red),),
                                                actions: [
                                                  exitbutton(roomCode: widget.roomCode,)
                                                ],
                                              ));
                                            }
                                          }
                                        },
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("room")
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData)
                                                return Text("");
                                              Map<String, dynamic> cut = {};
                                              for (int l = 0; l < snapshot.requireData.docs.length; l++) {
                                                if (snapshot.requireData.docs[l]
                                                        .id ==
                                                    widget.roomCode) {
                                                  cut = snapshot.requireData
                                                      .docs[l]['cut'];
                                                }
                                              }
                                              return Text(bingoBoard[i][j],
                                                  style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .04,
                                                    decoration:
                                                        cut[bingoBoard[i][j]] ==
                                                                1
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : TextDecoration
                                                                .none,
                                                    decorationThickness: 2
                                                  ));
                                            }),
                                      ),
                                    ));
                              }))
                    ],
                  )),

        ],
      ),
    );
  }
}

class exitbutton extends StatelessWidget {
  exitbutton({required this.roomCode});
String roomCode;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: (){
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        FirebaseFirestore.instance.collection("room").doc(roomCode).delete();
      },
      color: Color.fromRGBO(7, 224, 189, 1),
      child: Text("Exit"),
    );
  }
}
