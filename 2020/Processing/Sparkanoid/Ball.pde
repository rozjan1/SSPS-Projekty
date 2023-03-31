import java.security.*; //<>//

class Ball {
  PVector position;
  PVector velocity;
  ArrayList<Collider> colliders;

  Ball(PVector position, PVector velocity) {
    this.position = position.copy();
    this.velocity = velocity.copy();
    colliders = new ArrayList<Collider>();
  }

  PVector getCollisionPoint(PVector start, PVector delta, PVector corner1, PVector corner2) {
    corner1 = corner1.copy();
    corner2 = corner2.copy();

    if (corner2.x < corner1.x) {
      if (corner2.y < corner1.y) {
        PVector tmp = corner2;
        corner2 = corner1;
        corner1 = tmp;
      } else {
        PVector newc1 = new PVector(corner1.y, corner2.x);
        corner2 = new PVector(corner1.x, corner2.y);
        corner1 = newc1;
      }
    } else { 
      if (corner2.y < corner1.y) {
        PVector newc1 = new PVector(corner1.x, corner2.y);
        corner2 = new PVector(corner2.x, corner1.y);
        corner1 = newc1;
      } else {
        // They were right in the first place
      }
    } 

    if (corner1.x == corner2.x) throw new InvalidParameterException("X were equal");
    if (corner1.y == corner2.y) throw new InvalidParameterException("Y were equal");

    float[] p = new float[] {-delta.x, delta.x, -delta.y, delta.y};
    float[] q = new float[] {start.x - corner1.x, corner2.x - start.x, start.y - corner1.y, corner2.y - start.y};

    float u1 = -MAX_FLOAT;
    float u2 = MAX_FLOAT;

    for (int i = 0; i < 4; ++i) {
      if (p[i] == 0) {
        if (q[i] < 0)
          return null;
      } else {
        float t = q[i] / p[i];
        if (p[i] < 0 && u1 < t) {
          u1 = t;
        } else if (p[i] > 0 && u2 > t) { 
          u2 = t;
        }
      }
    }

    if (u1 > u2 || u1 > 1 || u1 < 0) return null;

    PVector colPoint = new PVector(start.x + u1 * delta.x, start.y + u1 * delta.y); 

    if (colPoint.x == corner1.x || colPoint.x == corner2.x) colPoint.z = 2;
    else colPoint.z = 1;

    return colPoint;
  }

  void display() {
    displayAt(position, false);
  }

  void displayAt(PVector where, boolean debug) {
    if (debug)
      fill(0, 0, 255);
    else
      fill(0);
    circle(where.x, where.y, 5);

    noFill();
  }

  void addCollision(Collider object) {
    colliders.add(object);
  }

  void removeCollision(Collider object) {
    colliders.remove(object);
  }

  void updatePosition(boolean isDebug) {
    if (isDebug) {
      line(position.x, position.y, position.x + velocity.x, position.y + velocity.y);
      displayAt(PVector.add(position, velocity), true);
      displayAt(position, true);
    }

    float movementLeft = velocity.mag();
    if (movementLeft == 0) return;
    PVector velLeft = velocity.copy();
    PVector newPos = position.copy();
    PVector newVelocity = velocity.copy();

    while (movementLeft > 0.001) {
      PVector closestColPoint = PVector.add(newPos, velLeft);
      float closestColPointDist = PVector.dist(closestColPoint, newPos);
      int minIndex = -1;

      for (int i = 0; i < colliders.size(); i++) {
        PVector colPoint = getCollisionPoint(newPos, velLeft, colliders.get(i).getTopLeft(), colliders.get(i).getBottomRight()); 
        if (colPoint == null) continue;

        float dist = PVector.dist(colPoint, newPos);
        if (dist < closestColPointDist) {
          closestColPoint =colPoint;
          closestColPointDist = dist;
          minIndex = i;
        }
      }

      if (isDebug) {
        stroke(255, 0, 0);
        ellipse(closestColPoint.x, closestColPoint.y, 10, 10);
        displayAt(closestColPoint, true);
        stroke(255, 0, 0);
        line(newPos.x, newPos.y, closestColPoint.x, closestColPoint.y);
        stroke(0);
      }

      // Move to collision point
      copyVectorTo(closestColPoint, newPos);

      movementLeft -= closestColPointDist;
      velLeft.setMag(movementLeft);

      //flip velocity
      if (minIndex != -1) {

        if (closestColPoint.z == 1) {
          velLeft.y = -velLeft.y;
          newVelocity.y = -newVelocity.y;
        } else if (closestColPoint.z == 2) {

          velLeft.x = -velLeft.x;
          newVelocity.x = -newVelocity.x;
        }

        colliders.get(minIndex).onCollision();
      }
    }

    copyVectorTo(newPos, position);

    velocity = newVelocity;
  }
  
  void copyVectorTo(PVector from, PVector to) {
    to.x = round(from.x);
    to.y = round(from.y);
    to.z = 0;
  }
  
  boolean isDead() {
    
  if (position.y > height) return true;
  return false;
  }
  
  void update() {
    updatePosition(false);
  }
}
