import brain.Brain;
import brain.Node;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;

public class Creature {
    public int x, y;
    public Rotation rotation;
    public Brain brain;
    public int lastMoveX;
    public int lastMoveY;
    private int id;
    private boolean didEat = false;

    public double oscillationMultiplier = 1;

    public Creature(int id) {
        this.id = id;
    }

    public Creature(int id, int[] genome) {
        this.id = id;
        createBrainNodes();
        brain.loadFromGenome(genome);
    }

    public char getId() {
        return (char)('a' + id);
    }

    public void createBrainNodes() {
        brain = new Brain();
        // Vytvorime input nody
        for (Situation.Value param : Situation.Value.values()) {
            brain.addInputNode(param, param.name());
        }

        brain.addInnerNode(null, "inner1");
        brain.addInnerNode(null, "inner2");

        // Vytvorime output nody
        for (Decision.Action action : Decision.Action.values()) {
            brain.addOutputNode(action, action.name());
        }
    }

    public Decision decideWhatToDo(Situation inputs) {
        brain.reset();

        for (Situation.Value val : Situation.Value.values()) {
            brain.getInputNodeByData(val).setValue(inputs.get(val));
        }

        brain.evaluate();

        Decision decision = new Decision();
        for (Decision.Action action : Decision.Action.values()) {
            decision.setValueForAction(action, brain.getOutputNodeByData(action).getValue());
        }

        return decision;
    }

    public void randomizeBrainConnections(Random random) {
        Node[] inputs = brain.getInputNodes();
        Node[] inners = brain.getInnerNodes();
        Node[] outputs = brain.getOutputNodes();

        ArrayList<Node> fromNodes = new ArrayList<>(inputs.length + inners.length);
        Collections.addAll(fromNodes, inputs);
        Collections.addAll(fromNodes, inners);
        ArrayList<Node> toNodes = new ArrayList<>(inners.length + outputs.length);
        Collections.addAll(toNodes, inners);
        Collections.addAll(toNodes, outputs);


        for (int i = 0; i < Constants.CONNECTION_COUNT; i++) {
            int from = random.nextInt(fromNodes.size());
            int to = random.nextInt(toNodes.size());

            double weight = Utilities.map(random.nextDouble(), 0.0, 1.0, -10.0, 10.0);
            brain.addConnection(fromNodes.get(from), toNodes.get(to), weight);
        }
    }

    public int[] getGenome() {
        return brain.getGenome();
    }

    public void eat() {
        didEat = true;
    }

    public boolean didEat() {
        return didEat;
    }
}
