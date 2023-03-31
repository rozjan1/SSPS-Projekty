// Ne, neni tu cil :D

import processing.sound.*;

SoundFile file;
String audioName = "closingDoors.wav";

final boolean DEBUG = false;
final boolean MAP_CREATOR = false;

final int VIEW_SIZE = 9;
final int MAX_OBJECTS_STACKED = 10;


Game game;
SpritesRepository spritesRepository;
GameRunner runner;

int cellSize;

void setup() {
  size(640, 660); 

  spritesRepository = new SpritesRepository();

  String path;
  path = sketchPath(audioName);
  file = new SoundFile(this, path);

  runner = MAP_CREATOR ? new MapCreator() : new GameRunner(); 

  runner.restart();
}

void draw() {
  background(255);
  cellSize = width / VIEW_SIZE;

  if (game != null) {
    runner.display();
  }
}


// Nacteme mapu z cesty. Data mapy se nacte do Game reference

String loadMap(String path) {
  String[] lines = loadStrings(path);
  if (lines == null) 
    return "Map file not found!";
  if (lines.length < 2+VIEW_SIZE) 
    return "Map file has too low number of lines!";

  int mapWidth = Integer.parseInt(lines[0]);
  int mapHeight = Integer.parseInt(lines[1]);

  game = new Game(mapWidth, mapHeight);

  for (int y = 0; y < mapHeight; y++) {
    // Prvni 2 lajny preskocime, je tam data o velikosti mapy
    String currLine = lines[y+2];
    for (int x = 0; x < mapWidth; x++) {


      // neni podlaha
      if (currLine.charAt(x) == '_') {
        continue;
      } else {
        game.placeFloor(new Coordinate(x, y));
      }

      if (currLine.charAt(x) == 'x') {
        if (game.playerPlaced()) 
          return "Map file contains multiple players!";
        game.placePlayer(new Coordinate(x, y));
      } else if (currLine.charAt(x) == '#') {
        game.placeWall(new Coordinate(x, y));
      } else if (currLine.charAt(x) == '_') {
      } else if (currLine.charAt(x) == '.') {
        game.placeFloor(new Coordinate(x, y));
      } else if (currLine.charAt(x) == 'e') {
        game.placeEnemy(new Coordinate(x, y));
      } else if (currLine.charAt(x) == 'd') {
        game.placeDoor(new Coordinate(x, y));
      } else 
      return "Map file contained invalid character: " + currLine.charAt(x);
    }
  }

  return null;
}

void keyPressed() {
  runner.onKey();
}

void mousePressed() {
  runner.onMouse();
}

void saveFileSelected(File selection) {
  if (selection == null) 
    return;
  game.saveMap(selection.getAbsolutePath());
}
