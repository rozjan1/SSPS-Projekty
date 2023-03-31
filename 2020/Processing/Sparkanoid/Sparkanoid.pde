Ball ball;
Platform platform;
Wall[] walls;
int lives = 5;

ArrayList<Brick> bricks;

void setup() {
  size(640, 640);
  platform = new Platform(new PVector(width / 2, height * (6.0/7)), new PVector(150, 20), 4);
  ball = new Ball(new PVector(width/2, height / 2), new PVector(5, -5));

  createBricks();

  PVector topLeft = new PVector(0, 0);
  PVector bottomLeft = new PVector(0, height);
  PVector topRight = new PVector(width, 0);
  PVector bottomRight = new PVector(width, height);

  walls = new Wall[] {
    new Wall(topLeft.copy().add(-15, 0), bottomLeft), 
    new Wall(topLeft.copy().add(0, -15), topRight), 
    new Wall(topRight, bottomRight.copy().add(15, 0)) 
    // new Wall(bottomLeft, bottomRight.copy().add(0, 15)) // Safety net
  };

  for (Brick brick : bricks) {
    ball.addCollision(brick);
  }
  ball.addCollision(platform);
  collideBallWithWalls();
}

void draw() {
  background(255);
  for (int i = bricks.size() - 1; i >= 0; i--) {
    Brick brick = bricks.get(i);
    // Remove dead bricks
    if (brick.isAlive == false) {
      bricks.remove(brick);
    }
    if (bricks.size() == 0) {
    victory();
    }
    brick.update();
    brick.display();
  }

  platform.update();

  ball.update();
  if (ball.isDead()) {
    lives--;
    ball.position.x = width / 2;
    ball.position.y = width / 2;
  }
  if (lives <= 0) {
    noLoop();
  }
  text("Lives: " + lives, 10, 10);

  platform.display();
  ball.display();
}

void createBricks() {
  bricks = new ArrayList<Brick>();
  int brickWidth = 50;
  int spaceWidth = 10;
  int brickHeight = 20;
  int spaceHeight = 15;
  int topSeparation = 40;

  for (int i = spaceWidth + brickWidth / 2; i + brickWidth < width - spaceWidth; i = i + (spaceWidth + brickWidth)) {
    for (int j = 0; j < 3; j++)
      bricks.add(new Brick(new PVector(i, topSeparation + j*(brickHeight + spaceHeight)), new PVector(brickWidth, brickHeight)));
  }
}

void drawRect(PVector topLeft, PVector bottomRight) {
  fill(100);
  line(topLeft.x, topLeft.y, bottomRight.x, topLeft.y);
  line(topLeft.x, topLeft.y, topLeft.x, bottomRight.y);
  line(topLeft.x, bottomRight.y, bottomRight.x, bottomRight.y);
  line(bottomRight.x, topLeft.y, bottomRight.x, bottomRight.y);
}

void collideBallWithWalls() {

  for (Wall wall : walls) {
    ball.addCollision(wall);
  }
}

void victory() {
  textSize(16);
  text("Gratuluju, vyhral jsi!", (width / 2) - 60, height / 2);
  noLoop();
}

void mousePressed() {
}
