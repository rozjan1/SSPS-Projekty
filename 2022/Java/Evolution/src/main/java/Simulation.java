import java.util.ArrayList;
import java.util.Arrays;
import java.util.Random;

public class Simulation {
    public ArrayList<Creature> creatures = new ArrayList<>();
    public Grid grid;
    public int iteration;
    private int epoch;
    private Random randomGenerator;
    public EpochStats epochStats = null;


    public Simulation() {
        randomGenerator = new Random(13154875);
        createGrid();
        createCreatures();
    }

    public void createGrid() {

        grid = new Grid(Constants.GRID_SIZE);
    }

    public void prepareEpoch() {
        randomizeCreatures();
        iteration = 0;
        respawnFood();
    }

    private void respawnFood() {
        // Smazeme zbyvajici jidlo
        for (Cell[] column : grid.cells) {
            for (Cell cell : column) {
                if (cell.type == CellType.Food)
                    cell.type = CellType.Normal;
            }
        }

        for (int i = 0; i < creatures.size() * (1.0 / 2.0); ++i) {
            int x, y;
            do {
                x = randomGenerator.nextInt(grid.getSize() - 1);
                y = randomGenerator.nextInt(grid.getSize() - 1);
            } while (grid.cells[x][y].type != CellType.Normal);
            grid.cells[x][y].type = CellType.Food;
        }
    }

    public void step() {
        for (Creature creature : creatures) {
            Situation situation = getSituation(creature);
            Decision decision = creature.decideWhatToDo(situation);
            applyDecision(creature, decision);
        }
        iteration++;
        if (iteration >= Constants.EPOCH_LENGTH) {
            endEpoch();
            prepareEpoch();
        }
    }

    private void createCreatures() {
        for (int i = 0; i < Constants.CREATURE_COUNT; i++) {
            Creature e = new Creature(i);

            e.createBrainNodes();
            e.randomizeBrainConnections(randomGenerator);

            creatures.add(e);
        }
    }

    private void endEpoch() {
        System.out.println("Ending epoch...");

        // evaluace - vsichni kdo jsou na prave pulce, umrou
        evaluate();
        // rozmnozeni - ti, kdo prezili se rozmnozi
        reproduce();

        epoch++;
    }

    private int[] breedGenome(int[] main, int[] secondary) {
        int[] result = Arrays.copyOf(main, main.length);

        int start = randomGenerator.nextInt(secondary.length - 1);
        int end = randomGenerator.nextInt(secondary.length);
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

    private void reproduce() {
        ArrayList<Creature> creatures = this.creatures;
        this.creatures = new ArrayList<>(Constants.CREATURE_COUNT);

        if (creatures.size() == 0) {
            createCreatures();
            return;
        }

        for (int i = 0; i < Constants.CREATURE_COUNT; i++) {
            Creature mainParent = creatures.get(randomGenerator.nextInt(creatures.size()));
            Creature secondaryParent = creatures.get(randomGenerator.nextInt(creatures.size()));

            int[] mainParentGenome = mainParent.getGenome();
            int[] secondaryParentGenome = secondaryParent.getGenome();

            // Spojime genomy do vysledku
            int[] childGenome = breedGenome(mainParentGenome, secondaryParentGenome);

            // Zmutovat genom
            childGenome = mutate(childGenome);

            Creature child = new Creature(i, childGenome);
            this.creatures.add(child);
        }
    }

    private int[] mutate(int[] genome) {
        int[] result = Arrays.copyOf(genome, genome.length);

        for (int i = 0; i < result.length; i++) {
            for (int bit = 0; bit < 32; bit++) {
                if (randomGenerator.nextDouble() < Constants.MUTATION_RATE) {
                    // Bit flip
                    result[i] = result[i] ^ (1 << bit);
                }
            }
        }

        return result;
    }


    private void randomizeCreatures() {
        for (Creature creature : creatures) {
            creature.x = -1;
            creature.y = -1;
        }

        for (Creature creature : creatures) {
            int x, y;
            do {
                x = randomGenerator.nextInt(grid.getSize() - 1);
                y = randomGenerator.nextInt(grid.getSize() - 1);
            } while (grid.cells[x][y].type != CellType.Normal || getCreatureAt(x, y) != null);

            creature.x = x;
            creature.y = y;
            creature.rotation = Rotation.values()[randomGenerator.nextInt(4)];
        }
    }

    private void evaluate() {
        epochStats = new EpochStats(epochStats, epoch);
        creatures.removeIf(creature -> {
            return
                    creature.x > grid.getSize() / 2.0 &&
                            !creature.didEat();
        });
        epochStats.setSurvivalRate((double) creatures.size() / Constants.CREATURE_COUNT);

        epochStats.haveEaten = 0;
        for (Creature creature : creatures) {
            if (creature.didEat())
                epochStats.haveEaten++;
        }
        epochStats.calculateGenomeVariability(creatures);
    }

    private void moveBy(Creature creature, int offsetX, int offsetY) {
        int newX = creature.x + offsetX;
        int newY = creature.y + offsetY;
        if (!isMoveableTo(newX, newY))
            return;

        creature.x = newX;
        creature.y = newY;
    }

    private boolean isMoveableTo(int x, int y) {
        if (grid.cells[x][y].type == CellType.Wall)
            return false;
        return getCreatureAt(x, y) == null;
    }

    private void applyDecision(Creature creature, Decision decision) {
        Decision.Action action = decision.getAction();

        if (action == Decision.Action.MoveBackwards) {
            moveBy(creature, -creature.rotation.getFacingX(), -creature.rotation.getFacingY());
        } else if (action == Decision.Action.MoveForward) {
            moveBy(creature, creature.rotation.getFacingX(), creature.rotation.getFacingY());
        } else if (action == Decision.Action.TurnLeft) {
            creature.rotation = creature.rotation.getLeft();
        } else if (action == Decision.Action.TurnRight) {
            creature.rotation = creature.rotation.getRight();
        } else if (action == Decision.Action.Eat) {
            if (grid.cells[creature.x][creature.y].type == CellType.Food) {
                // Eating was successful
                grid.cells[creature.x][creature.y].type = CellType.Normal;
                creature.eat();
            }
        } else if (action == Decision.Action.SetOscillatorPeriod) {
            creature.oscillationMultiplier = decision.getValueForAction(Decision.Action.NewOscillatorPeriod);
        } else if (action == Decision.Action.Attack) {
        }
    }

    public Situation getSituation(Creature creature) {
        Situation situation = new Situation();
        situation.set(Situation.Value.X, Utilities.map(creature.x, 0, grid.getSize(), -1, 1));
        situation.set(Situation.Value.Y, Utilities.map(creature.y, 0, grid.getSize(), -1, 1));
        situation.set(Situation.Value.FacingX, creature.rotation.getFacingX());
        situation.set(Situation.Value.FacingY, creature.rotation.getFacingY());
        situation.set(Situation.Value.Age, iteration / (double) Constants.EPOCH_LENGTH);
        situation.set(Situation.Value.LastMoveX, creature.lastMoveX);
        situation.set(Situation.Value.LastMoveY, creature.lastMoveY);
        situation.set(Situation.Value.Hungry, creature.didEat() ? 1 : -1);

        situation.set(Situation.Value.HowFarCreature, 0);
        situation.set(Situation.Value.AngleToNearestCreature, 0);
        Creature other = getNearestCreature(creature);
        if (other != null) {
            double distance = getDistance(creature.x, creature.y, other.x, other.y);
            if (distance <= Constants.VIEW_DISTANCE) {
                double angle = getAngle(creature.x, creature.y, other.x, other.y);
                situation.set(Situation.Value.HowFarCreature, Utilities.map(distance, 0, Constants.VIEW_DISTANCE, 0, 1));
                situation.set(Situation.Value.AngleToNearestCreature, Utilities.map(angle, -Math.PI, Math.PI, -1, 1));
            }
        }

        situation.set(Situation.Value.HowFarFood, 0);
        situation.set(Situation.Value.AngleToNearestFood, 0);
        Cell nearestFood = getNearestFood(creature);

        if (nearestFood != null) {
            double distance = getDistance(nearestFood.x, nearestFood.y, creature.x, creature.y);
            if (distance <= Constants.VIEW_DISTANCE) {
                double angle = getAngle(creature.x, creature.y, nearestFood.x, nearestFood.y);
                situation.set(Situation.Value.HowFarFood, Utilities.map(distance, 0, Constants.VIEW_DISTANCE, 0, 1));
                situation.set(Situation.Value.AngleToNearestFood, Utilities.map(angle, -Math.PI, Math.PI, -1, 1));
            }
        }

        situation.set(Situation.Value.IsWallInFront,
                isWallAt(creature.x + creature.rotation.getFacingX(), creature.y + creature.rotation.getFacingY())
                        ? 1 : 0);
        situation.set(Situation.Value.RandomInput, randomGenerator.nextDouble());
        situation.set(Situation.Value.Oscillator, Math.sin(iteration * creature.oscillationMultiplier));

        return situation;
    }

    private double getDistance(double x1, double y1, double x2, double y2) {
        double xDiff = x1 - x2;
        double yDiff = y1 - y2;
        return Math.abs(xDiff) + Math.abs(yDiff);
    }

    private double getAngle(double x1, double y1, double x2, double y2) {
        double xDiff = x1 - x2;
        double yDiff = y1 - y2;
        return Math.atan2(yDiff, xDiff);
    }

    private Cell getNearestFood(Creature creature) {
        double distance = 10000000;
        Cell closestFood = null;
        for (int x = 0; x < grid.getSize(); x++) {
            for (int y = 0; y < grid.getSize(); y++) {
                double dist = Grid.distanceBetween(creature.x, creature.y, x, y);
                if (grid.cells[x][y].type == CellType.Food && dist < distance) {
                    distance = dist;
                    closestFood = grid.cells[x][y];
                }
            }
        }
        return closestFood;
    }

    public Creature getNearestCreature(Creature creature) {
        double distance = 10000000;
        Creature closestCreature = null;
        for (Creature creature1 : creatures) {
            double dist = Grid.distanceBetween(creature.x, creature.y, creature1.x, creature1.y);
            if (dist < distance) {
                distance = dist;
                closestCreature = creature1;
            }
        }

        return closestCreature;
    }

    public Creature getCreatureAt(int x, int y) {
        if (x < 0 || y < 0 || x >= grid.getSize() || y >= grid.getSize())
            return null;

        for (Creature c : creatures)
            if (c.x == x && c.y == y)
                return c;

        return null;
    }


    private boolean isWallAt(int x, int y) {
        if (x < 0 || y < 0 || x >= grid.getSize() || y >= grid.getSize())
            return true;
        return grid.cells[x][y].type == CellType.Wall;
    }

    public char whatToPrint(int x, int y) {
        CellType type = grid.cells[x][y].type;
        if (type == CellType.Wall) {
            return '█';
        }
        Creature creature = getCreatureAt(x, y);
        if (creature != null) {
            return creature.getId();
        }
        if (type == CellType.Normal) {
            return '_';
        } else if (type == CellType.Food) {
            return '.';
        }
        return '_';
    }

    public void stepEpoch() {
        step();
        while (iteration != 0)
            step();
    }
}
