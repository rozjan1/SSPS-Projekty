import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;

public class EpochStats {
    private static final int EPOCH_CAPACITY = 10;

    public int haveEaten;
    public Queue<Double> lastSurvivalRates = new LinkedList<>();
    public Queue<Double> genomeVariabilities = new LinkedList<>();
    public int epoch;

    public EpochStats(EpochStats other, int epoch) {
        if (other == null)
            return;

        this.epoch = epoch;
        lastSurvivalRates = new LinkedList<>(other.lastSurvivalRates);
        genomeVariabilities = new LinkedList<>(other.genomeVariabilities);
    }

    public void calculateGenomeVariability(ArrayList<Creature> creatures) {
        double genomeVariability = getGenomeVariability(creatures);

        genomeVariabilities.add(genomeVariability);
        while(genomeVariabilities.size() > EPOCH_CAPACITY)
            genomeVariabilities.poll();
    }

    private double getGenomeVariability(ArrayList<Creature> creatures) {
        if (creatures.size() == 0)
            return 0;

        double[][] averages = new double[creatures.get(0).getGenome().length][32];
        for (Creature creature : creatures) {
            int[] genome = creature.getGenome();
            for (int i = 0; i < genome.length; i++) {
                for (int pos = 0; pos<32; pos++) {
                    boolean value = Utilities.getBitValAtPos(genome[i], pos);
                    averages[i][pos] += value ? 1 : 0;
                }
            }
        }

        // Spocitame prumer ze sumy
        for (double[] gene : averages) {
            for (int i = 0; i < gene.length; i++) {
                gene[i] = gene[i] / creatures.size();
            }
        }

        // Spocitame variance
        double variance = 0;
        for (Creature creature : creatures) {
            int[] genome = creature.getGenome();
            for (int i = 0; i < genome.length; i++) {
                for (int pos = 0; pos<32; pos++) {
                    boolean value = Utilities.getBitValAtPos(genome[i], pos);
                    variance += Math.pow(((value ? 1 : 0) - averages[i][pos]), 2);
                }
            }
        }

        // Neni vzdy spravne

        return Math.sqrt(variance);
    }

    public void setSurvivalRate(double survivalRate) {
        lastSurvivalRates.add(survivalRate);
        while(lastSurvivalRates.size() > EPOCH_CAPACITY)
            lastSurvivalRates.poll();
    }

    public double getSurvivalRate() {
        return lastSurvivalRates.toArray(new Double[0])[lastSurvivalRates.size() - 1];
    }

    public double getSurvivalAverage() {
        double sum = 0;
        for (Double lastSurvivalRate : lastSurvivalRates)
            sum += lastSurvivalRate;

        if (lastSurvivalRates.size() <= 0)
            return sum;

        return sum / lastSurvivalRates.size();
    }

    public double getGenomeVariabilityAverage() {
        double sum = 0;
        for (Double lastSurvivalRate : genomeVariabilities)
            sum += lastSurvivalRate;

        if (genomeVariabilities.size() <= 0)
            return sum;

        return sum / genomeVariabilities.size();
    }

    public double getGenomeVariability() {
        return genomeVariabilities.toArray(new Double[0])[genomeVariabilities.size() - 1];
    }

    public int getEpoch() {
        return epoch;
    }

    @Override
    public String toString() {
        return String.format("Survival: %.2f/%.2f, Satiated: %d, Genome Variability: %.2f/%.2f, Current Epoch: %d",
                getSurvivalRate(), getSurvivalAverage(), haveEaten, getGenomeVariability(), getGenomeVariabilityAverage(),
                getEpoch());
    }
}
