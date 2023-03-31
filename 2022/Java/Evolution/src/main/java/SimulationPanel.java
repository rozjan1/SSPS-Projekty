import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;


public class SimulationPanel extends JPanel {

    private Simulation simulation;
    public static final int SIZE = 600;
    private final int CELL_SIZE;
    public int selectedX, selectedY;
    public boolean drawingWall = false;

    private int[] dragging = null;

    public SimulationPanel(Simulation simulation) {
        this.simulation = simulation;

        CELL_SIZE = SIZE / simulation.grid.getSize();

        setBorder(BorderFactory.createLineBorder(Color.black));

        addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                selectedX = e.getX() / CELL_SIZE;
                selectedY = e.getY() / CELL_SIZE;

                if (drawingWall) {
                    if (dragging != null) {
                        fillWithWall(dragging, new int[]{selectedX, selectedY});
                        dragging = null;
                    } else {
                        dragging = new int[]{selectedX, selectedY};
                    }
                }

                repaint();
            }
        });
    }

    private void fillWithWall(int[] from, int[] to) {
        int x1 = Math.min(from[0], to[0]);
        int y1 = Math.min(from[1], to[1]);
        int x2 = Math.max(from[0], to[0]);
        int y2 = Math.max(from[1], to[1]);

        for (int x = x1; x <= x2; x++) {
            for (int y = y1; y <= y2; y++) {
                simulation.grid.cells[x][y].type = CellType.Wall;
            }
        }
    }

    public Dimension getPreferredSize() {
        return new Dimension(SIZE, SIZE);
    }

    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        int size = simulation.grid.getSize();
        for (int y = 0; y < size; y++) {
            for (int x = 0; x < size; x++) {
                char color = simulation.whatToPrint(x, y);
                if (color == '█') {
                    g.setColor(Color.black);
                } else if (color == '_') {
                    g.setColor(Color.white);
                } else if (color == '.') {
                    Color c = transitionOfHueRange(1.0, 220, 221);
                    c = new Color(c.getRed(), c.getGreen(), c.getBlue(), 128);
                    g.setColor(c);
                } else {
                    char ch = simulation.creatures.get(simulation.creatures.size() - 1).getId();
                    g.setColor(transitionOfHueRange(Utilities.map(color, 'a', ch, 0, 1), 0, 180));
                }

                Dimension windowSize = this.getSize();

                int drawingSize = Math.min(windowSize.width, windowSize.height) / size;
                if (color == '.')
                    g.fillOval(x * drawingSize, y * drawingSize, drawingSize, drawingSize);
                else
                    g.fillRect(x * drawingSize, y * drawingSize, drawingSize, drawingSize);
                g.setColor(new Color(0, 0, 0, 50));
                g.drawRect(x * drawingSize, y * drawingSize, drawingSize, drawingSize);
            }
        }

        g.drawOval(selectedX * CELL_SIZE, selectedY * CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }

    private static Color transitionOfHueRange(double percentage, int startHue, int endHue) {
        // Mapu z [0°, 360°] -> [0, 1.0] delenim
        double hue = ((percentage * (endHue - startHue)) + startHue) / 360;

        double saturation = 1.0;
        double lightness = 0.5;

        // Vratime barvu
        return hslColorToRgb(hue, saturation, lightness);
    }

    private static Color hslColorToRgb(double hue, double saturation, double lightness) {
        if (saturation == 0.0) {
            // Pokud nema barvu, bude seda
            int grey = percToColor(lightness);
            return new Color(grey, grey, grey);
        }

        double q;
        if (lightness < 0.5) {
            q = lightness * (1 + saturation);
        } else {
            q = lightness + saturation - lightness * saturation;
        }
        double p = 2 * lightness - q;

        double oneThird = 1.0 / 3;
        int red = percToColor(hueToRgb(p, q, hue + oneThird));
        int green = percToColor(hueToRgb(p, q, hue));
        int blue = percToColor(hueToRgb(p, q, hue - oneThird));
        return new Color(red, green, blue);
    }

    private static double hueToRgb(double p, double q, double t) {
        if (t < 0) {
            t += 1;
        }
        if (t > 1) {
            t -= 1;
        }

        if (t < 1.0 / 6) {
            return p + (q - p) * 6 * t;
        }
        if (t < 1.0 / 2) {
            return q;
        }
        if (t < 2.0 / 3) {
            return p + (q - p) * (2.0 / 3 - t) * 6;
        }
        return p;
    }

    private static int percToColor(double percentage) {
        return (int) Math.round(percentage * 255);
    }

    public void swapDrawingWall() {
        drawingWall = !drawingWall;
    }
}
