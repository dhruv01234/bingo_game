import 'package:bingo_game/pages/createOrJoinPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SafeArea(
      child: startPage(),
    ),
  ));
}

class startPage extends StatefulWidget {
  const startPage({Key? key}) : super(key: key);

  @override
  State<startPage> createState() => _startPageState();
}

class _startPageState extends State<startPage> {
  @override
  String name = "player";
  Widget build(BuildContext context){
    String newname = name;
    return Scaffold(
      backgroundColor: Color.fromRGBO(7, 224, 189, 1),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/profile.png',
                  width: 60,
                  height: 60,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(name),
                    MaterialButton(
                      height: 30,
                      color: Colors.white60,
                      onPressed: (){
                          showDialog(context: context, builder: (context)=>AlertDialog(
                            title: Text("Edit Username"),
                            actions: [
                              TextField(
                                onChanged: (nwname){
                                    newname = nwname;
                                },
                              ),
                              MaterialButton(
                                onPressed: (){
                                    setState((){
                                      name = newname;
                                    });
                                    Navigator.pop(context);
                              },
                              color: Color.fromRGBO(7, 224, 189, 1),
                                child: Text("Change"),
                              )
                            ],
                          ));
                      },
                      child: Text('Edit Profile'),
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .1,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade700, width: 3),
            ),
            child: Text(
              "BINGO",
              style: TextStyle(
                  fontSize: 40, letterSpacing: 10, color: Colors.grey.shade700),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .1,
          ),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                    MediaQuery.of(context).size.height * .25,
                  )),
                  border: Border.all(
                    color: Colors.black,
                  )),
              height: MediaQuery.of(context).size.height * .25,
              width: MediaQuery.of(context).size.height * .25,
              child: Center(
                child: MaterialButton(
                    // color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height * .25,
                    )),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CRTorJN(name: name,)));
                    },
                    padding: EdgeInsets.only(bottom: 50),
                    child: Icon(
                      Icons.play_circle,
                      size: MediaQuery.of(context).size.height * .25,
                    )),
              ))
        ],
      )),
    );
  }
}
