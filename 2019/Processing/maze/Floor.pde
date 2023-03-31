class Floor extends GameObject {
 Floor(Coordinate pos) {
  super(pos); 
 }
  
  @Override 
  boolean isWalkable() {
    return true;
  }
  
  @Override
  void display(int x, int y, int sizeX, int sizeY) {
    fill(210); //<>//
    rect(x, y, sizeX, sizeY);
  } 
  
  @Override 
  boolean isDangerous() {
   return false; 
  }
  
  @Override 
  String getSerializationString() {
    return ".";
  }
}
