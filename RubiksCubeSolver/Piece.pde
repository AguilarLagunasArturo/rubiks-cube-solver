class Piece {
  // Class variables
  float x, y, z;
  float l, r;
  float[] amt =  new float[3];

  // Vertices
  PVector[] vertices = new PVector[6];
  // Lines
  int[] lines = new int[]{
    0, 1, 0, 3, 0, 4, 
    2, 1, 2, 3, 2, 6, 
    5, 1, 5, 4, 5, 6, 
    7, 3, 7, 4, 7, 6
  };
  // Faces
  int[] faces = new int[]{
    0, 1, 2, 3, 
    0, 3, 7, 4, 
    3, 2, 6, 7, 
    2, 1, 5, 6, 
    0, 1, 5, 4, 
    4, 5, 6, 7
  };

  color[] colors = new color[]{
    color(1, 1, 1),
    color(1, 1, 1),
    color(1, 1, 1),
    color(1, 1, 1),
    color(1, 1, 1),
    color(1, 1, 1)
  };

  // Constructor
  Piece(float lenght, float x_off, float y_off, float z_off) {
    // Piece's lenght
    l = lenght;
    // Piece's radius
    r = l / 2;
    // Vertices offset
    x = x_off;
    y = y_off;
    z = z_off;

    vertices = new PVector[]{
      new PVector(-r + x, -r + y, -r + z), 
      new PVector( r + x, -r + y, -r + z), 
      new PVector( r + x, -r + y,  r + z), 
      new PVector(-r + x, -r + y,  r + z), 

      new PVector(-r + x,  r + y, -r + z), 
      new PVector( r + x,  r + y, -r + z), 
      new PVector( r + x,  r + y,  r + z), 
      new PVector(-r + x,  r + y,  r + z)
    };
  }

  // Show piece
  void drawPiece() {
    pushMatrix();
    rotateX(amt[0]);
    rotateY(amt[1]);
    rotateZ(amt[2]);
    beginShape(LINES);
    for (int i = 0; i < 24; i += 2) {
      vertex(vertices[lines[i]].x, vertices[lines[i]].y, vertices[lines[i]].z);
      vertex(vertices[lines[i + 1]].x, vertices[lines[i + 1]].y, vertices[lines[i + 1]].z);
    }
    endShape();

    beginShape(QUADS);
    for (int i = 0; i < 24; i += 4) {
      if ( (i + 4) % 4 == 0)
        fill(colors[(i+4)/4 - 1]);
      for (int j = 0; j < 4; j++)
        vertex(vertices[faces[i + j]].x, vertices[faces[i + j]].y, vertices[faces[i + j]].z);
    }
    endShape();
    popMatrix();
  }
  
  void setFaceColor(int face, color newColor){
    colors[face] = newColor;
  }
}
