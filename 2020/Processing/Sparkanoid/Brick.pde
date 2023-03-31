class Brick implements Collider {
  PVector position, size;
  boolean isAlive = true;
  Brick(PVector position, PVector size) {
    this.position = position.copy();
    this.size = size.copy();
  }
  
  PVector getTopLeft() {
    return PVector.sub(position, size.copy().mult(0.5));
  }

  PVector getBottomRight() {
    return PVector.add(position, size.copy().mult(0.5));
  }

  void display() {
    if (!isAlive) return;
    fill(0);
    PVector topLeft = getTopLeft();
    rect(topLeft.x, topLeft.y, size.x, size.y);
    noFill();
  }

  void onCollision() {
    popBrick();
  }

  void update() {
  }

  void popBrick() {
    ball.removeCollision(this);
    isAlive = false;
  }
}
