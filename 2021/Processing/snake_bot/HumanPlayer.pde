class HumanPlayer extends Player {

  Direction lastDir = Direction.DOWN;
  
  
  Direction getdir(Game game) {
  
   
   if (key == 'w') 
      lastDir = Direction.UP;
    else if (key == 's') 
      lastDir = Direction.DOWN;
    else if (key == 'd') 
      lastDir = Direction.RIGHT;
      else if (key == 'a') 
      lastDir = Direction.LEFT;
      
    return lastDir;
  }
}
