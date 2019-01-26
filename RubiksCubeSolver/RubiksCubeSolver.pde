Rubik c;

void setup() {
  // Limit: 35 Levels
  c = new Rubik(3);
  size(250, 250, P3D);
}

void draw() {
  background(70);
  translate(width/2, height/2);
  rotateX(map(mouseY, 0, height, PI, -PI));
  rotateY(map(mouseX, 0, width, -PI, PI));

  c.drawRubik3D();
}

void keyPressed() {
  if (!c.render.moving) {
    switch(key) {
      case 'x':
        c.middleX();
        c.render.move3x3('x');
        break;
      case 'y':
        c.middleY();
        c.render.move3x3('y');
        break;
      case 'z':
        c.middleZ();
        c.render.move3x3('z');
        break;
      case 'f':
        c.front();
        c.render.move3x3('f');
        break;
      case 'b':
        c.back();
        c.render.move3x3('b');
        break;
      case 'r':
        c.right();
        c.render.move3x3('r');
        break;
      case 'l':
        c.left();
        c.render.move3x3('l');
        break;
      case 'u':
        c.up();
        c.render.move3x3('u');
        break;
      case 'd':
        c.down();
        c.render.move3x3('d');
        break;
      case 's':
        c.scramble(2);
        break;
      default:
        println("Not a move.");
    }
  }
}
