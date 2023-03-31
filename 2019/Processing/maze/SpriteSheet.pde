class SpriteSheet {
  final String path;
  PImage sheet;
  final int sWidth, sHeight;
  final int countX, countY;
  final PImage[][] sprites;

  SpriteSheet(String path, int spriteWidth, int spriteHeight) {
    this.path = path;
    sWidth = spriteWidth;
    sHeight = spriteHeight;
    sheet = loadImage(path);

    countX = sheet.width / spriteWidth; 
    countY = sheet.height / spriteHeight;
    sprites = new PImage[countX][countY];

    populateSprites();
  }

  void populateSprites() {
    for (int i = 0; i < countX; i++) {
      for (int j = 0; j < countY; j++) {
        sprites[i][j] = sheet.get(i * sWidth, j * sHeight, sWidth, sHeight);
      }
    }
  }

  PImage get(int x, int y) {
    return sprites[x][y];
  }
}
