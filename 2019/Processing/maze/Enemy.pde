class Enemy extends GameObject {
  // jak casto se pohne, v ms
  long speed;

  // cas systemu od doby co se pohnul, v ms
  long lastMoved = 0;
  
  Direction movingDirection = Direction.S;

  Enemy(Coordinate pos, long speed) {
    super(pos);
    this.speed = speed;
  }

  void display(int x, int y, int sizeX, int sizeY) {
    fill(0, 0, 255);
    rect(x, y, sizeX, sizeY);
  }
  
  void move(Direction dir) {
    Coordinate where = Coordinate.add(position, dir.getOffset());
   
    if (game.getPlayerPosition().equals(where)) {
      game.player.takeDamage(1);
    }
   
    if (!game.isWalkableAt(where)) {
      movingDirection = Direction.flip(movingDirection);
      return;
    }
    
    game.move(this,  position, where);
    position = where;
  }

  @Override
    void update() {
    long currentMillis = millis();
    if (currentMillis - lastMoved >= speed) {
      move(movingDirection);
      lastMoved = currentMillis;
    }
  }
  
  @Override 
    boolean isWalkable() {
    return false;
  }
  
  @Override 
  boolean isDangerous() {
   return true; 
  }
  @Override 
  String getSerializationString() {
    return "e"; 
  }
}
