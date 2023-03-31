import brain.*;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;


public class NeuralTest {

    @Test
    void testPropagationSimple() {
        Brain brain = new Brain(true);
        InputNode a = brain.addInputNode(null, "inputA");
        InputNode b = brain.addInputNode(null, "inputB");
        InnerNode c = brain.addInnerNode(null, "innerC");
        OutputNode d = brain.addOutputNode(null, "outputD");

        brain.addConnection(a, c, -2);
        brain.addConnection(b, c, 2);
        brain.addConnection(c, d, 3);

        a.setValue(0.3);
        b.setValue(0.4);

        brain.evaluate();

        assertEquals(0.3, a.getValue());
        assertEquals(0.4, b.getValue());
        assertEquals(0.19737532022490406, c.getValue());
        assertEquals(0.7657114491125523, d.getValue());
    }

    @Test
    void testPropagationComplex() {
        Brain brain = new Brain();

        InputNode a = brain.addInputNode(null, "inputA");
        InputNode b = brain.addInputNode(null, "inputB");
        Node c = brain.addInnerNode(null, "InnerC");
        Node d = brain.addInnerNode(null, "innerD");
        OutputNode e = brain.addOutputNode(null, "outputE");
        OutputNode f = brain.addOutputNode(null, "outputF");

        brain.addConnection(a, c, -1.2);
        brain.addConnection(b, c, 3);
        brain.addConnection(b, d, 0.2);
        brain.addConnection(c, e, 3.4);
        brain.addConnection(d, e, -1);
        brain.addConnection(d, f, 2.3);

        a.setValue(0.9);
        b.setValue(0.1);

        brain.evaluate();

        assertEquals(-2.672, e.getValue());
        assertTrue(Utilities.equals(0.046,f.getValue() ));
    }

    @Test
    void testInnerLink() {
        Brain brain = new Brain(false);

        InputNode a = brain.addInputNode(null, "inputA");

        InnerNode b = brain.addInnerNode(null, "");
        InnerNode c = brain.addInnerNode(null, "");

        OutputNode d = brain.addOutputNode(null, "");

        brain.addConnection(a, b, -1);
        brain.addConnection(a, c, 2);

        brain.addConnection(b, c, 0.5);
        brain.addConnection(c, b, 0.1);

        brain.addConnection(b, d, 0);
        brain.addConnection(c, d, -0.8);

        brain.reset();
        a.setValue(2);
        brain.evaluate();

        assertEquals(-3.2, d.getValue());

        brain.reset();
        a.setValue(-1);
        brain.evaluate();

        assertTrue(Math.abs(2.4 - d.getValue()) <= 0.00002);
    }

    @Test
    void testSelfLink() {
        Brain brain = new Brain(false);

        InputNode a = brain.addInputNode(null, "");
        InputNode b = brain.addInputNode(null, "");

        InnerNode c = brain.addInnerNode(null, "");
        InnerNode d = brain.addInnerNode(null, "");

        OutputNode e = brain.addOutputNode(null, "");

        brain.addConnection(a, c, -1);
        brain.addConnection(b, c, 2);
        brain.addConnection(b, d, -0.5);

        brain.addConnection(c, c, 2.1);

        brain.addConnection(c, e, 1.5);
        brain.addConnection(c, d, 0.3);
        brain.addConnection(d, e, 2.3);

        brain.reset();
        a.setValue(0.9);
        b.setValue(0.1);
        brain.evaluate();

        assertEquals(-0.7, c.getValue());
        assertEquals(-0.05, d.getValue());
        assertTrue(Utilities.equals(-1.165, e.getValue()));

        brain.reset();
        a.setValue(0.3);
        b.setValue(-0.6);
        brain.evaluate();

        assertTrue(Utilities.equals(-2.97,c.getValue()));
        assertTrue(Utilities.equals(0.09,d.getValue()));
        assertTrue(Utilities.equals(-4.248, e.getValue()));
    }
}
