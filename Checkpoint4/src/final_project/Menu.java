package final_project;

import java.util.LinkedHashMap;
import java.util.Scanner;

public class Menu {
    private LinkedHashMap<String, String> queries; // Key: SQL query, Value: Description

    public Menu(LinkedHashMap<String, String> queries) {
        this.queries = queries;
    }

    public void showMenu() {
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("Select a query to execute (or type 'exit' to quit):");
            int queryNumber = 1;
            for (String description : queries.values()) {
                System.out.println(queryNumber + ". " + description);
                queryNumber++;
            }

            String input = scanner.nextLine();

            if (input.equalsIgnoreCase("exit")) {
                System.out.println("Exiting the application. Goodbye!");
                break;
            }

            try {
                int selectedQuery = Integer.parseInt(input);
                if (selectedQuery >= 1 && selectedQuery <= queries.size()) {
                    String sqlQuery = (String) queries.keySet().toArray()[selectedQuery - 1];
                    System.out.println("Executing: " + queries.get(sqlQuery));
                    QueryExecutor.executeQuery(sqlQuery);

                    // Ask user if they want to run another query or exit
                    System.out.println("Do you want to run another query? (yes/no):");
                    String decision = scanner.nextLine().trim().toLowerCase();
                    if (decision.equals("no")) {
                        System.out.println("Exiting the application. Goodbye!");
                        break;
                    }
                } else {
                    System.out.println("Invalid selection. Please try again.");
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid input. Please enter a number.");
            }
        }

        scanner.close();
    }
}



