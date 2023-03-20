Map<String,dynamic> updateBingo(Map<String,dynamic>bingo,Map<String,dynamic>cut,Map<String,dynamic>board){
  bingo['B']=0;
  bingo['I']=0;
  bingo['N']=0;
  bingo['G']=0;
  bingo['O']=0;
  int total=0;
  for(int i=1;i<=5;i++){
    int row = 0;
    for(int j=0;j<5;j++){
      if(cut[board[i.toString()][j]]==1){
        row++;
      }
    }
    if(row==5){
      total++;
    }
  }

  for(int i=0;i<5;i++){
    int col = 0;
    for(int j=1;j<=5;j++){
      if(cut[board[j.toString()][i]]==1){
        col++;
      }
    }
    if(col==5){
      total++;
    }
  }

  int i=1,j=0;
  int d1=0;
  while(i<=5 && j<5){
    if(cut[board[i.toString()][j]]==1){
      d1++;
    }
    i++;
    j++;
  }
  if(d1==5){
    total++;
  }

  i=1;j=4;
  int d2=0;
  while(i<=5 && j>=0){
    if(cut[board[i.toString()][j]]==1){
      d2++;
    }
    i++;
    j--;
  }
  if(d2==5){
    total++;
  }
  while(total>0){
    total--;
    if(bingo['B']==0) bingo['B']=1;
    else if (bingo['I']==0) bingo['I']=1;
    else if (bingo['N']==0) bingo['N']=1;
    else if (bingo['G']==0) bingo['G']=1;
    else if (bingo['O']==0) bingo['O']=1;
  }
  return bingo;
}