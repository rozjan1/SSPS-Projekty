public class Grid {
    public Cell[][] cells;

    public Grid(int size) {
        cells = new Cell[size][size];
        for (int i = 0; i < cells.length; i++) {
            for (int j = 0; j < cells[i].length; j++) {
                boolean shouldBeWall = i == 0 || i == cells.length - 1 || j == 0 || j == cells[i].length - 1;
                cells[i][j] = new Cell(i, j, shouldBeWall ? CellType.Wall : CellType.Normal);
            }
        }
    }


    public int getSize() {
        return cells.length;
    }

    public static double distanceBetween(int x1, int y1, int x2, int y2) {
        return Math.abs(x1 - x2) + Math.abs(y1 - y2);
    }
}
