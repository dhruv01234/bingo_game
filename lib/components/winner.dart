import 'package:flutter/material.dart';

int getwinner(Map<String,dynamic> bingo){
  int total = bingo['B']+bingo['I']+bingo['N']+bingo['G']+bingo['O'];
// print(total+5);
 return total;

}