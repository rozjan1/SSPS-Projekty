package brain;

import guru.nidi.graphviz.attribute.Label;
import guru.nidi.graphviz.attribute.Rank;
import guru.nidi.graphviz.engine.Format;
import guru.nidi.graphviz.engine.Graphviz;
import guru.nidi.graphviz.model.Graph;
import guru.nidi.graphviz.model.LinkSource;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import static guru.nidi.graphviz.attribute.Rank.RankDir.LEFT_TO_RIGHT;
import static guru.nidi.graphviz.model.Factory.graph;
import static guru.nidi.graphviz.model.Factory.node;
import static guru.nidi.graphviz.model.Link.to;

public class BrainRenderer {
    public BrainRenderer() {

    }


    public void render(Brain brain, String path) throws IOException {
        ArrayList<LinkSource> links = new ArrayList<>();

        for (Node node : brain.getAllNodes()) {
            for (Connection connection : node.connections) {
                String from = connection.srcNode.name;
                String to = connection.dstNode.name;
                String weight = String.valueOf(connection.weight);

                links.add(node(from).link(to(node(to)).with(Label.of(weight))));
            }
        }

        Graph g = graph("Brain").directed()
                .graphAttr().with(Rank.dir(LEFT_TO_RIGHT))
                .with(links);

        Graphviz.fromGraph(g).height(600).render(Format.PNG).toFile(new File(path));
    }

    private Brain createSampleBrain() {
        Brain brain = new Brain(true);
        InputNode a = brain.addInputNode(null, "inputA");
        InputNode b = brain.addInputNode(null, "inputB");
        InnerNode c = brain.addInnerNode(null, "inputC");
        OutputNode d = brain.addOutputNode(null, "outputD");

        brain.addConnection(a, c, -2);
        brain.addConnection(b, c, 2);
        brain.addConnection(c, d, 3);
        return brain;
    }

    public static void main(String[] args) throws IOException {
        BrainRenderer renderer = new BrainRenderer();
        renderer.render(renderer.createSampleBrain(), "output/brain.png");
    }

}
