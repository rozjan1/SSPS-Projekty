class Game {
  Cell[][] map = new Cell[MAP_SIZE][MAP_SIZE];
  int score = 0;
  boolean isRunning = true;

  Game() {
    newGame();
  }

  Game(Cell[][] map, int score) {
    this.map = new Cell[MAP_SIZE][MAP_SIZE];
    
    for (int i = 0; i < map.length; i++) 
      for (int j = 0 ; j < map[i].length; j++)
        this.map[i][j] = map[i][j].copy();
    
    this.score = score;
  }

  void newGame() {
    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[i].length; j++) {
        map[i][j] = new Cell();
      }
    }

    map[3][3].type = CellType.HEAD;
    map[3][3].direction = Direction.RIGHT;
    map[2][3].type = CellType.BODY;
    map[2][3].direction = Direction.RIGHT;

    score = 0;
    spawnNewFruit();
  }


  void doMove(Direction move) {
    PVector head = getHead();
    PVector targetPosition = moveInDirection(move, head);

    if (isValid(move, targetPosition, head) == false) {
      isRunning = false;
      return;
    }

    PVector tail = getTail();
    boolean fruit = fruit(move);
    if (fruit) {
      score += 1;
    } 

    makeMove(fruit, move, tail, head, targetPosition);
  }

  void makeMove(boolean fruit, Direction dir, PVector tail, PVector head, PVector targetPosition) {
    if (!fruit) {
      getCell(tail).type = CellType.EMPTY;
    }

    getCell(head).type = CellType.BODY;
    Cell cell = getCell(targetPosition);
    cell.type = CellType.HEAD;
    cell.direction = dir;

    if (fruit) 
      spawnNewFruit();
  }

  boolean isValid(Direction direction, PVector willMoveTo, PVector head) {
    if (!(willMoveTo.x > -1 && willMoveTo.x < map.length && willMoveTo.y > -1 && willMoveTo.y < map.length)) 
      return false;
    Direction previousDirection = getCell(head).direction;
    if (direction == previousDirection.getOpposite()) return false;

    if (getCell(willMoveTo).type == CellType.BODY || getCell(willMoveTo).type == CellType.HEAD) return false;

    return true;
  } 

  boolean fruit(Direction move) {
    PVector head = getHead();
    PVector isFruit = moveInDirection(move, head);
    if (getCell(isFruit).type == CellType.FOOD) {
      return true;
    }
    return false;
  }

  PVector getHead() {
    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[i].length; j++) {
        if (map[i][j].type == CellType.HEAD) {
          return new PVector(i, j);
        }
      }
    }
    return new PVector(0, 0);
  }
  
  PVector getFruit() {
    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map[i].length; j++) {
        if (map[i][j].type == CellType.FOOD) {
          return new PVector(i, j);
        }
      }
    }
    return new PVector(0, 0);
  }

  PVector getTail() {
    PVector current = getHead();
    PVector last;


    do {
      Direction direction = getCell(current).direction;
      last = current;
      current = moveInOppositeDirection(direction, current);
    } while (getCell(current).type == CellType.BODY);

    return last;
  }

  void spawnNewFruit() {
    int totalCells = map.length * map.length;

    int emptyCellCount = totalCells - (2 + score);
    int cellIndex = int(random(0, emptyCellCount));

    for (int i = 0; i < map.length; i++) {
      for (int j = 0; j < map.length; j++) {
        if (map[i][j].type == CellType.EMPTY) {
          cellIndex--;
          if (cellIndex <= 0) {
            map[i][j].type = CellType.FOOD;
            return;
          }
        }
      }
    }

    println("ERROR");
  }

  PVector getDirectionVector(Direction dir) {
    if (dir == Direction.UP) return new PVector(0, -1);
    if (dir == Direction.DOWN) return new PVector(0, 1);
    if (dir == Direction.LEFT) return new PVector(-1, 0);
    if (dir == Direction.RIGHT) return new PVector(1, 0);
    return new PVector(0, 0);
  }

  PVector moveInOppositeDirection(Direction dir, PVector current) {
    return PVector.sub(current, getDirectionVector(dir));
  }

  PVector moveInDirection(Direction dir, PVector current) {
    return PVector.add(current, getDirectionVector(dir));
  }


  Cell getCell(PVector coor) {
    return map[(int)coor.x][(int)coor.y];
  }
}
