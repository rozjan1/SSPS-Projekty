class RectangleLine { //<>//
  long createdTime;
  int rectSize;
  int lineHeight;
  int x; 
  float y;
  Rectangle[] rectangles = new Rectangle[4];

  RectangleLine(int x, int y, int rectSize, int lineHeight) {
    this.x = x;
    this.y = y;
    this.lineHeight= lineHeight;
    createdTime = millis();

    for (int i = 0; i < 4; i++) {
      rectangles[i] = new Rectangle(rectSize, lineHeight);
    }

    randomizeColors();

    this.rectSize = rectSize;
  }

  void randomizeColors() {
    int howMany;

    // 0 - 20%
    // 1 - 50% 
    // 2 - 30%
    double rand = random(1); // 0-1
    if (rand < 0.2) howMany = 0;
    else if (rand < 0.7) howMany = 1;
    else howMany = 2;

    for (int i = rectangles.length - 1; i >= 0; i--) {
      Rectangle r = rectangles[i];
      if (howMany > 0 && (howMany == i + 1 || (int) random(0, 4) == 0)) {
        r.isWhite = false; 
        howMany--;
      } else {
        r.isWhite = true;
      }
    }
  }

  void resetLine() {
    for (Rectangle r : rectangles) {
      r.wasClicked = false;
    }
    randomizeColors();
  }

  void movement() {
    long m = millis() - createdTime;
    y -= 1 + m / 10000;
  }

  void update() {
    movement();

    for (int i = 0; i<4; i++) {
      rectangles[i].update();
    }
  }

  boolean checkClicked() {
    for (Rectangle r : rectangles) {
      if (r.didLose()) {
        return false;
      }
    }
    return true;
  }

  boolean clicked(int x, int y) {
    if (this.x > x || this.y > y) return true;
    if (this.x + (rectSize * 4) < x || this.y + lineHeight < y) return true;
    int innerX = x - this.x;
    int squareIndex = innerX / rectSize;
    // Vime do ktereho obdelniku jsme klikli
    return rectangles[squareIndex].clicked();
  }

  void display() {
    for (int i = 0; i < 4; i++) {
      rectangles[i].display((i * rectSize) + x, y);
    }
  }
}
