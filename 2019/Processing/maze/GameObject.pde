abstract class GameObject {
  Coordinate position;

  GameObject(Coordinate pos) {
    this.position = pos.copy();
  }

  abstract void display(int x, int y, int sizeX, int sizeY);

  void update() {
  }

  abstract boolean isWalkable();

  abstract boolean isDangerous();
  
  abstract String getSerializationString();
}
