package final_project;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class QueryExecutor {
    public static void executeQuery(String sqlQuery) {
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            System.out.println("Executing query: " + sqlQuery);
            ResultSet rs = stmt.executeQuery(sqlQuery);

            while (rs.next()) {
                System.out.println(rs.getString(1)); // Example to print first column
            }
        } catch (SQLException e) {
            System.err.println("Error executing query: " + e.getMessage());
        }
    }
}
