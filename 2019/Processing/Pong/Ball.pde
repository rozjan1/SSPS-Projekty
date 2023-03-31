class Ball { //<>//
  int x, y;
  int velX, velY;


  Ball(int x, int y, int velX, int velY) {
    this.x = x;
    this.y = y;
    this.velX = velX;
    this.velY = velY;
  }

  void display() {
    ellipse(x, y, 5, 5);
  }

  boolean intersectsPaddle(Paddle paddle) {
    // A = Ball
    int a1 = x;
    int a2 = y;

    // B = Paddle
    int b1 = paddle.x;
    int b2 = paddle.y;

    // u = Paddle length
    int u1 = 0;
    int u2 = paddle.size;

    // v = Ball trajectory
    int v1 = velX;
    int v2 = velY;

    double q = (a2*v1 + b1*v2 - a1*v2 - b2*v1) / (double) (u2*v1 - u1*v2);
    double p = (b1 + u1*q - a1) / (double) v1;

    return q >= 0 && q <= 1 && p >= 0 && p <= 1;
  }

  void update(Paddle left, Paddle right) {
    if (intersectsPaddle(left)) {
      // Narazili jsme na leve padlo!
      if (x + velX <= left.x) {
        x = left.x - (velX - (left.x - x));
        velX = -velX;
      } else {
        x += velX;
      }
    } else if (intersectsPaddle(right)) {
      // Narazili jsme na prave padlo!
      if (x + velX >= right.x) {
        x = right.x - (velX - (right.x - x));
        velX = -velX;
      } else {
        x += velX;
      }
    } else {
      x += velX;
    }

    if (y + velY <= 0) { 
      y = 0 - (velY - (0 - y));
      velY = -velY;
    } else if (y + velY >= height) {
      y = height - (velY - (height - y)); 
      velY = -velY;
    } else {
      y += velY;
    }

    if (x < 0 || x > width) reset();
  }
  void reset() {
    x = width / 2;
    y = height / 2;
  }
}
