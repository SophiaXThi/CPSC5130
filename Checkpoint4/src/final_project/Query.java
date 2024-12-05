package final_project;

public class Query {
    private final String description;
    private final String sql;

    public Query(String description, String sql) {
        this.description = description;
        this.sql = sql;
    }

    public String getDescription() {
        return description;
    }

    public String getSql() {
        return sql;
    }
}

