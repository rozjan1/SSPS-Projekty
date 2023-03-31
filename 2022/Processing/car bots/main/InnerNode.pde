
public class InnerNode extends Node {
    protected double previousValue = 0.0;

    InnerNode(int nodeIndex, boolean normalized, String name) {
        super(nodeIndex, normalized, name);
    }

    @Override
    protected void setValueNormalized(double value) {
        this.value = Math.tanh(value);
    }

    @Override
    public boolean isInnerNode() {
        return true;
    }

    @Override
    public void reset() {
        if (value != null)
            previousValue = value;
        super.reset();
    }
}
