class Cell {
  CellType type = CellType.EMPTY;
  Direction direction = Direction.UP;

  Cell copy() {
    Cell cell = new Cell();
    cell.type = type;
    cell.direction = direction;
    return cell;
  }
}
