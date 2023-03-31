class Player extends GameObject {
  int lives = 3;

  Player(Coordinate pos, int lives) {
    super(pos);
    this.lives = lives;
  }

  void takeDamage(int howMuch) {
    lives -= howMuch;
    if (lives <= 0) {  
      println("I am DEAD!");
      runner.restart();
      
    }
  }

  void move(Direction dir) {
    Coordinate where = Coordinate.add(position, dir.getOffset());

    if (!game.isInMap(where)) return;

    if (game.isDangerous(where)) {
      takeDamage(1);
      return;
    }

    if (!game.isWalkableAt(where)) {
      return;
    }

    game.move(this, position, where);
  }

  @Override
    void display(int x, int y, int sizeX, int sizeY) {
    fill(123, 74, 212); //<>//
    rect(x, y, sizeX, sizeY);
  } 

  @Override 
    boolean isWalkable() {
    return false;
  }

  @Override 
    boolean isDangerous() {
    return false;
  }
  @Override 
  String getSerializationString() {
    return "x";
  }
}
