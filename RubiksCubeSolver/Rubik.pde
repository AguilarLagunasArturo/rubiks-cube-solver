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
  
  void addMove(String newMove){
    moveList.add(newMove);
    println(moveList.size());
  }

  // Movimientos sentido horario | Permutar cara antes que centro
  void right() {
    permutateFace(3);
    permutateMiddle(0, 3, cubeLevels-1);
  }
  void left() {
    permutateFace(1);
    permutateMiddle(0, 1, 0);
  }
  void front() {
    permutateFace(2);
    permutateMiddle(2, 2, cubeLevels-1);
  }
  void back() {
    permutateFace(4);
    permutateMiddle(2, 4, 0);
  }
  void up() {
    permutateFace(0);
    permutateMiddle(1, 0, 0);
  }
  void down() {
    permutateFace(5);
    permutateMiddle(1, 5, cubeLevels-1);
  }
  // En base a cara 3
  void middleX() {
    permutateMiddle(0, 3, 1);
  }
  // En base a cara 5
  void middleY() {
    permutateMiddle(1, 5, 1);
  }
  // En base a cara 2
  void middleZ() {
    permutateMiddle(2, 2, 1);
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
  }
  
  void move(String permutation){
    switch(permutation){
      case "r":
        right();
        break;
      case "l":
        left();
        break;
      case "f":
        front();
        break;
      case "b":
        back();
        break;
      case "u":
        up();
        break;
      case "d":
        down();
        break;
      case "x":
        middleX();
        break;
      case "y":
        middleY();
        break;
      case "z":
        middleZ();
        break;
      case "r'":
        right();
        right();
        right();
        break;
      case "l'":
        left();
        left();
        left();
        break;
      case "f'":
        front();
        front();
        front();
        break;
      case "b'":
        back();
        back();
        back();
        break;
      case "u'":
        up();
        up();
        up();
        break;
      case "d'":
        down();
        down();
        down();
        break;
      case "x'":
        middleX();
        middleX();
        middleX();
        break;
      case "y'":
        middleY();
        middleY();
        middleY();
        break;
      case "z'":
        middleZ();
        middleZ();
        middleZ();
        break;
      default:
        println("Not a move.");
    }
  }
  
  void readMoves(String file){
    
  }
  
  void drawRubik3D() {
    render.drawCube();
  }
  void drawRubik2D() {
    render.drawFlatCube();
  }
}
