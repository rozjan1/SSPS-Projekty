class Rectangle {
  boolean isWhite;
  int rectWidth;
  int rectHeight;
  boolean wasClicked;

  boolean losing = false;

  Rectangle(int rectWidth, int rectHeight) {
    this.rectHeight = rectHeight;
    this.rectWidth = rectWidth;
  }

  void update() {
  }

  void display(float x, float y) {
    strokeWeight(2);
    stroke(211, 211, 211);
    if (isWhite) fill(255);
    else { 
      if (wasClicked) {
        // r g b a
        fill(11, 11, 11, 100);
      } else {
        fill(0);
      }
    }

    if (losing) fill(255, 0, 0);

    rect(x, y, rectWidth, rectHeight);
    noFill();
  }

  boolean clicked() {
    wasClicked = true;
    if (isWhite) {
      losing = true;
      return false;
    }
    return true;
  }

  boolean didLose() {
    if (!isWhite && !wasClicked) {
      return true;
    }

    return false;
  }
}
