/*
  Based on the mobile game: Flow Free
*/

// board has m cols and n rows. (mxn)
int m = 5;
int n = 5;

int sq_size = 100; // cell size
int nd_size = 2*sq_size/3; // node size (diameter)
int sq_size2 = sq_size/2;
int num_flows = 5; // number of pairs
int coord_start[] = {20, 20};
int coord_end[] = {m*sq_size + coord_start[0], n*sq_size + coord_start[1]};

color colors[] = {#ff0000, #00c000, #0000ff, #ffff00, #ff8000};
int board[][][];

void setup(){
  size(800, 600);
  background(#000000);
  stroke(#b0b0b0);
  
  int i, j;
  for(i = coord_start[0]; i <= coord_end[0]; i += sq_size){
    line(i, coord_start[1], i, coord_end[1]);
  }
  for(i = coord_start[1]; i <= coord_end[1]; i += sq_size){
    line(coord_start[0], i, coord_end[0], i);
  }
  
  boardInit();
}

void draw(){
  // draw board
  noStroke();
  int i, j;
  for(i = 0; i < n; i++){
   for(j = 0; j < m; j++){
     if(board[j][i][0] == -1) continue;
     fill(colors[board[j][i][0]]);
     circle(coord_start[0]+j*sq_size+sq_size2, coord_start[1]+i*sq_size+sq_size2, nd_size);
   }
  }
}

/* 
   set up board and initial nodes
   board[][][0] := number representing flow, 0 -> num_flows.
   board[][][1] := 0 if node is initial, 1 else.
*/
void boardInit(){
  board = new int[m][n][2];
  for(int i = 0; i < n; i++){
   for(int j = 0; j < m; j++){
     board[j][i][0] = -1;
     board[j][i][1] = 0;
   }
  } 
  //red
  board[0][0][0] = 0;
  board[0][0][1] = 1;
  board[1][4][0] = 0;
  board[1][4][1] = 1;
  //green
  board[2][0][0] = 1;
  board[2][0][1] = 1;
  board[1][3][0] = 1;
  board[1][3][1] = 1;
  //blue
  board[2][1][0] = 2;
  board[2][1][1] = 1;
  board[2][4][0] = 2;
  board[2][4][1] = 1;
  //yellow
  board[4][0][0] = 3;
  board[4][0][1] = 1;
  board[3][3][0] = 3;
  board[3][3][1] = 1;
  //orange
  board[4][1][0] = 4;
  board[4][1][1] = 1;
  board[3][4][0] = 4;
  board[3][4][1] = 1;
}
