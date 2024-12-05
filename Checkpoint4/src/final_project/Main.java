package final_project;

import java.util.LinkedHashMap;

public class Main {
    public static void main(String[] args) {
        LinkedHashMap<String, String> queries = QueryLoader.loadQueriesWithDescriptions();
        Menu menu = new Menu(queries);
        menu.showMenu();
    }
}

