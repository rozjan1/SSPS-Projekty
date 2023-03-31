class MapPosition {
  ArrayList<GameObject> stack; 
  int x, y;

  MapPosition(int x, int y) {
    stack = new ArrayList<GameObject>(); 
    this.x =x ;
    this.y = y;
  }

  GameObject get() {
    if (stack.isEmpty()) return null;
    return stack.get(stack.size()-1);
  }

  GameObject get(int index) {
    return stack.get(index);
  }

  void add(GameObject obj) {
    stack.add(obj);
  }

  void set(GameObject obj, int index) {
    if (index > stack.size() - 1) {
      println("Trying to set object that is not even in the stack yet");
      exit();
    }

    stack.set(index, obj);
  }

  void display(int x, int y, int sizeX, int sizeY) {
    if (stack.size() == 0) {
      fill(0, 0, 0, 200);
      rect(x, y, sizeX, sizeY);
      return;
    }
    for (GameObject o : stack) {
      o.display(x, y, sizeX, sizeY);
    }
  }

  boolean popObject(GameObject obj) {
    if (get() != obj) return false;

    stack.remove(stack.size() - 1);
    return true;
  }

  boolean popObject() {
    if (stack.size() == 0) return false;

    stack.remove(stack.size() - 1);
    return true;
  }
}
