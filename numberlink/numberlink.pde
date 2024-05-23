/*
  Based on the mobile game: Flow Free
*/

// board has m cols and n rows. (mxn)
int m = 5;
int n = 5;

int sq_size = 100; // cell size
int sq_size2 = sq_size/2;
int nd_size = 2*sq_size/3; // node size (diameter)
int pipe_size = 2*nd_size/3;
int nub_size = (nd_size + pipe_size)/2;
int num_flows = 5; // number of pairs
int coord_start[] = {20, 20};
int coord_end[] = {m*sq_size + coord_start[0], n*sq_size + coord_start[1]};

color colors[] = {#ff0000, #00c000, #0000ff, #ffff00, #ff8000};
int board[][][];

int flows[][][];
int flowsLen[];
int flowsStart[];

void setup(){
  size(800, 600);
  flowInit();
  boardInit();
  background(#000000);
  boardDraw();
}

void draw(){
  background(#000000);
  checkInput();
  boardDraw();
}

/*
    Inits a (num_flows x (m*n) x 2) coord array 
    flows[][][0] := x-coord of flow
    flows[][][1] := y-coord of flow
*/
void flowInit(){
  flows = new int[num_flows][m*n][2];
  flowsLen = new int[num_flows];
  flowsStart = new int[num_flows];
}

/*
    check if the mouse is currently held,
    evaluate conditions to extend/delete a flow,
    update board[][][] accordingly
*/
void checkInput(){
  if(!mousePressed) return;
  int i = (mouseY - coord_start[1]) / sq_size;
  int j = (mouseX - coord_start[0]) / sq_size;
  // end if outside board
  if(mouseY < coord_start[1] || i >= n || mouseX < coord_start[0] || j >= m) return;
  // mouse is on board[j][i]
  fill(#808080, 80);
  square(j*sq_size+coord_start[1], i*sq_size+coord_start[0], sq_size);
  int p_i = (pmouseY - coord_start[1]) / sq_size;
  int p_j = (pmouseX - coord_start[0]) / sq_size;
  // end here if previous frame's mouse is off board
  if(pmouseY < coord_start[1] || p_i >= n || pmouseX < coord_start[0] || p_j >= m) return;
  // end if previous frame is not touching another node
  if(board[p_j][p_i][0] == -1) return;
  // end if current move replaced an initial node
  if(board[j][i][1] == 0) return;
  // end if current move is not UDLR
  if(!((p_i == i + 1 || p_i == i - 1) && p_j == j) && !(((p_j == j + 1 || p_j == j - 1) && p_i == i))) return;
  // USE INFO FROM flowInit():
  
  
  board[j][i][0] = board[p_j][p_i][0];
  board[j][i][1] = 1;
}

/*
    render board based on board[][][] array,
    first draw lines (only stroke),
    then draw flows (only fill)
*/
void boardDraw(){
  // draw lines
  stroke(#b0b0b0);
  int i, j;
  for(i = coord_start[0]; i <= coord_end[0]; i += sq_size){
    line(i, coord_start[1], i, coord_end[1]);
  }
  for(i = coord_start[1]; i <= coord_end[1]; i += sq_size){
    line(coord_start[0], i, coord_end[0], i);
  }
  // draw flows
  noStroke();
  int curr_size;
  for(j = 0; j < m; j++){
    for(i = 0; i < n; i++){
      if(board[j][i][0] == -1) continue;
      fill(colors[board[j][i][0]]);
      if(board[j][i][1] == 0){
        curr_size = nd_size;
      } else {
        curr_size = pipe_size;
      }
      circle(coord_start[0]+j*sq_size+sq_size2, coord_start[1]+i*sq_size+sq_size2, curr_size);
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
  for(int j = 0; j < m; j++){
    for(int i = 0; i < n; i++){
      board[j][i][0] = -1;
      board[j][i][1] = -1;
    }
  } 
  //red
  board[0][0][0] = 0;
  board[0][0][1] = 0;
  board[1][4][0] = 0;
  board[1][4][1] = 0;
  //green
  board[2][0][0] = 1;
  board[2][0][1] = 0;
  board[1][3][0] = 1;
  board[1][3][1] = 0;
  //blue
  board[2][1][0] = 2;
  board[2][1][1] = 0;
  board[2][4][0] = 2;
  board[2][4][1] = 0;
  //yellow
  board[4][0][0] = 3;
  board[4][0][1] = 0;
  board[3][3][0] = 3;
  board[3][3][1] = 0;
  //orange
  board[4][1][0] = 4;
  board[4][1][1] = 0;
  board[3][4][0] = 4;
  board[3][4][1] = 0;
}
