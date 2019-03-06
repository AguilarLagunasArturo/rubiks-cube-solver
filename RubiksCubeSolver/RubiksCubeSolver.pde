// Lista de movimientos que aún no se realizan
ArrayList<String> moveList = new ArrayList<String>();
Rubik rubik;
String[] availableMoves = new String[]{
  "u", "r", "d", "l",  "f", "b",
  "u'","r'","d'","l'", "f'","b'",
  "x", "y", "z",
  "x'", "y'", "z'"
};
float theta = 0;

void setup() {
  // Limit: 35 Levels
  rubik = new Rubik(3);
  size(500, 500, P3D);
  strokeWeight(2);
  stroke(3, 79, 80);
}

void draw() {
  background(142, 159, 187);
  translate(width/2, height/2);
  rotateX(map(mouseY, 0, height, PI, -PI));
  rotateY(map(mouseX, 0, width, -PI, PI));
  rotateX(-PI/6);
  rotateY(theta);
  rubik.drawRubik3D();
  //theta += TWO_PI/1500;
}

void keyPressed() {
  if (key == 'x' || key == 'y' || key == 'z' ||
      key == 'u' || key == 'r' || key == 'd' ||
      key == 'l' || key == 'f' || key == 'b') {
    rubik.addMove(str(key));
    rubik.render.move3x3(moveList.get(0));
  }else if (key == 's'){
    for (int i = 0; i < 15; i ++){
      String randomMove = availableMoves[floor(random(6))];
      rubik.addMove(randomMove);
    }
    rubik.render.move3x3(moveList.get(0));
  }else if (key == 'a'){
    rubik.readAlgorithm("algorithms/pattern.txt");
  }
}
