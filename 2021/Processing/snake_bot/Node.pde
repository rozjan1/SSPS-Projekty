class Node implements Comparable<Node> {
  Node lastNode;
  Cell[][] map;
  Direction cameFrom;
  
  Node(Node lastNode, Cell[][] map, Direction cameFrom) {
    this.lastNode = lastNode;
    this.map = map;
    this.cameFrom = cameFrom;
    
  }
  
  int getHeuristic() {
    Game game = new Game(this.map, 0);
    
    PVector head = game.getHead();
    PVector fruit = game.getFruit();
    
    return int(abs(head.x - fruit.x) + (abs(head.y - fruit.y)));
  }
  
  @Override
  public int compareTo(Node other) {
    return Integer.compare(getHeuristic(), other.getHeuristic());
  }

}
