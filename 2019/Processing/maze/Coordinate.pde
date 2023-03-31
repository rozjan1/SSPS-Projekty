static class Coordinate {
  int x, y;

  Coordinate() {
  }

  Coordinate(int x, int y) {
    this.x = x;
    this.y = y;
  }

 
  Coordinate copy() {
    return new Coordinate(x, y);
  }

  // velikost vektoru
  float mag() {
    return sqrt(x * x + y * y);
  }

  void add(Coordinate a) {
    x += a.x;
    y += a.y;
  }

  static Coordinate add(Coordinate a, Coordinate b) {
    return new Coordinate(a.x + b.x, a.y + b.y);
  }

  static Coordinate sub(Coordinate a, Coordinate b) {
    return new Coordinate(a.x - b.x, a.y - b.y);
  }

  static float getDistance(Coordinate a, Coordinate b) {
    Coordinate c = sub(a, b);
    return c.mag();
  }

  @Override
    String toString() {
    return "[" + x + "," + y + "]";
  }

  @Override
    boolean equals(Object b) {
    if (! (b instanceof Coordinate)) return false;

    Coordinate casted = (Coordinate) b;

    return casted.x == this.x && casted.y == this.y;
  }
}
