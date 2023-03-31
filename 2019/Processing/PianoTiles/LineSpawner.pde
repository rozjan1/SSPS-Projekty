class LineSpawner {
  final int scoreSize = 200;
  int lineCount;
  int topPosition;
  int x, y;
  int rectWidth, rectHeight;
  RectangleLine[] lines;
  int score = 0;
  boolean lost = false;

  LineSpawner(int lineCount, int x, int y, int rectWidth, int rectHeight) {
    this.lineCount= lineCount;
    this.rectWidth = rectWidth;
    this.rectHeight = rectHeight;
    this.x = x; 
    this.y = y;
    spawn();
  }

  void spawn() {
    lines = new RectangleLine[lineCount];
    for (int i = 0; i < lineCount; i++) {
      lines[i] = new RectangleLine(x, y + (i * rectHeight) + (height / 2), rectWidth, rectHeight);
    }
  }

  void update() {
    if (lost) {
      noLoop();
    }

    for (RectangleLine line : lines) {
      line.update();
    }

    RectangleLine topLine = lines[topPosition];
    if (topLine.y + topLine.lineHeight < 0) {
      int which = topPosition - 1;
      if (which < 0) {
        which += lineCount;
      }

      RectangleLine bottomLine = lines[which];
      topLine.y = bottomLine.y + bottomLine.lineHeight;
      if (!topLine.checkClicked()) {
        lose();
      } else {
        score++;
      }
      topLine.resetLine();
      topPosition++;
      if (topPosition >= lineCount) topPosition = 0;
    }
  }

  void clicked(int x, int y) {
    for (RectangleLine line : lines) {
      if (!line.clicked(x, y)) {
        lose();
      }
    }
  }

  void displayScore() {
    fill(0, 128, 0, 200);
    ellipse(width / 2, height / 2, scoreSize, scoreSize);
    noFill();
    fill(0, 0, 0);
    textSize(15);
    text("YOU LOST, SCORE: " + score, width / 2 - (scoreSize / 2) + 15, height / 2 - 10);
  }

  void lose() {
    println("YOU LOST, SCORE: " + score);
    lost = true;
    displayScore();
  }

  void display() {
    for (RectangleLine line : lines) {
      line.display();
    }

    if (lost) {
      displayScore();
    }
  }
}
