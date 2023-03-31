class MapCreator extends GameRunner {
  final int uiHeight = 100; 

  Class objectInHand = Wall.class;

  @Override
    void restart() {

    String mapWidthInput = javax.swing.JOptionPane.showInputDialog(frame, "Width of the map: ", "100");
    if (mapWidthInput == null) exit();
    int mapWidth = max(Integer.parseInt(mapWidthInput), VIEW_SIZE);
    String mapHeightInput = javax.swing.JOptionPane.showInputDialog(frame, "Height of the map: ", "100");
    if (mapHeightInput == null) exit();
    int mapHeight = max(Integer.parseInt(mapHeightInput), VIEW_SIZE);

    game = new Game(mapWidth, mapHeight);

    for (int i = 0; i < mapWidth; i++) {
      for (int j = 0; j < mapHeight; j++) {
        game.placeFloor(new Coordinate(i, j));
      }
    }
  }

  void displayUI() {
    GameObject o;
    if (objectInHand == Player.class) {
      o = new Player(viewPortPosition, 1);
    } else if (objectInHand == Enemy.class) {
      o = new Enemy(viewPortPosition, 1);
    } else if (objectInHand == Door.class) {
      o = new Door(viewPortPosition);
    } else if (objectInHand == Floor.class) {
      o = new Floor(viewPortPosition);
    } else {
      o = new Wall(viewPortPosition);
    }

    o.display(5, 5, 50, 50);
  }

  @Override
    void update() {
  }

  @Override
    void onKey() {
    super.onKey();

    if (key == 'w') viewPortPosition.add(new Coordinate(0, -1));
    if (key == 'a') viewPortPosition.add(new Coordinate(-1, 0));
    if (key == 's') viewPortPosition.add(new Coordinate(0, 1));
    if (key == 'd') viewPortPosition.add(new Coordinate(1, 0));

    if (key == ' ')  cycleObjectInHand();
    if (key == 'p') saveMap();
  }

  @Override
    void onMouse() {
    int x = mouseX;
    int y = mouseY - uiHeight;

    if (x < 0 || y < 0) return;

    Coordinate whereClicked = game.whereClicked(x, y, viewPortPosition);
    if (mouseButton == LEFT)
      placeObjectInHand(whereClicked);
    else if (mouseButton == RIGHT)
      game.removeObject(whereClicked);
  }

  // pridame objekty
  void placeObjectInHand(Coordinate where) {
    if (objectInHand == Wall.class) {
      game.placeWall(where);
    } else if (objectInHand == Player.class) {
      game.placePlayer(where);
    } else if (objectInHand == Enemy.class) {
      game.placeEnemy(where);
    } else if (objectInHand == Door.class) {
      game.placeDoor(where);
    } else if (objectInHand == Floor.class) {
      game.placeFloor(where);
    }
  }

  @Override
    void display() {
    runner.update();
    game.display(0, uiHeight, viewPortPosition);
    displayUI();
  }

  void cycleObjectInHand() {
    if (objectInHand == Wall.class) 
      objectInHand = Player.class;
    else if (objectInHand == Player.class)
      objectInHand = Enemy.class;
    else if (objectInHand == Enemy.class) 
      objectInHand = Door.class;
    else if (objectInHand == Door.class) 
      objectInHand = Floor.class;
    else 
    objectInHand = Wall.class;
  }

  void saveMap() {
    selectInput("Select a file to save map into:", "saveFileSelected");
  }
}
