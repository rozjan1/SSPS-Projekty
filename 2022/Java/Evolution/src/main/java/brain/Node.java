package brain;

import java.util.ArrayList;

public abstract class Node {
    protected ArrayList<Connection> connections = new ArrayList<>();
    protected Double value = null;
    protected int nodeIndex;
    protected boolean normalized;
    public final String name;

    Node(int nodeIndex, boolean normalized, String name) {
        this.nodeIndex = nodeIndex;
        this.normalized = normalized;
        this.name = name;
    }

    public Connection addConnectionFrom(Node a, double v) {
        Connection conn = new Connection(a, this, v);
        connections.add(conn);
        return conn;
    }

    protected abstract void setValueNormalized(double value);

    public void setValue(double value) {
        if (normalized)
            setValueNormalized(value);
        else
            this.value = value;
    }

    public double getValue() {
        if (value == null) {
            // Ask connections for their values and do some math on it
            double val = 0;
            for (Connection connection : connections) {
                val += connection.getValue();
            }
            setValue(val);
        }

        return value;
    }

    public abstract boolean isInnerNode();

    public void reset() {
        value = null;
    }
}
