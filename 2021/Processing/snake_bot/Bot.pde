import java.util.PriorityQueue; //<>//

class Bot extends Player {
  Direction getdir(Game game) {
    println("Calculating");
    Node root = new Node(null, game.map, Direction.UP);
    PriorityQueue<Node> queue = new PriorityQueue<Node>();
    queue.add(root);

    Node curr = null;
    while (!queue.isEmpty()) {
      curr = queue.poll();
      for (int direction = 0; direction < 4; direction++) {
        Game myGame = new Game(curr.map, 0);
        Direction currDirection = Direction.getFromNumber(direction);
        myGame.doMove(currDirection);


        if (!myGame.isRunning)
          continue;
        // We ate food
        if (myGame.score > 0) {
          // Backtrack to the first direction used
          Node backtrackingNode = curr;
          Direction lastDirection = currDirection;
          while (backtrackingNode.lastNode != null) {
            lastDirection = backtrackingNode.cameFrom;
            backtrackingNode = backtrackingNode.lastNode;
          }
          return lastDirection;
        }

        Node node = new Node(curr, myGame.map, currDirection);
        queue.add(node);
      }
    }

    println("ERROR! NO DIRECTIONS LEFT!!");
    // Backtrack to the first direction used
    Node backtrackingNode = curr;
    Direction lastDirection = curr.cameFrom;
    while (backtrackingNode.lastNode != null) {
      lastDirection = backtrackingNode.cameFrom;
      backtrackingNode = backtrackingNode.lastNode;
    }
    return lastDirection;
  }
}
