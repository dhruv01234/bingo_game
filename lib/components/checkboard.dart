bool checkBoard(List<List<String>> board){
  Map<String,int> m={};
  for(int i=1;i<=25;i++){
    m[i.toString()] = 0;
  }
  for(int i=0;i<5;i++){
    for(int j=0;j<5;j++){
     m[board[i][j]] = 1;
    }
  }
  for(int i=1;i<=25;i++){
    if(m[i.toString()]==0) return false;
  }
  return true;
}