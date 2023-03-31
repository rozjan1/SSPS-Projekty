class SpritesRepository {
  final SpriteSheet doors, walls;

  final PImage openDoors;
  final PImage closedDoors;
  final PImage[] wall;

  SpritesRepository() {
    doors = new SpriteSheet("sprites/doors.png", 96, 96);
    openDoors = doors.get(2, 3);
    closedDoors = doors.get(2, 0);

    walls = new SpriteSheet("sprites/Wall.jpg", 32, 32);

    wall = getWalls();
  }

  PImage[] getWalls() {
    PImage[] images = new PImage[16];
    images[0] = walls.get(0, 0); // -
    images[1] = walls.get(5, 1); // L
    images[2] = walls.get(7, 1); // R
    images[3] = walls.get(1, 2); // LR
    images[4] = walls.get(4, 2); // U
    images[5] = walls.get(2, 4); // UL
    images[6] = walls.get(0, 4); // UR
    images[7] = walls.get(6, 4); // URL
    images[8] = walls.get(4, 0); // D
    images[9] = walls.get(2, 2); // DL
    images[10] = walls.get(0, 2); // DR
    images[11] = walls.get(6, 6); // DRL
    images[12] = walls.get(0, 3); // DU
    images[13] = walls.get(8, 1); // DUL
    images[14] = walls.get(4, 1); // DUR
    images[15] = walls.get(11, 1); // DURL

    return images;
  }


  PImage resize(PImage sprite, int sizeX, int sizeY) {
    sprite = sprite.get();
    if (sprite.width >= sprite.height) {
      
      sprite.resize(sizeX, 0);
    } else {
      sprite.resize(0, sizeY);
    }
    return sprite;
  }
}
