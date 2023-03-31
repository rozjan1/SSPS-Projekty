enum Direction {
  LEFT, RIGHT, UP, DOWN ;

  public Direction getOpposite() {
    if (this == Direction.LEFT) return Direction.RIGHT; 
    if (this == Direction.RIGHT) return Direction.LEFT; 
    if (this == Direction.DOWN) return Direction.UP; 
    if (this == Direction.UP) return Direction.DOWN; 
    return Direction.DOWN;
  }

  public Direction turnLeft() {
    if (this == Direction.LEFT) return Direction.DOWN; 
    if (this == Direction.RIGHT) return Direction.UP; 
    if (this == Direction.DOWN) return Direction.RIGHT; 
    if (this == Direction.UP) return Direction.LEFT; 
    return Direction.DOWN;
  }

  public static Direction getFromNumber(int num) {
    if (num == 0) return Direction.UP;
    if (num == 1) return Direction.RIGHT;
    if (num == 2) return Direction.DOWN;
    return Direction.LEFT;
  }
  
  public int getNumber() {
    if (this == Direction.UP) return 0;
    if (this == Direction.RIGHT) return 1;
    if (this == Direction.DOWN) return 2;
    return 3;
  }
}
