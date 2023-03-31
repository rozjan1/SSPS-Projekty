Paddle p, q;
Ball b;
void setup() {
  size(640,240);
  p = new Paddle(10, height / 2, 50, UP, DOWN);
  q = new Paddle(width - 20, height / 2 - 25, 50, LEFT, RIGHT);
  b = new Ball(width - 30, height / 2, 5, -4);
  //frameRate(2);
}

void draw() {
  background(255);
  
  p.update();
  q.update();
  b.update(p, q);
  
  p.display();
  q.display();
  b.display();
}
