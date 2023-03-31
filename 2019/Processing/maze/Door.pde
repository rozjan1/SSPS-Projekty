class Door extends GameObject {
  Door(Coordinate pos) {
    super(pos);
  }

  boolean isOpen = false;
  boolean isSpacePressed = false;

  void display(int x, int y, int sizeX, int sizeY) {
    PImage sprite;
    if (isOpen) {
      sprite = spritesRepository.resize(spritesRepository.openDoors, sizeX, sizeY);
    } else {
      sprite = spritesRepository.resize(spritesRepository.closedDoors, sizeX, sizeY);
    }
    
    image(sprite, x, y);
  }

  @Override
    void update() {
    if (key == ' ') {
      if (!isSpacePressed)
        changeStatus(); 
      isSpacePressed = true;
    } else {
      isSpacePressed = false;
    }
  }

  void changeStatus() {
    Coordinate playerPos = game.getPlayerPosition();
    float dist = Coordinate.getDistance(playerPos, position);
    if (dist == 1) {
      file.play();
      isOpen = !isOpen;
    }
  } 

  @Override 
    boolean isWalkable() {
    if (isOpen) return true;
    return false;
  }
  
  @Override 
  boolean isDangerous() {
   return false; 
  }
  
  @Override 
  String getSerializationString() {
    return "d";
  }
}
