class Wall extends GameObject {
  Wall(Coordinate pos) {
    super(pos);
  }

  void display(int x, int y, int sizeX, int sizeY) {

    // vybereme, ktery wall sprite pouzit

    int number = getNeighboursBinary();

    PImage sprite = spritesRepository.resize(spritesRepository.wall[number], sizeX, sizeY);

    image(sprite, x, y);
  }

  boolean isNeighborThere(int offsetX, int offsetY) {
    Coordinate neighbor = Coordinate.add(position, new Coordinate(offsetX, offsetY));
    return game.map.isValid(neighbor) && game.map.get(neighbor) instanceof Wall;
  }

  int getNeighboursBinary() {
    int above = isNeighborThere(0, -1) ? 1 : 0;
    int left = isNeighborThere(-1, 0) ? 1 : 0;
    int right = isNeighborThere(1, 0) ? 1 : 0;
    int below = isNeighborThere(0, 1) ? 1 : 0;

    return  left +  right * 2 +  above * 4 + below * 8;
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
    return "#"; 
  }
}
