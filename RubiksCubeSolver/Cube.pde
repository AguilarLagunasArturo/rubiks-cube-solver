class Cube {
  // ** Class variables **
  Piece[][][] pieces;
  int level;
  float lenght;
  float piece_lenght;
  float flat_piece;
  
  // Rendering stuff
  int[][][] cubeID;
  color[] colorSheet = new color[]{
    color(20, 10, 210), // Azul
    color(250, 140, 0), // Anaranjado
    color(236, 236, 236),  // Negro
    color(200, 10, 10), // Rojo
    color(200, 200, 5), // Amarillo
    color(10, 220, 20)  // Verde
  };
  
  // Cube layer stuff
  Piece[] cubeLayer;
  int layerPieces;
  int axis = -1;
  int layer = -1;
  int[] xyz = new int[3];
  // 1: horario, 2: antihorario
  int direction = 1;
  
  // Animation
  int frame = 0;
  int rate = 26;
  boolean moving = false;
  
  // ** Constructor **
  Cube(int lv, int[][][] id) {
    cubeID = id;
    level = lv;
    pieces = new Piece[level][level][level];
    
    if (width < height) 
      lenght = width / 2; 
    else
      lenght = height / 2; 
    piece_lenght = lenght / level;
    flat_piece = piece_lenght / 2;
    
    int total_pieces = (int)(pow(level, 3) - pow(level - 2, 3));
    float piece_radius = piece_lenght / 2;
    float cube_radius = (level * piece_lenght) / 2;
    float offset = piece_radius - cube_radius;

    for (int j = 0; j < level; j++) {
      for (int k = 0; k < level; k++) {
        for (int i = 0; i < level; i++) {
          if (!((j > 0 && j < level-1) && (k > 0 && k < level-1) && (i > 0 && i < level-1))) {
            pieces[i][j][k] = new Piece(piece_lenght, i * piece_lenght + offset, j * piece_lenght + offset, k * piece_lenght + offset);
          } else {
            pieces[i][j][k] = null;
          }
        }
      }
    }
    
    updateColors();
    cubeLayer =  new Piece[level*level];
    
    println("Cube level: " + level);
    println("Pieces: " + total_pieces);

    println("Piece radius: " + piece_radius);
    println("Piece lenght: " + piece_lenght);

    println("Cube radius: " + cube_radius);
    println("Cube lenght: " + lenght);
  }
  
  // ** Class fuctions **
  // Rendering in 3D *****************************************************************************
  void updateColors(){
    for (int i = 0; i < 6; i++){
      updateFaceColor(i);
    }
  }
  void updateFaceColor(int face){
    for (int i = 0; i  < level; i++){
      for (int j = 0; j  < level; j++){
        for (int k = 0; k  < level; k++){
          switch (face){
            // Caras 2 & 4
            case 2:
              if(k == level-1 && pieces[i][j][k] != null){
                pieces[i][j][k].setFaceColor(face, colorSheet[cubeID[face][j][i]]);
              }
              break;
            case 4:
              if(k == 0 && pieces[i][j][k] != null){
                pieces[i][j][k].setFaceColor(face, colorSheet[cubeID[face][j][abs(i - (level-1))]]);
              }
              break;
            // Caras 3 & 1
            case 3:
              if(i == level-1 && pieces[i][j][k] != null){
                pieces[i][j][k].setFaceColor(face, colorSheet[cubeID[face][j][abs(k - (level-1))]]);
              }
              break;
            case 1:
              if(i == 0 && pieces[i][j][k] != null){
                pieces[i][j][k].setFaceColor(face, colorSheet[cubeID[face][j][k]]);
              }
              break;
            // Caras 5 & 0
            case 5:
              if(j == level-1 && pieces[i][j][k] != null){
                pieces[i][j][k].setFaceColor(face, colorSheet[cubeID[face][abs(k - (level-1))][i]]);
              }
              break;
            case 0:
              if(j == 0 && pieces[i][j][k] != null){
                pieces[i][j][k].setFaceColor(face, colorSheet[cubeID[face][k][i]]);
              }
              break;
            default:
              println("Error.");
              exit();
          }
        }
      }
    }
  }
  // General moves
  void move(int axis_, int layer_, boolean clockwise){
    // Set the direction of the rotation
    if (clockwise)
      direction = 1;
    else
      direction = -1;
    // Set the axis and the layer in the axis
    axis = axis_;
    layer = layer_;
  }
  // Moves for 3x3 cube
  void move3x3(String notation){
    if (!moving){
      moving = true;
      switch (notation){
        case "f":
          move(2, level-1, true);
          break;
        case "b":
          move(2, 0, false);
          break;
        case "u":
          move(1, 0, false);
          break;
        case "r":
          move(0, level-1, true);
          break;
        case "d":
          move(1, level-1, true);
          break;
        case "l":
          move(0, 0, false);
          break;
        case "x":
          move(0, 1, true);
          break;
        case "y":
          move(1, 1, true);
          break;
        case "z":
          move(2, 1, true);
          break;
        case "f'":
          move(2, level-1, false);
          break;
        case "b'":
          move(2, 0, true);
          break;
        case "u'":
          move(1, 0, true);
          break;
        case "r'":
          move(0, level-1, false);
          break;
        case "d'":
          move(1, level-1, false);
          break;
        case "l'":
          move(0, 0, true);
          break;
        case "x'":
          move(0, 1, false);
          break;
        case "y'":
          move(1, 1, false);
          break;
        case "z'":
          move(2, 1, false);
          break;
        default:
          moving = true;
          println("Not a move.");
      }
    }
  }
  // Animation
  void rotateLayer(){
    for(int i = 0; i < layerPieces; i++){
      if (cubeLayer != null){
        cubeLayer[i].amt[axis] += PI/(2 * rate) * direction;
      }
    }
  }
  void animateLayer(){
    rotateLayer();
    // Draw the layer
    for(int i = 0; i < layerPieces; i++){
      if (cubeLayer != null){
        cubeLayer[i].drawPiece();
      }
    }
    frame ++;
    if (frame == rate){
      moving = false;
      frame = 0;
      // Return the piece to original position
      for(int i = 0; i < layerPieces; i++){
        if (cubeLayer != null){
          cubeLayer[i].amt[axis] = 0;
        }
      }
      rubik.move(moveList.get(0));
      moveList.remove(0);
      updateColors();
      if (moveList.size() > 0){
        move3x3(moveList.get(0));
      }
    }
  }
  void drawCube() {
    layerPieces = 0;
    for (xyz[1] = 0; xyz[1] < level; xyz[1]++) {
      for (xyz[2] = 0; xyz[2] < level; xyz[2]++) {
        for (xyz[0] = 0; xyz[0] < level; xyz[0]++) {
          if (pieces[xyz[0]][xyz[1]][xyz[2]] != null) {
            if (moving){
              if (xyz[axis] == layer){
                cubeLayer[layerPieces] = pieces[xyz[0]][xyz[1]][xyz[2]];
                layerPieces ++;
              }else{
                pieces[xyz[0]][xyz[1]][xyz[2]].drawPiece();
              }
            }else{
              pieces[xyz[0]][xyz[1]][xyz[2]].drawPiece();
            }
          }
        }
      }
    }
    if (moving){
      animateLayer();
    }
  }
  // Rendering in 2D *****************************************************************************
  void drawFace(int face, float xOff, float yOff) {
    float x, xx, y, yy;
    x = 0;
    y = 0;
    xx = flat_piece;
    yy = flat_piece;

    // Draw Face #n
    for (int j = 0; j < level; j++) {
      for (int k = 0; k < level; k++) {
        fill(colorSheet[cubeID[face][j][k]]);
        x = flat_piece * k + xOff;
        y = flat_piece * j + yOff;
        rect(x, y, xx, yy);

        fill(200);
        text(str(cubeID[face][j][k]), x + xx/2, y + yy/2);
      }
    }
  }
  void drawFlatCube(){
    float unit = flat_piece * level;
    float xOff = abs(unit * 4 - width) / 2;
    float yOff = abs(unit * 3 - height) / 2;
    drawFace(0, unit + xOff, +yOff);
    for (int i = 0; i < 4; i++)
      drawFace(i + 1, unit * i + xOff, unit + yOff);
    drawFace(5, unit + xOff, unit * 2 + yOff);
  }
}
