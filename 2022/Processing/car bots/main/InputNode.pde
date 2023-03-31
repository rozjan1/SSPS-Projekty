

public class InputNode  extends Node{

    InputNode(int nodeIndex, boolean normalized, String name) {
        super(nodeIndex, normalized, name);
    }


    @Override
    public Connection addConnectionFrom(Node a, double v) {
        throw new UnsupportedOperationException("Input Nodes cannot have incoming connections");
    }

    @Override
    protected void setValueNormalized(double value) {
        this.value = value;
    }

    @Override
    public double getValue() {
        if (value == null) {
            throw new UnsupportedOperationException("Value was not yet initialized");
        }

        return super.getValue();
    }

    @Override
    public boolean isInnerNode() {
        return false;
    }
}
