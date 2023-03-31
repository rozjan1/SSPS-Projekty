package brain;

public class Connection {
    public Node srcNode, dstNode;
    public double weight;

    public Connection(Node source, Node destination, double w) {
        srcNode = source;
        dstNode = destination;
        weight = w;
    }

    public int getGene() {
        short weight = (short) Math.round(this.weight*6000); // 16-bit
        boolean srcIsInner = srcNode.isInnerNode(); // 1-bit
        boolean dstIsInner = dstNode.isInnerNode(); // 1-bit
        byte srcIndex = (byte) srcNode.nodeIndex; // 8-bit (kde nejvic vlevo je vzdy 0)
        byte dstIndex = (byte) dstNode.nodeIndex; // 8-bit (kde nejvic vlevo je vzdy 0)

        int result = 0;


        if (srcIsInner) {
            // 100000....0
            int addedNumber = 1 << 31;
            result = result | addedNumber;
        }
        int srcInd = srcIndex << 24;
        result = result | srcInd;

        if (dstIsInner) {
            int addedNum = 1 << 23;
            result = result | addedNum;
        }
        int dstInd = dstIndex << 16;
        result = result | dstInd;

        result = result | (0xFFFF & weight);

        return result;
    }

    public double getValue() {
        double returnValue;
        if (srcNode.isInnerNode() && dstNode.isInnerNode()) {
            returnValue = ((InnerNode) srcNode).previousValue;
        } else {
            returnValue = srcNode.getValue();
        }

        return returnValue * weight;
    }
}
