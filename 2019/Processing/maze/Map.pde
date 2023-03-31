class Map {
  MapPosition[][] map;

  final int MAP_WIDTH, MAP_HEIGHT;
  
  Map(int sizeX, int sizeY) {
    MAP_WIDTH = sizeX;
    MAP_HEIGHT = sizeY;
    map = new MapPosition[sizeX][sizeY];

    for (int i = 0; i < sizeX; i++) {
      for (int j = 0; j < sizeY; j++) {
        map[i][j] = new MapPosition(i, j);
      }
    }
  }

  GameObject get(Coordinate pos) {
    if (!isValid(pos)) {
      println("Map::get: " + pos + " is not valid position on the map!");
      return null;
    }

    return map[pos.x][pos.y].get();
  }

  GameObject get(Coordinate pos, int index) {
    return map[pos.x][pos.y].get(index);
  }

  void set(Coordinate pos, int index, GameObject object) {
    if (!isValid(pos)) {
      println("Map::set: " + pos + " is not valid position on the map!");
      return;
    }

    map[pos.x][pos.y].set(object, index);
  }

  void add(Coordinate pos, GameObject object) {
    map[pos.x][pos.y].add(object);
  }

  void move(GameObject what, Coordinate from, Coordinate where) {
    if (!map[from.x][from.y].popObject(what)) {
      println("Object is not at position");
      exit();
    }
    map[where.x][where.y].add(what);
    what.position = where.copy();
  }

  boolean isValid(Coordinate pos) {
    return pos.x >= 0 && pos.x < MAP_WIDTH && pos.y >= 0 && pos.y < MAP_HEIGHT;
  }

  void display(Coordinate pos, int x, int y, int sizeX, int sizeY) {
    map[pos.x][pos.y].display(x, y, sizeX, sizeY); //<>//
  }

  void saveMap(String path) {
    String[] lines = new String[MAP_HEIGHT + 2];
    lines[0] = "" + MAP_WIDTH;
    lines[1] = "" + MAP_HEIGHT;

    for (int i = 0; i <MAP_HEIGHT; i++) {
      String line = "";
      for (int j = 0; j < MAP_WIDTH; j++) {
        GameObject objAtPos = get(new Coordinate(j, i));
        if (objAtPos == null) 
          line += '_';
        else 
          line += objAtPos.getSerializationString();
      }

      lines[i+2] = line;
    }

    saveStrings(path, lines);
  }

  void removeObject(Coordinate where) {
    if (!isValid(where)) return;
    map[where.x][where.y].popObject();
  }
}
