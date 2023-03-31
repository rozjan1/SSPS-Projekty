class Wall implements Collider {
 PVector topLeft, bottomRight;
 Wall(PVector topLeft, PVector bottomRight) {
  this.topLeft = topLeft.copy();
  this.bottomRight = bottomRight.copy();
 }
 
 PVector getTopLeft() {
  return topLeft.copy(); 
 }
 
 PVector getBottomRight() {
  return bottomRight.copy(); 
 }
 
 void onCollision() {
  }
}
