// Potrebuje to hodne malych uprav aby to auto vubec dojelo

import java.util.Map;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;

final int CAR_COUNT = 100;
ArrayList<Car> cars;
float meanLastScore = 0;
int epoch = 0;

ArrayList<Wall> walls;
ArrayList<PVector> checkpoints;

boolean showDist = false;

void setup() {
  size(850, 850);
  walls = new ArrayList<Wall>(); 
  createWalls();
  createCheckpoints();
  cars = new ArrayList<Car>();
  for (int i =0; i < CAR_COUNT; i++)
    cars.add(createNewCar());
}

void createWalls() {
  walls.add(new Wall(0, 0, 850, 0));
  walls.add(new Wall(0, 0, 0, 850));
  walls.add(new Wall(850, 0, 850, 850));
  walls.add(new Wall(0, 0, 0, 850));
  walls.add(new Wall(118, 172, 322, 167));
  walls.add(new Wall(322, 167, 348, 363));
  walls.add(new Wall(348, 363, 533, 349));
  walls.add(new Wall(533, 349, 540, 157));
  walls.add(new Wall(540, 157, 735, 156));
  walls.add(new Wall(735, 156, 738, 394));
  walls.add(new Wall(738, 394, 634, 408));
  walls.add(new Wall(639, 517, 634, 408));
  walls.add(new Wall(639, 515, 569, 628));
  walls.add(new Wall(570, 625, 506, 556));
  walls.add(new Wall(506, 556, 355, 562));
  walls.add(new Wall(355, 562, 286, 664));
  walls.add(new Wall(286, 664, 197, 664));
  walls.add(new Wall(197, 664, 192, 528));
  walls.add(new Wall(192, 528, 89, 529));
  walls.add(new Wall(89, 529, 88, 338));
  walls.add(new Wall(88, 338, 238, 330));
  walls.add(new Wall(238, 330, 240, 233));
  walls.add(new Wall(240, 233, 117, 226));
  walls.add(new Wall(117, 226, 118, 172));
  walls.add(new Wall(113, 69, 800, 56));
  walls.add(new Wall(426, 62, 438, 264));
  walls.add(new Wall(807, 773, 797, 55));
  walls.add(new Wall(801, 441, 673, 658));
  walls.add(new Wall(673, 658, 610, 750));
  walls.add(new Wall(609, 750, 472, 645));
  walls.add(new Wall(472, 645, 450, 767));
  walls.add(new Wall(449, 767, 341, 721));
  walls.add(new Wall(341, 721, 179, 764));
  walls.add(new Wall(179, 764, 61, 668));
  walls.add(new Wall(61, 668, 36, 592));
  walls.add(new Wall(36, 592, 16, 514));
  walls.add(new Wall(16, 514, 21, 72));
  walls.add(new Wall(21, 72, 123, 68));
  walls.add(new Wall(20, 277, 168, 281));
}

void createCheckpoints() {
  checkpoints = new ArrayList<PVector>();
  checkpoints.add(new PVector(92, 122));
checkpoints.add(new PVector(109, 121));
checkpoints.add(new PVector(136, 121));
checkpoints.add(new PVector(194, 124));
checkpoints.add(new PVector(262, 129));
checkpoints.add(new PVector(307, 127));
checkpoints.add(new PVector(343, 132));
checkpoints.add(new PVector(381, 141));
checkpoints.add(new PVector(395, 162));
checkpoints.add(new PVector(398, 185));
checkpoints.add(new PVector(400, 205));
checkpoints.add(new PVector(401, 228));
checkpoints.add(new PVector(405, 257));
checkpoints.add(new PVector(406, 281));
checkpoints.add(new PVector(431, 300));
checkpoints.add(new PVector(457, 294));
checkpoints.add(new PVector(475, 260));
checkpoints.add(new PVector(486, 214));
checkpoints.add(new PVector(491, 191));
checkpoints.add(new PVector(501, 167));
checkpoints.add(new PVector(512, 146));
checkpoints.add(new PVector(532, 131));
checkpoints.add(new PVector(555, 125));
checkpoints.add(new PVector(585, 120));
checkpoints.add(new PVector(606, 119));
checkpoints.add(new PVector(632, 121));
  checkpoints.add(new PVector(600, 109 ));
  checkpoints.add(new PVector(686, 104 ));
  checkpoints.add(new PVector(765, 102 ));
  checkpoints.add(new PVector(769, 204 ));
  checkpoints.add(new PVector(770, 297 ));
  checkpoints.add(new PVector(771, 398 ));
  checkpoints.add(new PVector(727, 474 ));
  checkpoints.add(new PVector(688, 547 ));
  checkpoints.add(new PVector(650, 606 ));
  checkpoints.add(new PVector(595, 680 ));
  checkpoints.add(new PVector(507, 628 ));
  checkpoints.add(new PVector(379, 656 ));
  checkpoints.add(new PVector(300, 695 ));
  checkpoints.add(new PVector(192, 700 ));
  checkpoints.add(new PVector(120, 640 ));
  checkpoints.add(new PVector(66, 552 ));
  checkpoints.add(new PVector(48, 473 ));
  checkpoints.add(new PVector(49, 390 ));
  checkpoints.add(new PVector(51, 333 ));
  checkpoints.add(new PVector(71, 317 ));
  checkpoints.add(new PVector(90, 318 ));
  checkpoints.add(new PVector(116, 315 ));
  checkpoints.add(new PVector(136, 313 ));
  checkpoints.add(new PVector(158, 312 ));
  checkpoints.add(new PVector(183, 310 ));
  checkpoints.add(new PVector(191, 285 ));
  checkpoints.add(new PVector(187, 265 ));
  checkpoints.add(new PVector(168, 257 ));
  checkpoints.add(new PVector(148, 255 ));
  checkpoints.add(new PVector(121, 250 ));
  checkpoints.add(new PVector(100, 241 ));
  checkpoints.add(new PVector(60, 187 ));
}


Brain createBrainNodes() {
  Brain brain = new Brain();
  // Create input nodes
  for (Value param : Value.values()) {
    brain.addInputNode(param, param.name());
  }

  brain.addInnerNode(null, "inner1");
  brain.addInnerNode(null, "inner2");

  // Create output nodes
  for (Action action : Action.values()) {
    brain.addOutputNode(action, action.name());
  }
  return brain;
}

Car createNewCar() {
  Brain brain = createBrainNodes();
  randomizeBrainConnections(brain);
  return createCarWithBrain(brain);
}

Car createCarWithGenome(int[] genome) {
  Brain brain = createBrainNodes();
  brain.loadFromGenome(genome);
  return createCarWithBrain(brain);
}

Car createCarWithBrain(Brain brain) {
  return new Car(new PVector(69, 116), 0, PI/4, brain);
}

void randomizeBrainConnections(Brain brain) {
  Node[] inputs = brain.getInputNodes();
  Node[] inners = brain.getInnerNodes();
  Node[] outputs = brain.getOutputNodes();

  ArrayList<Node> fromNodes = new ArrayList<Node>(inputs.length + inners.length);
  for (Node n : inputs)
    fromNodes.add(n);
  for (Node n : inners)
    fromNodes.add(n);
  ArrayList<Node> toNodes = new ArrayList<Node>(inners.length + outputs.length);
  for (Node n : inners)
    toNodes.add(n);
  for (Node n : outputs)
    toNodes.add(n);

  for (int i = 0; i < 25; i++) {
    int from = (int) random(fromNodes.size());
    int to = (int) random(toNodes.size());

    double weight = map(random(1), 0.0, 1.0, -10.0, 10.0);
    brain.addConnection(fromNodes.get(from), toNodes.get(to), weight);
  }
}

boolean ccw(PVector A, PVector B, PVector C) {
  return (C.y-A.y) * (B.x-A.x) > (B.y-A.y) * (C.x-A.x);
}

// Return true if line segments AB and CD intersect
boolean intersectLS(PVector A, PVector B, PVector C, PVector D) {
  return ccw(A, C, D) != ccw(B, C, D) && ccw(A, B, C) != ccw(A, B, D);
}

PVector intersect(PVector A, PVector B, PVector C, PVector D) {
  float a1 = (A.y - B.y);
  float b1 = (B.x - A.x);
  float c1 = - (A.x * B.y - B.x * A.y);
  float a2 = (C.y - D.y);
  float b2 = (D.x - C.x);
  float c2 = -(C.x * D.y - D.x * C.y);

  float d = a1 * b2 - b1 * a2;
  float dx = c1 * b2 - b1 * c2;
  float dy = a1 * c2 - c1 * a2;

  if (d == 0) 
    return null;
  return new PVector(dx / d, dy / d);
}

float getDistanceToWallInDirection(PVector position, float angle) {
  PVector targetPos = new PVector(max(width, height), 0, 0);
  targetPos.rotate(angle);
  targetPos.add(position);

  PVector minimum = null;
  float minLen = max(width, height);
  for (Wall wall : walls) {
    if (!intersectLS(position, targetPos, wall.coord, wall.coord1))
      continue;
    PVector thePoint = intersect(position, targetPos, wall.coord, wall.coord1);
    float len = PVector.dist(position, thePoint);

    if (len < minLen) {
      minLen = len;
      minimum = thePoint;
    }
  }

  if (showDist && minimum != null) 
    circle(minimum.x, minimum.y, 10);

  return minLen;
}

void endEpoch() {
  println("Ending epoch...");
  evaluateEpoch();
  reproduce();
  epoch ++;
}

void evaluateEpoch() {
  // Evaluate car quality
  // Select top 50% of cars 
  // by the distance they have travelled
  // Kill the rest
  
 
  for (Car car : cars) 
    car.score = getCarScore(car);
  
  Collections.sort(cars, new Comparator<Car>() {
   @Override
    public int compare(Car o1, Car o2) {
        return Float.compare(o1.score, o2.score);
    } 
  });
  
  meanLastScore = 0;
  for (Car car : cars) meanLastScore += car.score;
  meanLastScore /= cars.size();

  for (int i = 0; i < CAR_COUNT * 0.8; i++) { //<>//
    cars.remove(cars.get(0));
  }
  
  for (Car car : cars) {
   print(car.score + " "); 
  }
}

float getCarScore(Car car) {

  float minimum = 20000;
  int minimumIndex = 0;

  for (int i = 0; i < checkpoints.size(); i++) 
  {
    float distance = car.pos.dist(checkpoints.get(i));
    if (distance < minimum) {
      minimum = distance;
      minimumIndex = i;
    }
  }
  
  // Check if the car did go a bit of distance
  if (minimumIndex > checkpoints.size() - 20 && car.didGetToRight == false)
    return 0;
    
  
  return minimumIndex;
}

int[] breedGenome(int[] main, int[] secondary) {
  int[] result = Arrays.copyOf(main, main.length);

  int start = (int)random(secondary.length - 1);
  int end = (int)random(secondary.length);
  if (start > end) {
    int tmp = end;
    end = start;
    start = tmp;
  }

  for (int i = start; i <= end; i++) {
    result[i] = secondary[i];
  }

  return result;
}

void reproduce() {
  ArrayList<Car> newCars = new ArrayList<Car>(CAR_COUNT);

  if (cars.size() == 0) {
    for (int i = 0; i < CAR_COUNT; i++) {
      newCars.add(createNewCar());
    }
    return;
  }

  for (int i = 0; i < CAR_COUNT; i++) {
    Car mainParent = cars.get(int(random(cars.size())));
    Car secondaryParent = cars.get(int(random(cars.size())));

    int[] mainParentGenome = mainParent.brain.getGenome();
    int[] secondaryParentGenome = secondaryParent.brain.getGenome();

    // Combine genomes into result
    int[] childGenome = breedGenome(mainParentGenome, secondaryParentGenome);

    // Mutate
    childGenome = mutate(childGenome);

    Car child = createCarWithGenome(childGenome);
    newCars.add(child);
  }
  cars = newCars;
}

private int[] mutate(int[] genome) {
  int[] result = Arrays.copyOf(genome, genome.length);

  for (int i = 0; i < result.length; i++) {
    for (int bit = 0; bit < 32; bit++) {
      if (random(1.0) < 0.01) {
        // Flip the bit
        result[i] = result[i] ^ (1 << bit);
      }
    }
  }

  return result;
}

void draw() {
  background(255);
  
  text("Mezernik = end epochy", 70, 20);

  for (Car car : cars) {
    car.update();
    car.display();
  }

  for (Wall wall : walls) {
    wall.display();
  }
  
  fill(0);
  text(meanLastScore, 20, 20);
  text(epoch, 20, 30);
  noFill();
}

void keyPressed() {
  if (key == ' ') 
    endEpoch();
}


/*
void drawWheelMarker() {
 circle(50, 50, 40*2);
 PVector pos = (new PVector(0, 40)).rotate(-car.wheelAngle + PI);
 line(50, 50, pos.x + 50, pos.y + 50);
 }
 */

/*
void keyPressed() {
 if (keyCode == UP) 
 car.speed -= 0.5;
 
 if (keyCode == DOWN) 
 car.speed += 0.5;
 
 if (keyCode == LEFT)
 car.wheelAngle += 0.05;
 if (keyCode == RIGHT)
 car.wheelAngle -= 0.05;
 }
 */
