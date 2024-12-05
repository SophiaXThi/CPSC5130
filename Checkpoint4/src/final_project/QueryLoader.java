package final_project;

import java.io.*;
import java.nio.file.*;
import java.util.LinkedHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class QueryLoader {
    private static final String QUERY_FILE_PATH = "resources/sql/Checkpoint3.sql"; // Adjust the file path if needed

    public static LinkedHashMap<String, String> loadQueriesWithDescriptions() {
        LinkedHashMap<String, String> queryMap = new LinkedHashMap<>();
        try {
            String content = Files.readString(Paths.get(QUERY_FILE_PATH));

            // Regex to match descriptions and queries
            Pattern pattern = Pattern.compile("--\\s*Query\\s*(\\d+\\.\\d*):\\s*(.*?)\\n(.*?);", Pattern.DOTALL);
            Matcher matcher = pattern.matcher(content);

            while (matcher.find()) {
                String description = matcher.group(2).trim();
                String sqlQuery = matcher.group(3).trim();
                queryMap.put(sqlQuery, description);
            }
        } catch (IOException e) {
            System.err.println("Error loading queries from file: " + e.getMessage());
        }
        return queryMap;
    }
}


