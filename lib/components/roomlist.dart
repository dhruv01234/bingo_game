Map<String,dynamic> RoomList(String hostname,String second){
  Map<String,int> cut={};
  for(int i=1;i<=25;i++){
    cut[i.toString()] = 0;
  }
  Map<String,dynamic> quiz= {
    'first':hostname,
    'second':second,
    'start':false,
    'end':false,
    'chance':1,
    'firstBox':{},
    'secondBox':{},
    'cut':cut,
    'firstcut':{
      "B":0,
      "I":0,
      "N":0,
      "G":0,
      "O":0,
    },
    'secondcut':{
      "B":0,
      "I":0,
      "N":0,
      "G":0,
      "O":0,
    },
    "winner":3,
  };
  return quiz;
}