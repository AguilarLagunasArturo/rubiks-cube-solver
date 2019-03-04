// Lista de movimientos que aún no se realizan
ArrayList<String> moveList = new ArrayList<String>();
Rubik rubik;
String[] availableMoves = new String[]{
  "u", "u'",
  "r", "r'",
  "d", "d'",
  "l", "l'", 
  "f", "f'",
  "b", "b'",
  "x", "y", "z",
  "x'", "y'", "z'"
};
void setup() {
  // Limit: 35 Levels
  rubik = new Rubik(3);
  size(250, 250, P3D);
}

void draw() {
  background(70);
  translate(width/2, height/2);
  rotateX(map(mouseY, 0, height, PI, -PI));
  rotateY(map(mouseX, 0, width, -PI, PI));

  rubik.drawRubik3D();
}

void keyPressed() {
  if (key == 'x' || key == 'y' || key == 'z' ||
      key == 'u' || key == 'r' || key == 'd' ||
      key == 'l' || key == 'f' || key == 'b') {
    rubik.addMove(str(key));
    rubik.render.move3x3(moveList.get(0));
  }else if (key == 's'){
    for (int i = 0; i < 20; i ++)
      rubik.addMove(availableMoves[floor(random(availableMoves.length))]);
    rubik.render.move3x3(moveList.get(0));
  }else if (key == 'a'){
    rubik.readAlgorithm("algorithms/magic.txt");
  }
}
