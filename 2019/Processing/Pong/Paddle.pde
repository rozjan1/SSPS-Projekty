class Paddle {
  int x, y;
  final int speed = 3;
  int size;
  int keyUp, keyDown;

  Paddle(int x, int y, int size, int keyUp, int keyDown) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.keyUp = keyUp;
    this.keyDown = keyDown;
  }
  
  void update() {
    if (keyCode == keyUp) y -= speed;
    if (keyCode == keyDown) y += speed;
    if (y <= 0) y = 0;
    if (y >= height - size) y = height - size;
  }
  
  void display() {
    fill(0);
    rect(x, y, 10, size);
    noFill();
  }
}
