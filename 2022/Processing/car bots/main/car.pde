class Car {
  PVector pos;
  float wheelDistFromCenter = 12.5;
  float speed;
  float angle;
  float wheelAngle;
  int drawX = 25;
  int drawY = 50;
  boolean didGetToRight = false;
  Brain brain;
  float score = 0;

  final float MAX_SPEED = 5;
  final float MAX_WHEEL_TURN = PI / 4;

  Car(PVector pos, int speed, float angle, Brain brain) {
    this.pos = pos;
    this.speed = speed;
    this.angle = angle;
    this.brain = brain;
  }

  PVector getTargetPosition(boolean apply) {
    PVector backAxle = getBackAxlePosition();
    PVector frontAxle = getFrontAxlePosition();
    PVector carVector = PVector.sub(frontAxle, backAxle).mult(5);
    PVector backAxleDirection = carVector.copy().rotate(PI / 2.0);
    PVector frontAxleDirection = carVector.copy().rotate(PI / 2.0).rotate(wheelAngle);
    PVector secondPointOnBackAxle = PVector.add(backAxle, backAxleDirection);
    PVector secondPointOnFrontAxle = PVector.add(frontAxle, frontAxleDirection);
    PVector s = intersect(backAxle, secondPointOnBackAxle, frontAxle, secondPointOnFrontAxle);


    if (s != null && abs(wheelAngle) >= 0.01) {
      float dist = PVector.dist(s, pos);

      float omega = speed / dist;
      omega = Math.signum(wheelAngle)*-omega;

      PVector u = PVector.sub(pos, s);
      u.rotate(omega);
      PVector newPos =PVector.add(s, u); 
      if (apply) {
        pos = newPos;
        angle -= omega;
        return pos;
      } else {
        return newPos;
      }
    } else {
      // It is straight 
      PVector speedDifference = new PVector(0, speed);
      PVector tempPos = pos.copy();
      speedDifference.rotate(angle);
      tempPos.add(speedDifference);
      if (apply) {
        pos = tempPos;
        return pos;
      } else {

        return tempPos;
      }
    }
  }

  void update() {
    speed = constrain(speed, -MAX_SPEED, MAX_SPEED);
    wheelAngle = constrain(wheelAngle, -MAX_WHEEL_TURN, MAX_WHEEL_TURN);

    if (isMoveValid()) {
      getTargetPosition(true);
    } else {
      speed = 0;
    }

    Situation situation = createSituation();
    Decision decision = decideWhatToDo(situation);
    applyDecision(decision);
    
    if (pos.x > width / 2) 
      didGetToRight = true;
  }

  Decision decideWhatToDo(Situation inputs) {
    brain.reset();

    for (Value val : Value.values()) {
      brain.getInputNodeByData(val).setValue(inputs.get(val));
    }

    brain.evaluate();

    Decision decision = new Decision();
    for (Action action : Action.values()) {
      decision.setValueForAction(action, brain.getOutputNodeByData(action).getValue());
    }

    return decision;
  }

  private void applyDecision(Decision decision) {
    Action action = decision.getAction();

    if (action == Action.TurnLeft) 
      wheelAngle += 0.05; 
    else if (action == Action.TurnRight)
      wheelAngle -= 0.05;
    else if (action == Action.SpeedUp)
      speed += 0.5;
    else if (action == Action.SlowDown)
      speed -= 0.5;
  }

  PVector getFrontAxlePosition() {
    PVector difference = new PVector(0, wheelDistFromCenter);
    difference = difference.rotate(angle);
    return PVector.sub(pos, difference);
  }

  PVector getBackAxlePosition() {
    PVector difference = new PVector(0, wheelDistFromCenter);
    difference = difference.rotate(angle);
    return PVector.add(pos, difference);
  }

  void display() {
    stroke(0, 0, 0);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    rectMode(CENTER);
    rect(0, 0, drawX, drawY);

    circle(0 - wheelDistFromCenter, 0 - wheelDistFromCenter, 7.5);
    circle(0 + wheelDistFromCenter, 0 - wheelDistFromCenter, 7.5);
    circle(0 - wheelDistFromCenter, 0 + wheelDistFromCenter, 7.5);
    circle(0 + wheelDistFromCenter, 0 + wheelDistFromCenter, 7.5);
    popMatrix();

    // Draw axles
    //stroke(255, 0, 0);
    PVector frontAxle = getFrontAxlePosition();
    //circle(frontAxle.x, frontAxle.y, 12.5);
    //stroke(0, 255, 0);
    //PVector backAxle = getBackAxlePosition();
    //circle(backAxle.x, backAxle.y, 7.5);

    stroke(0, 0, 255);
    PVector wheelMarkerVec = (new PVector(0, -20)).rotate(angle).rotate(-wheelAngle);
    PVector wheelMarkerPos = PVector.add(frontAxle, wheelMarkerVec);
    line(frontAxle.x, frontAxle.y, wheelMarkerPos.x, wheelMarkerPos.y);
    stroke(0, 0, 0);
  }

  boolean isMoveValid() {
    PVector copyPos = getTargetPosition(false);
    for (Wall wall : walls) {
      boolean inters = intersectLS(wall.coord, wall.coord1, pos, copyPos);
      if (inters) 
        return false;
    }

    return true;
  }

  float[] getRays() {
    float[] rays = new float[6];
    float increment = 360.0 / rays.length;
    for (int i = 0; i < rays.length; ++i) {
      rays[i] = getDistanceToWallInDirection(pos, angle + increment * i);
    }

    return rays;
  }

  Situation createSituation() {
    Situation situation = new Situation();

    float[] rays = getRays();

    situation.set(Value.Speed, speed);
    situation.set(Value.WheelAngle, wheelAngle);
    situation.set(Value.Distance0, rays[0]);
    situation.set(Value.Distance60, rays[1]);
    situation.set(Value.Distance120, rays[2]);
    situation.set(Value.Distance180, rays[3]);
    situation.set(Value.Distance240, rays[4]);
    situation.set(Value.Distance300, rays[5]);

    return situation;
  }
}
