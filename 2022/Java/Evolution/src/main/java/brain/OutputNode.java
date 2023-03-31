package brain;

public class OutputNode extends Node {

    OutputNode(int nodeIndex, boolean normalized, String name) {
        super(nodeIndex, normalized, name);
    }

    @Override
    protected void setValueNormalized(double value) {
        this.value = (Math.tanh(value) + 1) / 2.0;
    }

    @Override
    public boolean isInnerNode() {
        return false;
    }
}
