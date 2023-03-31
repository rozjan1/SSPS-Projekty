import brain.*;
import org.junit.jupiter.api.Test;

import java.util.Random;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class BrainSerializationTest {

    @Test
    void testIsSerializedWell() {
        // 1. Create a brain with known values
        // 2. Serialize the brain (brain.getGenome..)
        // 3. Create a brain from the genome
        // 4. Check that they are the same... (compare doubles to 4 decimal places accuracy)
        int[] genome;
        double resultE;
        double resultF;

        {
            Brain brain = new Brain();

            InputNode a = brain.addInputNode(null, "");
            InputNode b = brain.addInputNode(null, "");
            Node c = brain.addInnerNode(null, "");
            Node d = brain.addInnerNode(null, "");
            OutputNode e = brain.addOutputNode(null, "");
            OutputNode f = brain.addOutputNode(null, "");

            brain.addConnection(a, c, -1.2);
            brain.addConnection(b, c, 3);
            brain.addConnection(b, d, 0.211333115445);
            brain.addConnection(c, e, 3.4);
            brain.addConnection(d, e, -1);
            brain.addConnection(d, f, 2.3);

            a.setValue(0.9);
            b.setValue(0.1);
            brain.evaluate();

            genome = brain.getGenome();
            resultE = e.getValue();
            resultF = f.getValue();
        }

        Brain brain = new Brain();

        InputNode a = brain.addInputNode(null, "");
        InputNode b = brain.addInputNode(null, "");
        Node c = brain.addInnerNode(null, "");
        Node d = brain.addInnerNode(null, "");
        OutputNode e = brain.addOutputNode(null, "");
        OutputNode f = brain.addOutputNode(null, "");

        brain.loadFromGenome(genome);

        a.setValue(0.9);
        b.setValue(0.1);
        brain.evaluate();

        assertTrue(Math.abs(e.getValue() - resultE) <= 0.0002); // 5.7?
        assertTrue(Math.abs(f.getValue() - resultF) <= 0.0002);
    }

    @Test
    void testRandomBrain() {
        int[] genome = new int[20];
        Random random = new Random();
        for (int i = 0; i < genome.length; i++) {
            genome[i] = random.nextInt();
        }

        Brain brain = new Brain();
        InputNode a = brain.addInputNode(null, "");
        InputNode b = brain.addInputNode(null, "");
        Node c = brain.addInnerNode(null, "");
        Node d = brain.addInnerNode(null, "");
        OutputNode e = brain.addOutputNode(null, "");
        OutputNode f = brain.addOutputNode(null, "");
        brain.loadFromGenome(genome);
    }
}
