package final_project;

import java.sql.*;

public class Test {
    static Connection connection = null;

    public static void main(String[] args) throws SQLException, ClassNotFoundException {

        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/testing"; // connection string
        String username = "root"; // mysql username
        String password = "password"; // mysql password

        connection = DriverManager.getConnection(url, username, password);

        String test_query = "SELECT * FROM Patient";
        PreparedStatement preparedStatement = connection.prepareStatement(test_query);
        ResultSet resultSet = preparedStatement.executeQuery();
        while(resultSet.next()) {
            System.out.println(resultSet.getString("patient_id"));
        }

        // It works :D

    }
}
