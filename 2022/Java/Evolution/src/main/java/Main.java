import javax.swing.*;
import java.util.Scanner;


public class Main {
    private static SimulationFrame frame;

    public static void main(String[] args) throws InterruptedException {
        Scanner sc = new Scanner(System.in);
        Simulation simulation = new Simulation();
        simulation.prepareEpoch();
        simulation.creatures.get(0).getGenome();
        SwingUtilities.invokeLater(() -> frame = new SimulationFrame(simulation));
    }
}
