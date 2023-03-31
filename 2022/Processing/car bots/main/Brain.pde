
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class Brain {
    private ArrayList<Node> allNodes = new ArrayList<Node>();

    private ArrayList<InputNode> inputNodes = new ArrayList<InputNode>();
    private ArrayList<InnerNode> innerNodes = new ArrayList<InnerNode>();
    private ArrayList<OutputNode> outputNodes = new ArrayList<OutputNode>();

    private Map<Object, InputNode> inputNodesMap = new HashMap<Object, InputNode>();
    private Map<Object, InnerNode> innerNodesMap = new HashMap<Object, InnerNode>();
    private Map<Object, OutputNode> outputNodesMap = new HashMap<Object, OutputNode>();

    private final boolean normalized;

    public Brain() {
        normalized = false;
    }

    public Brain(boolean normalized) {
        this.normalized = normalized;
    }

    public InputNode addInputNode(Object userData, String name) {
        InputNode inp = new InputNode(inputNodes.size(), normalized, name);
        inputNodesMap.put(userData, inp);
        allNodes.add(inp);
        inputNodes.add(inp);
        return inp;
    }

    public InnerNode addInnerNode(Object userData, String name) {
        InnerNode inn = new InnerNode(innerNodes.size(), normalized, name);
        innerNodesMap.put(userData, inn);
        allNodes.add(inn);
        innerNodes.add(inn);
        return inn;
    }

    public OutputNode addOutputNode(Object userData, String name) {
        OutputNode out = new OutputNode(outputNodes.size(), normalized, name);
        outputNodesMap.put(userData, out);
        allNodes.add(out);
        outputNodes.add(out);
        return out;
    }

    public InputNode getInputNodeByData(Object userData) {
        return inputNodesMap.get(userData);
    }

    public InnerNode getInnerNodeByData(Object userData) {
        return innerNodesMap.get(userData);
    }

    public OutputNode getOutputNodeByData(Object userData) {
        return outputNodesMap.get(userData);
    }

    public Connection addConnection(Node from, Node to, double weight) {
        return to.addConnectionFrom(from, weight);
    }

    public void evaluate() {
        for (InnerNode innerNode : innerNodes) {
            innerNode.reset();
            innerNode.getValue();
        }
        for (OutputNode outputNode : outputNodes) {
            outputNode.reset();
            outputNode.getValue();
        }
    }

    public void reset() {
        for (Node node : allNodes) {
            node.reset();
        }
    }

    public Node[] getInputNodes() {
        return inputNodes.toArray(new Node[0]);
    }

    public Node[] getInnerNodes() {
        return innerNodes.toArray(new Node[0]);
    }

    public Node[] getOutputNodes() {
        return outputNodes.toArray(new Node[0]);
    }

    public ArrayList<Node> getAllNodes() {
        return allNodes;
    }

    private void createConnectionFromGene(int gene) {
        Node from;
        Node to;
        double weight;

        boolean dstIsInner; // 1
        boolean srcIsInner; // 0
        int srcIndex; // 1110110
        int dstIndex; // 0001000
        short shortWeight; // 1001110001011100

        int getSrcIsInner = 1 << 31;
        srcIsInner = (getSrcIsInner & gene) != 0;
        int getDstIsInner = 1 << 23;
        dstIsInner = (getDstIsInner & gene) != 0;

        srcIndex = (gene >> 24) & 127;
        dstIndex = (gene >> 16) & 127;

        int getWeight = 1 << 16;
        shortWeight = (short) (getWeight | gene);

        weight = shortWeight / 6000.0;

        if (srcIsInner) {
            from = innerNodes.get(srcIndex % innerNodes.size());
        } else from = inputNodes.get(srcIndex % inputNodes.size());

        if (dstIsInner) {
            to = innerNodes.get(dstIndex % innerNodes.size());
        } else to = outputNodes.get(dstIndex % outputNodes.size());

        addConnection(from, to, weight);
    }

    public void loadFromGenome(int[] genome) {
        for (int i : genome) {
            createConnectionFromGene(i);
        }
    }

    public int[] getGenome() {
        ArrayList<Integer> genome = new ArrayList<Integer>();

        for (Node node : allNodes) {
            for (Connection connection : node.connections) {
                genome.add(connection.getGene());
            }
        }

        int[] ret = new int[genome.size()];
        for (int i = 0; i < genome.size(); i++)
            ret[i] = genome.get(i);

        return ret;
    }
}
