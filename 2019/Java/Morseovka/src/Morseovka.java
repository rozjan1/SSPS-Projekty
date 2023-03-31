import java.util.Scanner;

public class Morseovka {
    public static String[] morse = new String[]{
            ".-", "-...", "-.-.", "-..", ".", "..-.", "--.", "....", "..", ".---", "-.-", ".-..", "--", "-.",
            "---", ".--.", "--.-", ".-.", "...", "-", "..-", "...-", ".--", "-..-", "-.--", "--..", ""
    };

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int vs;
        System.out.println("Chcete encodit nebo decodit? 1 = Encodit, 2 = Decodit");
        vs = scanner.nextInt();
        scanner.nextLine();
        String vstup;
        if (vs == 1) {
            System.out.println("Napiste neco co chcete mit v morseove abecede");
            vstup = scanner.nextLine();
            System.out.println(toMorse(vstup));
        } else if (vs == 2) {
            System.out.println("Napiste neco v morseove abecede");
            vstup = scanner.nextLine();
            System.out.println(fromMorse(vstup));
        } else {
            System.err.println("Only 1 or 2 accepted.");
        }
    }

    public static String fromMorse(String veta) {
        // Vezmeme kazde pismenko z vety
        // Zavolame prevedPismeno

        // .- -... -.-.  -.. -> abc d

        String vysledek = "";

        String[] split = veta.split(" ");

        for (int i = 0; i < split.length; i++) {
            String pismeno = split[i];
            char normalniPismeno = zMorseovky(pismeno);
            vysledek += normalniPismeno;
        }

        return vysledek;
    }

    private static char zMorseovky(String pismeno) {
        for (int i = 0; i < morse.length; i++) {
            String curr = morse[i];
            if (curr.equals(pismeno)) {
                String abeceda = "abcdefghijklmnopqrstuvwxyz ";
                return abeceda.charAt(i);
            }
        }
        return '?';
    }

    public static String toMorse(String uzivatelovaVeta) {
        // Vezmeme kazde pismenko z vety
        // Zavolame funkci prevedPismeno
        String vysledek = "";
        int delka = uzivatelovaVeta.length();
        for (int i = 0; i < delka; i++) {
            // abc -> .- -... -.-.
            // ab bc -> .- -...  -... -.-.

            char pismeno = uzivatelovaVeta.charAt(i);
            String kodovanePismeno = prevedPismeno(pismeno);
            vysledek = vysledek + kodovanePismeno;

            if (delka - 1 != i) {
                vysledek = vysledek + " ";
            }
        }

        return vysledek;
    }

    public static String prevedPismeno(char b) {
        //Podle toho jake to je pismenko ho prevedeme na znaky
        int x = znakNaCislo(b);
        if (x == -1)
            return "";

        return morse[x];
    }

    public static int znakNaCislo(char b) {
        String abeceda = "abcdefghijklmnopqrstuvwxyz ";
        b = Character.toLowerCase(b);
        return abeceda.indexOf(b);
    }
}

