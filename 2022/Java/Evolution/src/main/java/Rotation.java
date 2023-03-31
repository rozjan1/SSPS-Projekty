public enum Rotation {
    East, North, West, South;

    public int getFacingX() {
        if (this == East)
            return 1;
        if (this == West)
            return -1;
        return 0;
    }

    public int getFacingY() {
        if (this == North)
            return 1;
        if (this == South)
            return -1;
        return 0;
    }

    public Rotation getLeft() {
        switch(this)  {
            case North: return West;
            case East: return North;
            case South: return East;
            case West: return South;
        }
        return null;
    }

    public Rotation getRight() {
        switch(this)  {
            case North: return East;
            case East: return South;
            case South: return West;
            case West: return North;
        }
        return null;
    }
}
