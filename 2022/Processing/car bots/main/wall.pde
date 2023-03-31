class Wall {
  PVector coord;
  PVector coord1;
  
  Wall(int x, int y, int x1, int y1) {
    coord = new PVector(x, y);
    coord1 = new PVector(x1, y1);
  }

  void display() {
    line(coord.x, coord.y, coord1.x, coord1.y);
  }

  
}
