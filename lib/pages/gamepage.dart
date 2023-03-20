import 'package:bingo_game/components/roomlist.dart';
import 'package:bingo_game/pages/bingopage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/checkboard.dart';

class GamePage extends StatefulWidget {
  GamePage({required this.m,required this.roomNum,required this.id});
  QuerySnapshot m;
  int roomNum;
  int id;
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    List<List<String>> board=[];
    for(int i=0;i<5;i++){
      List<String> rowlist=[];
      for(int j=0;j<5;j++){
        rowlist.add("0");
      }
      board.add(rowlist);
    }
    return WillPopScope(
      onWillPop: () {
        FirebaseFirestore.instance.collection("room").doc(widget.m.docs[widget.roomNum].id).delete();
        Navigator.pop(context);
        Navigator.pop(context);
        return Future.value(false); },
      child: SafeArea(child: Scaffold(
        backgroundColor: Color.fromRGBO(7, 224, 189, 1),
        appBar: AppBar(
          backgroundColor: Colors.white60,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text('Fill Your Box',style: TextStyle(color: Colors.black,letterSpacing: 3,fontSize: 20),),

        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 15,bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Fill the numbers in each box from 1 to 25",style: TextStyle(fontSize: 20,
                  color: Colors.transparent,
                  shadows: [Shadow(offset: Offset(0, -5), color: Colors.black)],
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.black,
                ),
                ),
                BingoBox(board: board,),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("room").snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return Text("");
                    Map<String,dynamic> fboard = {};
                    Map<String,dynamic> sboard = {};
                    final boardDeatils = snapshot.requireData;
                    fboard = boardDeatils.docs[widget.roomNum]['firstBox'];
                    sboard = boardDeatils.docs[widget.roomNum]['secondBox'];
                    return MaterialButton(
                      color: Colors.grey,
                      onPressed: (){
                        bool isCorrect = checkBoard(board);
                        Map<String,List<String>> bingoBoard={};
                        for(int i=0;i<5;i++){
                          List<String> l=[];
                            for(int j=0;j<5;j++){
                              l.add(board[i][j]);
                            }
                            bingoBoard[(i+1).toString()] = l;
                        }
                        if(isCorrect){
                          Map<String,dynamic> updatedroomdetails = RoomList(widget.m.docs[widget.roomNum]['first'], widget.m.docs[widget.roomNum]['second']);
                          updatedroomdetails['start'] = true;
                          if(widget.id==1) {
                            updatedroomdetails['firstBox'] = bingoBoard;
                            updatedroomdetails['secondBox'] = sboard;
                          }
                          else {
                            updatedroomdetails['firstBox'] = fboard;
                            updatedroomdetails['secondBox'] = bingoBoard;
                          }
                          FirebaseFirestore.instance.collection("room").doc(widget.m.docs[widget.roomNum].id).update(updatedroomdetails);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BINGO(roomCode: widget.m.docs[widget.roomNum].id,id:widget.id)));
                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor:Color.fromRGBO(158, 158, 158, .5),
                                  duration:Duration(seconds: 1),
                                  content: Text("Fill the board correctly"))
                          );
                        }
                      },
                      child: Text('Confirm'),
                    );
                  }
                )
              ],
            ),
          )
        ),
      )),
    );
  }
}

class BingoBox extends StatefulWidget {
  BingoBox({required this.board});
List<List<String>> board;
  @override
  State<BingoBox> createState() => _BingoBoxState();
}

class _BingoBoxState extends State<BingoBox> {
  @override
  Widget build(BuildContext context){

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
            ...List.generate(
                5,
                    (i) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...List.generate(5,
                                (j) =>Container(
                                    height: MediaQuery.of(context).size.width*.14,
                                    width: MediaQuery.of(context).size.width*.14,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(width: 2,color: Colors.grey)
                                    ),
                                    child: TextField(
                                      onChanged: (number){
                                        setState((){
                                          widget.board[i][j] = number;
                                        });

                                      },
                                      textAlign: TextAlign.center,
                                      textAlignVertical: TextAlignVertical.center,

                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width*.06),
                                      keyboardType: TextInputType.number,
                                      maxLength: 2,
                                      maxLines: 1,
                                      enableSuggestions: false,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        counterText: "",
                                      ),
                                    )
                                )
                        )
                      ],
                    )

            )
        ],
      ),
    );
  }
}
