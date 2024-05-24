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
int coord_start[] = {20, 20};
int coord_end[] = {m*sq_size + coord_start[0], n*sq_size + coord_start[1]};

int board[][][];

color colors[] = {#ff0000, #00c000, #0000ff, #ffff00, #ff8000};

// num_flows 4-tuples: (node1x, node1y, node2x, node2y).
int level[][] = {{3,0,1,3}, {4,3,2,4}, {0,0,1,4}, {3,1,2,2}, {4,0,2,3}};


class Flow {
  public int id; // 0 <= id < num_flows
  public color c;
  public int node1[]; // coordinates of first init node
  public int node2[]; // coordinates of second init node
  public int currStart; // 1 for node1, or 2 for node2
  public char pipe[]; // m*n array of char instructions for constructing a flow from currStart
  public int pipeLen; // length of pipe[]
  public Flow(){
    id = -1;
    c = #ffffff;
    node1 = new int[2];
    node2 = new int[2];
    node2[0] = node2[1] = -1;
    node1[0] = node1[1] = -1;
    currStart = -1; // uninitialized
    pipe = new char[m*n];
    pipeLen = 0;
  }
  public Flow(int id, color c, int node1[], int node2[]){ 
    this.id = id;
    this.c = c;
    this.node1 = new int[2];
    this.node2 = new int[2];
    this.node1[0] = node1[0];
    this.node1[1] = node1[1];
    this.node2[0] = node2[0];
    this.node2[1] = node2[1];
    currStart = -1; // uninitialized
    pipe = new char[m*n];
    pipeLen = 0;
  }
  public void initialize(int id, color c, int node1[], int node2[]){
    this.id = id;
    this.c = c;
    this.node1 = new int[2];
    this.node2 = new int[2];
    this.node1[0] = node1[0];
    this.node1[1] = node1[1];
    this.node2[0] = node2[0];
    this.node2[1] = node2[1];
  }
}

Flow flows[]; // stores all Flow objects
int num_flows = 5; // number of pairs

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

// takes information from "level" to initialize flows
void flowInit(){
  int n1[] = {-1, -1};
  int n2[] = {-1, -1};
  flows = new Flow[num_flows];
  for(int i = 0; i < num_flows; i++){
    n1[0] = level[i][0];
    n1[1] = level[i][1];
    n2[0] = level[i][2];
    n2[1] = level[i][3];
    flows[i] = new Flow(i, colors[i], n1, n2);
  }
}

/* 
   set up board and initial nodes
   board[][][0] := number representing flow, 0 -> num_flows.
   board[][][1] := 0 if node is initial, 1 else.
*/
void boardInit(){
  int i, j;
  board = new int[m][n][2];
  for(j = 0; j < m; j++){
    for(i = 0; i < n; i++){
      board[j][i][0] = -1;
      board[j][i][1] = -1;
    }
  }
  // fill board based on flows[] ( AFTER initFlow() )
  Flow f;
  for(i = 0; i < num_flows; i++){
    f = flows[i];
    board[f.node1[0]][f.node1[1]][0] = f.id;
    board[f.node1[0]][f.node1[1]][1] = 0;
    board[f.node2[0]][f.node2[1]][0] = f.id;
    board[f.node2[0]][f.node2[1]][1] = 0;
  }
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
  // figure out what to do if flow intersects another:
  int intersectID = board[j][i][0];
  int replacementID = board[p_j][p_i][0];
  
  // configure board information
  board[j][i][0] = board[p_j][p_i][0];
  board[j][i][1] = 1;
  // configure flow information
  
  
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
