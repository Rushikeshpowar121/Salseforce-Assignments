import java.util.*;

public class HospitalExpertSystem {

    static Scanner sc = new Scanner(System.in);

    static String[] departments = {
        "General Medicine",
        "Cardiology",
        "Neurology",
        "Gastroenterology"
    };

    static int[] scores = new int[4];

    static void ask(int dept, String question, int weight) {
        System.out.print(question + " (yes/no): ");
        if (sc.next().equalsIgnoreCase("yes")) {
            scores[dept] += weight;
        }
    }

    static void runAssessment() {

        System.out.println("\n--- General Medicine ---");
        ask(0, "Fever", 2);
        ask(0, "Cough", 2);
        ask(0, "Body Weakness", 1);

        System.out.println("\n--- Cardiology ---");
        ask(1, "Chest Pain", 5);
        ask(1, "Breathing Difficulty", 4);
        ask(1, "Uneven Heartbeat", 3);

        System.out.println("\n--- Neurology ---");
        ask(2, "Severe Headache", 3);
        ask(2, "Dizziness", 2);
        ask(2, "Memory Issues", 3);

        System.out.println("\n--- Gastroenterology ---");
        ask(3, "Stomach Pain", 4);
        ask(3, "Nausea", 2);
        ask(3, "Acidity", 4);
    }

    static void showResult() {

        int total = Arrays.stream(scores).sum();

        if (total == 0) {
            System.out.println("\nNo major symptom detected. Stay healthy!");
            return;
        }

        System.out.println("\n--- Results ---");

        int max = Arrays.stream(scores).max().getAsInt();

        System.out.println("Primary Department(s):");
        for (int i = 0; i < scores.length; i++) {
            if (scores[i] == max) {
                System.out.println("- " + departments[i]);
            }
        }

        System.out.println("\nConfidence Levels:");
        for (int i = 0; i < scores.length; i++) {
            double percent = (scores[i] * 100.0) / total;
            if (scores[i] > 0) {
                System.out.println(departments[i] + ": " + String.format("%.2f", percent) + "%");
            }
        }

        System.out.println("\nEmergency Check:");
        boolean emergency =
                scores[1] >= 8 ||
                scores[2] >= 6 ||
                scores[3] > 6 ||
                scores[0] > 4;

        if (scores[1] >= 8)
            System.out.println("Critical heart-related symptoms detected!");
        if (scores[2] >= 6)
            System.out.println("Serious neurological symptoms detected!");
        if (scores[3] > 6)
            System.out.println("Severe digestive symptoms detected!");
        if (scores[0] > 4)
            System.out.println("High fever/viral symptoms detected!");

        if (!emergency)
            System.out.println("No emergency symptoms detected.");

        System.out.println("\nAdvice:");
        System.out.println("- Rest well");
        System.out.println("- Drink fluids");
        System.out.println("- Consult a doctor if symptoms persist");
    }

    public static void main(String[] args) {
        System.out.println("---- Hospital Expert System ----");
        runAssessment();
        showResult();
        sc.close();
    }
}
