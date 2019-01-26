class Rubik {
  // Class variables
  int[][][] cubeID; // Arreglo ID para cada cara
  int[][][] solvedState; // Arreglo del estado resuelto del cubo
  Cube render;
  
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
    // Niveles, Identificador de piezas
    render = new Cube(cubeLevels, cubeID);
  }
  
  // ** Resolución **
  // 1er nivel
  // 2do nivel
  // 3er nivel
  
  // Mezclar
  void scramble(int moves) {
    for (int s = 0; s < moves; s++){
      randomMove();
    }
  }
  void randomMove() {
    aux = floor(random(6));
    // **********************************************************
    // if render.moving:
    //   render.addStep(aux);
    // **********************************************************
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
  // Movimientos sentido horario | Permutar cara antes que centro
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
  // Permutación de centros
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
    render.updateWith(cubeID);
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
  
  void drawRubik3D() {
    //render.updateWith(cubeID);
    render.drawCube();
  }
  void drawRubik2D() {
    //render.updateWith(cubeID);
    render.drawFlatCube();
  }
}
