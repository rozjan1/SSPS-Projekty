class Platform implements Collider {
  PVector position;
  int speed;
  PVector size;

  Platform(PVector position, PVector size, int speed) {
    this.position = position.copy();
    this.size = size.copy();
    this.speed = speed;
  }

  PVector getTopLeft() {
    return PVector.sub(position, size.copy().mult(0.5));
  }

  PVector getBottomRight() {
    return PVector.add(position, size.copy().mult(0.5));
  }

  void display() {
    fill(10);
    PVector topLeft = getTopLeft();
    rect(topLeft.x, topLeft.y, size.x, size.y);

    noFill();
  }

  void update() {
    if (keyPressed) {
      if (keyCode == LEFT) {
        position.x -= speed;
        PVector lcorner = getTopLeft();
        if (lcorner.x < 0) position.x = size.x / 2;
      }
      if (keyCode == RIGHT) {
        position.x += speed;
        PVector corner = getBottomRight();
        if (corner.x > width) position.x = width - (size.x / 2);
      }
    }
  }
  
  void onCollision() {
  }
}
