Rubik c;
boolean fuctional = false;

void setup() {
  // Limit: 35 Levels
  c = new Rubik(3);
  size(400, 400, P3D);
}

void draw() {
  background(70);
  translate(width/2, height/2);
  rotateX(map(mouseY, 0, height, PI, -PI));
  rotateY(map(mouseX, 0, width, -PI,  PI));
  
  if (fuctional)
    c.showRubik3D();
  else
    c.drawRubik3D();
}

void keyPressed() {
  if (fuctional){
    switch(key) {
      case 'f':
        c.front();
        println("Front");
        break;
      case 'b':
        c.back();
        println("Back");
        break;
      case 'r':
        c.right();
        println("Right");
        break;
      case 'l':
        c.left();
        println("Left");
        break;
      case 'u':
        c.up();
        println("Up");
        break;
      case 'd':
        c.down();
        println("Down");
        break;
      case '3': 
        c.middleY(); // En base a cara 0
        println("My");
        break;
      case '2':
        c.middleX(); // En base a cara 3
        println("Mx");
        break;
      case '1':
        c.middleZ(); // En base a cara 2
        println("Mz");
        break;
      case 's':
        c.scramble(10);
        break;
      default:
        println("Not a valid move.");
    }
  }else{
    if (!c.cube3D.moving){
      switch(key) {
        case 'x':
          c.middleX();
          c.cube3D.move3x3('x');
          break;
        case 'y':
          c.middleY();
          c.cube3D.move3x3('y');
          break;
        case 'z':
          c.middleZ();
          c.cube3D.move3x3('z');
          break;
        case 'f':
          c.front();
          c.cube3D.move3x3('f');
          break;
        case 'b':
          c.back();
          c.cube3D.move3x3('b');
          break;
        case 'r':
          c.right();
          c.cube3D.move3x3('r');
          break;
        case 'l':
          c.left();
          c.cube3D.move3x3('l');
          break;
        case 'u':
          c.up();
          c.cube3D.move3x3('u');
          break;
        case 'd':
          c.down();
          c.cube3D.move3x3('d');
          break;
        default:
          println("Not a move.");
      }
    }
  }
}
