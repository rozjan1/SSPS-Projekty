Player bot;
Game game;
boolean isHuman;

static final int MAP_SIZE = 15;

void setup() {
  size(640, 640);
  game = new Game();
  bot = new Bot();
  isHuman = false;
  frameRate(15); // neni potreba, jenom se na to lepe diva, doporucuji podivat se na to jednou bez a jednou s :D
}

void draw() {
  background(255);
  drawMap();
  print_score();
  gamestep();
}


void gamestep() {
  if (!game.isRunning) {
    textSize(60);
    textAlign(CENTER);
    text("Game finished", width / 2, height / 2);
 
    noLoop();
  }
  
  Direction move = bot.getdir(game);
  println(move);
  game.doMove(move);
}

void drawMap() {

  float square_size = (float) width / game.map.length;
  
  int how_many = game.map.length;
  for (int square_x = 0; square_x < how_many; square_x ++) { 
    for (int square_y = 0; square_y < how_many; square_y++) { 
      PVector cell_at = new PVector(square_x, square_y);
      if (game.getCell(cell_at).type == CellType.FOOD) {
        fill(230, 130, 30);
      } else if (game.getCell(cell_at).type == CellType.BODY) {
        fill(107, 142, 35);
      } else if (game.getCell(cell_at).type == CellType.HEAD) {
        fill(100, 174, 0);
      }        
      rect(square_x * square_size, square_y * square_size, square_size, square_size); // Draw squares for every cell of map
      noFill();
    }
  }
}

void print_score() {
    textSize(20);
    fill(0, 0, 0);
    text(game.score, 30, 30);
    text("isHuman: " + isHuman, 30, 60);
    noFill();
  }
  
void changePlayer() {
  if (isHuman) {
    bot = new HumanPlayer();
  } else {
    bot = new Bot();
  }
}
  
void keyPressed() {
  if (key==' ') {
    isHuman = !isHuman;
    changePlayer();
  }
  gamestep();
}
