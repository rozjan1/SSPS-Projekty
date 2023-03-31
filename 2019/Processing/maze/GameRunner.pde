class GameRunner {
  final int uiHeight = 20;
  Coordinate viewPortPosition = new Coordinate(0, 0);
  
  void restart() {
    String error = loadMap("map.txt");
    if (error != null) {
      println("Map file loading failed: " + error);
      noLoop();
      exit();
    }
  }

  void updateViewPortPosition() {
    viewPortPosition = game.player.position.copy();
  }

  void update() {
    updateViewPortPosition();
    game.update();
  }
  
  void movePlayer(Direction dir) {
    if (game.player == null) return;
    game.player.move(dir);
  }

  void onKey() {
    if (keyCode == UP) movePlayer(Direction.N);
    if (keyCode == LEFT) movePlayer(Direction.W);
    if (keyCode == DOWN) movePlayer(Direction.S);
    if (keyCode == RIGHT) movePlayer(Direction.E);
  }

  void onMouse() {
  }

  void display() {
    runner.update(); //<>//
    game.display(0, uiHeight, viewPortPosition);

    text("Player lives: " + game.player.lives, 10, 10);
  }
}
