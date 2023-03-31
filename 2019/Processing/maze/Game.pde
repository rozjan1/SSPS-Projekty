class Game { //<>//
  final int MAP_WIDTH, MAP_HEIGHT;
  final Map map;
  Player player;


  Game(int mapWidth, int mapHeight) {
    MAP_WIDTH = mapWidth;
    MAP_HEIGHT = mapHeight;
    map = new Map(MAP_WIDTH, MAP_HEIGHT);
  }

  Coordinate getPlayerPosition() {
    return player.position.copy();
  }

  boolean playerPlaced() {
    return player != null;
  }

  Player placePlayer(Coordinate pos) {
    if (!map.isValid(pos)) { //<>//
      println("placePlayer: Player is not in map!");
      return null;
    }
    if (playerPlaced()) {
      println("placePlayer: Player is already on the map!");
      return null;
    }

    Coordinate playerPosition = pos.copy();
    println("Placing player at: " + playerPosition);
    player = new Player(playerPosition, 3);
    map.add(playerPosition, player);
    return player;
  }

  boolean isDangerous(Coordinate where) {
    GameObject atPos =  map.get(where);
    if (atPos == null) return false;
    return atPos.isDangerous();
  }

  void placeWall(Coordinate pos) {
    if (!isInMap(pos)) {
      println("placeWall: Wall is not in map!");
      return;
    }

    map.add(pos, new Wall(pos));
  }

  void placeEnemy(Coordinate pos) {
    if (!isInMap(pos)) {
      println("placeEnemy: Enemy is not in map!");
      return;
    }

    map.add(pos, new Enemy(pos, 1000));
  }

  void placeDoor(Coordinate pos) {
    if (!isInMap(pos)) {
      println("placeDoor: Door is not in map!");
      return;
    }

    map.add(pos, new Door(pos));
  }

  boolean isInMap(Coordinate pos) {
    return map.isValid(pos);
  }

  Coordinate getStartOfViewPort(Coordinate viewPortPosition) {
    // This works for odd values, because it floors the value
    int x = min(max((int) viewPortPosition.x - (VIEW_SIZE / 2), 0), MAP_WIDTH - VIEW_SIZE);
    int y = min(max((int) viewPortPosition.y - (VIEW_SIZE / 2), 0), MAP_HEIGHT - VIEW_SIZE);
    return new Coordinate(x, y);
  }

  boolean isFreeToMoveOn(Coordinate pos) {
    if (!isInMap(pos)) return false;
    if (map.get(pos) != null) return false;
    return true;
  }

  void placeFloor(Coordinate pos) {
    map.add(pos, new Floor(pos));
  }

  // x a y jsou top left corner
  void display(int x, int y, Coordinate viewPortPosition) {
    Coordinate viewPortStart = getStartOfViewPort(viewPortPosition);

    for (int i = 0; i < VIEW_SIZE; i++) {
      for (int j = 0; j < VIEW_SIZE; j++) {
        stroke(1);
        strokeWeight(1);
        noFill();
        rect(x + i * cellSize, y + j * cellSize, cellSize, cellSize);
 
        Coordinate currWorldCoord = Coordinate.add(viewPortStart, new Coordinate(i, j));
        map.display(currWorldCoord, x + (i * cellSize), y + (j * cellSize), cellSize, cellSize);

        if (DEBUG) {
          fill(0);
          text(currWorldCoord.x+","+currWorldCoord.y, x + i * cellSize + (cellSize / 4), y + j * cellSize + (cellSize / 2));
        }
      }
    }
  }

  boolean isWalkableAt(Coordinate where) {
    GameObject objectOnCoords = map.get(where);
    if (objectOnCoords == null) return false;
    return objectOnCoords.isWalkable();
  }

  void move(GameObject what, Coordinate from, Coordinate where) {
    map.move(what, from, where);
  }

  Coordinate whereClicked(int x, int y, Coordinate viewPortPosition) {
    Coordinate viewPortStart = getStartOfViewPort(viewPortPosition);
    return Coordinate.add(viewPortStart, new Coordinate(x / cellSize, y / cellSize));
  }

  void update() {
    for (int i = 0; i < MAP_WIDTH; i++) {
      for (int j = 0; j < MAP_HEIGHT; j++) {
        Coordinate currentCoordinate = new Coordinate(i, j);
        GameObject currGO = map.get(currentCoordinate);
        if (currGO != null) {
          currGO.update();
        }
      }
    }
  }
  
  void saveMap(String path) {
   map.saveMap(path); 
  }
  
  void removeObject(Coordinate where) {
   map.removeObject(where); 
  }
}
