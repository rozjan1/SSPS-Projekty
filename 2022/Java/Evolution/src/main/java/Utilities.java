public class Utilities {
    public static double map(double value, double origStart, double origEnd, double newStart, double newEnd) {
        return newStart + (newEnd - newStart) * ((value - origStart) / (origEnd - origStart));
    }

    public static boolean equals(double a, double b) {
        return Math.abs(a - b) <= 0.00002;
    }

    public static boolean getBitValAtPos(int number, int pos) {
        return (number & (1 << pos)) == 0;
    }
}
