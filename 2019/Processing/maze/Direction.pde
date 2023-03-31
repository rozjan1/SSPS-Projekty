enum Direction {
  N, E, S, W;

  Coordinate getOffset() {
    if (this == Direction.N) return new Coordinate(0, -1); 
    if (this == Direction.E) return new Coordinate(1, 0); 
    if (this == Direction.S) return new Coordinate(0, 1); 
    if (this == Direction.W) return new Coordinate(-1, 0); 
    return null;
  }
  
  static Direction flip(Direction currDir) {
    if (currDir == Direction.N) return Direction.S;
    if (currDir == Direction.E) return Direction.W;
    if (currDir == Direction.S) return Direction.N;
    if (currDir == Direction.W) return Direction.E;
    return null;
  }
}
