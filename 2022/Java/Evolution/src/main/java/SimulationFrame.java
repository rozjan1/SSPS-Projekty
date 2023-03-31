import brain.BrainRenderer;

import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class SimulationFrame extends JFrame {
    private final Simulation simulation;
    private final SimulationPanel simulationPanel;
    private final Object lock = new Object();

    private ScheduledExecutorService repeater = Executors.newScheduledThreadPool(1);

    private JLabel epochStats;
    private JLabel isDrawing;

    public SimulationFrame(Simulation simulation) {
        super("Evolution simulator");
        this.simulation = simulation;

        setLayout(new FlowLayout());
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        simulationPanel = new SimulationPanel(simulation);
        JPanel controlsPanel = createControls();
        JPanel statsPanel = createStats();

        add(simulationPanel);
        add(controlsPanel);
        add(statsPanel);

        pack();
        setVisible(true);

        setSize(700, 800);
    }

    private JPanel createStats() {
        epochStats = new JLabel();

        JPanel statsPanel = new JPanel();
        statsPanel.add(epochStats);
        return statsPanel;
    }

    private JPanel createControls() {
        JButton nextButton = new JButton("Next");
        JButton drawCreature = new JButton("Draw to file");
        JButton start = new JButton("Start");
        JButton stop = new JButton("Stop");
        JButton epochButton = new JButton("Epoch");
        JButton drawWall = new JButton("Draw a wall");
        JButton skipEpoch = new JButton("Skip epoch");
        JButton skip10Epochs = new JButton("Skip 10 epochs");

        //----------------------------------------------------------------------
        nextButton.setPreferredSize(new Dimension(100, 20));
        nextButton.addActionListener(e -> {
            simulation.step();
            update();
        });
        //----------------------------------------------------------------------
        epochButton.setPreferredSize(new Dimension(100, 20));
        epochButton.addActionListener(e -> {
            simulation.prepareEpoch();
            update();
        });
        //----------------------------------------------------------------------
        start.setPreferredSize(new Dimension(100, 20));
        start.addActionListener(e -> {
            repeater.scheduleAtFixedRate(() -> {
                synchronized (lock) {
                    simulation.step();
                }
                update();
            }, 0, 30, TimeUnit.MILLISECONDS);
        });
        //----------------------------------------------------------------------
        stop.setPreferredSize(new Dimension(100, 20));
        stop.addActionListener(e -> {
            repeater.shutdown();
            repeater = Executors.newScheduledThreadPool(1);
        });
        //----------------------------------------------------------------------
        drawWall.setPreferredSize(new Dimension(100, 20));
        drawWall.addActionListener(e -> {
            simulationPanel.swapDrawingWall();
            update();
        });
        isDrawing = new JLabel("Is drawing? " + simulationPanel.drawingWall);
        //----------------------------------------------------------------------
        skipEpoch.setPreferredSize(new Dimension(100, 20));
        skipEpoch.addActionListener(e -> {
            simulation.stepEpoch();
            update();
        });

        skip10Epochs.setPreferredSize(new Dimension(100, 20));
        skip10Epochs.addActionListener(e -> {
            for (int i = 0; i < 10; i++)
                simulation.stepEpoch();
            update();
        });

        drawCreature.setPreferredSize(new Dimension(100, 20));
        drawCreature.addActionListener(e -> {
            Creature creature = simulation.getCreatureAt(simulationPanel.selectedX, simulationPanel.selectedY);
            if (creature == null)
                return;

            try {
                printToFile(creature);
            } catch (IOException ex) {
                System.out.println("error when printing to brain.png: " + ex);
                ex.printStackTrace();
            }
        });


        JPanel controlsPanel = new JPanel();
        controlsPanel.setLayout(new BoxLayout(controlsPanel, BoxLayout.Y_AXIS));

        JPanel firstRow = new JPanel();
        firstRow.add(nextButton);
        firstRow.add(drawCreature);
        firstRow.add(epochButton);
        firstRow.add(start);
        firstRow.add(stop);
        firstRow.add(drawWall);

        JPanel secondRow = new JPanel();
        secondRow.add(isDrawing);
        secondRow.add(skipEpoch);
        secondRow.add(skip10Epochs);

        controlsPanel.add(firstRow);
        controlsPanel.add(secondRow);

        return controlsPanel;
    }

    private void update() {
        synchronized (lock) {
            simulationPanel.repaint();
            if (simulation.epochStats != null)
                epochStats.setText(simulation.epochStats.toString());
            isDrawing.setText("Is drawing? " + simulationPanel.drawingWall);
        }
    }

    private void printToFile(Creature creature) throws IOException {
        BrainRenderer renderer = new BrainRenderer();
        renderer.render(creature.brain, "output/brain.png");
        Desktop.getDesktop().open(new File("output/brain.png"));
    }
}
