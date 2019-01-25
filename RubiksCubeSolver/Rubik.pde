class Rubik {
  // Class variables
  int[][][] cubeID; // Arreglo ID para cada cara
  int[][][] solvedState; // Arreglo del estado resuelto del cubo
  
  // Permutaciones de ID sentido horario [CARA][PERMUTACION]
  int[][] permutations = new int[][] {
    // 2->1, 2->4, 2->3
    {2, 1, 4, 3}, // U
    {2, 5, 4, 0}, // L
    {0, 3, 5, 1}, // F
    {2, 0, 4, 5}, // R
    {0, 1, 5, 3}, // B
    {2, 3, 4, 1}  // D
  };
  
  int FACES = 6;   // Constante siempre habrá seis caras
  int i, j, k;     // Contadores
  int cubeLevels;  // Niveles que el rubik tiene ej. 3: 3x3
  int aux = 0;     // Variable auxiliar

  // ****************************************** Refactor ********************
  // Variables para GUI
  int squareSize;   // Tamaño de las piezas en pixeles
  color[] colorSheet = new color[FACES]; // Arreglo de colores para cada cara
  Cube cube3D;
  // ************************************************************************

  // Constructor
  Rubik(int level) {
    // Asigna tamaño y nivel al cubo y piezas
    cubeLevels = level;     
    // Asigna  ID para cada cara
    cubeID = new int[FACES][cubeLevels][cubeLevels];
    solvedState = new int[FACES][cubeLevels][cubeLevels];
    for (i = 0; i < FACES; i++) {
      for (j = 0; j < cubeLevels; j++) {
        for (k = 0; k < cubeLevels; k++) {
          cubeID[i][j][k] = i;
          solvedState[i][j][k] = i;
        }
      }
    }

    // ****************************************** Refactor ********************
    // Variables para GUI
    squareSize = height/(cubeLevels*3);  
    // Crea color para cada cara asociado a ID
    colorSheet[0] = color(20, 10, 210); // Azul
    colorSheet[1] = color(250, 140, 0); // Anaranjado
    colorSheet[2] = color(36, 36, 36);  // Negro
    colorSheet[3] = color(200, 10, 10); // Rojo
    colorSheet[4] = color(200, 200, 5); // Amarillo
    colorSheet[5] = color(10, 220, 20); // Verde
    
    // Niveles, Longitud, Identificador lógico, Color en cada cara
    cube3D = new Cube(level, squareSize * level, cubeID);
    // ************************************************************************
  }
  
  // ** Resolución **
  // 1er nivel
  // 2do nivel
  // 3er nivel
  
  // Mezclar
  void scramble(int moves) {
    for (int s = 0; s < moves; s++) {
      randomMove();
    }
    printCubeState();
  }
  void randomMove() {
    aux = floor(random(6));
    switch(aux) {
    case 0:
      right();
      break;
    case 1:
      left();
      break;
    case 2:
      up();
      break;
    case 3:
      down();
      break;
    case 4:
      front();
      break;
    case 5:
      back();
      break;
    default:
      print("Not a move.");
    }
  }
  // Movimientos sentido horario
  void right() {
    c.permutateFace(3);
    c.permutateMiddle(0, 3, cubeLevels-1);
  }
  void left() {
    c.permutateFace(1);
    c.permutateMiddle(0, 1, 0);
  }
  void front() {
    c.permutateFace(2);
    c.permutateMiddle(2, 2, cubeLevels-1);
  }
  void back() {
    c.permutateFace(4);
    c.permutateMiddle(2, 4, 0);
  }
  void up() {
    c.permutateFace(0);
    c.permutateMiddle(1, 0, 0);
  }
  void down() {
    c.permutateFace(5);
    c.permutateMiddle(1, 5, cubeLevels-1);
  }
  // En base a cara 3
  void middleX() {
    c.permutateMiddle(0, 3, 1);
  }
  // En base a cara 5
  void middleY() {
    c.permutateMiddle(1, 5, 1);
  }
  // En base a cara 2
  void middleZ() {
    c.permutateMiddle(2, 2, 1);
  }
  // Permutacion de centros
  void permutateMiddle(int axis, int face, int level) {
    int toFace;
    int onFace = permutations[face][0];
    int inverseLevel = abs(level - (cubeLevels - 1));

    switch(axis) {
    case 0: // x
      for (i = 1; i < 4; i++) {
        toFace = permutations[face][i];
        for (j = 0; j < cubeLevels; j++) {
          aux = cubeID[onFace][j][level];
          if (toFace == 4) {
            aux = cubeID[onFace][abs(j - (cubeLevels - 1))][level];
            cubeID[onFace][abs(j - (cubeLevels - 1))][level] = cubeID[toFace][j][inverseLevel];
            cubeID[toFace][j][inverseLevel] = aux;
          } else {
            cubeID[onFace][j][level] = cubeID[toFace][j][level];
            cubeID[toFace][j][level] = aux;
          }
        }
      }
      break;
    case 1: // y
      for (j = 1; j < 4; j++) {
        toFace = permutations[face][j];
        for (k = 0; k < cubeLevels; k++) {
          aux = cubeID[onFace][level][k];
          cubeID[onFace][level][k] = cubeID[toFace][level][k];
          cubeID[toFace][level][k] = aux;
        }
      }
      break;
    case 2: // z
      for (i = 1; i < 4; i++) {
        toFace = permutations[face][i];
        for (j = 0; j < cubeLevels; j++) {
          aux = cubeID[onFace][level][j];
          if (toFace == 5) {
            aux = cubeID[onFace][level][abs(j-(cubeLevels-1))];
            cubeID[onFace][level][abs(j-(cubeLevels-1))] = cubeID[toFace][inverseLevel][j];
            cubeID[toFace][inverseLevel][j] = aux;
          } else if (toFace == 3) {
            cubeID[onFace][level][j] = cubeID[toFace][j][inverseLevel];
            cubeID[toFace][j][inverseLevel] = aux;
          } else {
            aux = cubeID[onFace][level][abs(j-(cubeLevels-1))];
            cubeID[onFace][level][abs(j-(cubeLevels-1))] = cubeID[toFace][j][level];
            cubeID[toFace][j][level] = aux;
          }
        }
      }
    }
    cube3D.updateWith(cubeID);
  }
  // Permutación: Giro 90° Sentido horario de una cara
  void permutateFace(int face) {
    int[][] auxCube = new int[cubeLevels][cubeLevels];
    for (j = 0; j < cubeLevels; j++) {
      for (k = 0; k < cubeLevels; k++) {
        auxCube[j][k] = cubeID[face][j][k];
      }
    }
    for (j = 0; j < cubeLevels; j++) {
      for (k = 0; k < cubeLevels; k++) {
        cubeID[face][j][k] = auxCube[cubeLevels-(k+1)][j];
      }
    }
  }

  void printCubeState() {
    for (i = 0; i < FACES; i++) {
      for (j = 0; j < cubeLevels; j++) {
        for (k = 0; k < cubeLevels; k++) {
          print(cubeID[i][j][k]);
        }
        println();
      }
    }
  }

  // *** 2D ***
  void showRubik2D() {
    int x, xx, y, yy;
    x = 0;
    y = 0;
    xx = squareSize;
    yy = squareSize;
    // Draw Face #0
    for (j = 0; j < cubeLevels; j++) {
      for (k = 0; k < cubeLevels; k++) {
        fill(colorSheet[cubeID[0][j][k]]);
        x = squareSize * cubeLevels + squareSize * k;
        y = squareSize *j;
        rect(float(x), float(y), float(xx), float(yy));

        fill(255);
        text(cubeID[0][j][k], x + xx/3, y + yy/2);
      }
    }
    // Draw Faces (1 - 4)
    for (i = 1; i < FACES-1; i ++) {
      for (j = 0; j < cubeLevels; j++) {
        for (k = 0; k < cubeLevels; k++) {
          fill(colorSheet[cubeID[i][j][k]]);
          x = squareSize *k + cubeLevels * squareSize * (i-1);
          y = squareSize * cubeLevels + squareSize * j;
          rect(float(x), float(y), float(xx), float(yy));

          fill(255);
          text(cubeID[i][j][k], x + xx/3, y + yy/2);
        }
      }
    }
    // Draw Face #5
    for (j = 0; j < cubeLevels; j++) {
      for (k = 0; k < cubeLevels; k++) {
        fill(colorSheet[cubeID[5][j][k]]);
        x = squareSize * cubeLevels + squareSize * k;
        y = squareSize * cubeLevels * 2 + squareSize * j;
        rect(float(x), float(y), float(xx), float(yy));

        fill(255);
        text(cubeID[5][j][k], x + xx/3, y + yy/2);
      }
    }
  }

  void drawFace(int face) {
    int x, xx, y, yy;
    x = 0;
    y = 0;
    xx = squareSize;
    yy = squareSize;

    // Draw Face #n
    for (j = 0; j < cubeLevels; j++) {
      for (k = 0; k < cubeLevels; k++) {
        fill(colorSheet[cubeID[face][j][k]]);
        x = squareSize * k;
        y = squareSize * j;
        rect(float(x), float(y), float(xx), float(yy));

        fill(200);
        text(str(cubeID[face][j][k]), x + xx/2, y + yy/2);
      }
    }
  }

  // *** 3D ***
  void showRubik3D() {
    float offset = squareSize * cubeLevels;
    
    pushMatrix();
    translate(-offset/2, -offset/2, offset/2);
    drawFace(2);
    rotateY(PI);
    translate(-offset, 0, offset);
    drawFace(4);
    popMatrix();
    
    pushMatrix();
    rotateY(PI/2);
    translate(-offset/2, -offset/2, offset/2);
    drawFace(3);
    rotateY(PI);
    translate(-offset, 0, offset);
    drawFace(1);
    popMatrix();
    
    pushMatrix();
    rotateX(PI/2);
    translate(-offset/2, -offset/2, offset/2);
    drawFace(0);
    rotateX(PI);
    translate(0, -offset, offset);
    drawFace(5);
    popMatrix();
  }
  
  void drawRubik3D() {
    //cube3D.updateWith(cubeID);
    cube3D.drawCube();
  }
}
