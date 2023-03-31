final int RECT_COUNT = 4;
int rectHeight;
int rectWidth;
LineSpawner spawner;

void setup() {
  size(300, 550);

  rectHeight = (int) height / RECT_COUNT;
  rectWidth = (int) width / RECT_COUNT;

  spawner = new LineSpawner(RECT_COUNT + 1, 0, 0, rectWidth, rectHeight);
}

void mouseClicked() {
  if (spawner.lost) {
    setup();
    loop();
  } else {
    spawner.clicked(mouseX, mouseY);
  }
}

void draw() {
  background(255);
  spawner.update();
  spawner.display();
  if (spawner.lost) noLoop();
}
