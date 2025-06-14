<%@page import="util.DatabaseUtil"%>
<%@page import="util.EnvConfig"%>
<%!
    // Database connection helper method
    public Connection getDbConnection() throws SQLException, ClassNotFoundException {
        return DatabaseUtil.getConnection();
    }
    
    // Close connection safely
    public void closeDbConnection(Connection conn) {
        DatabaseUtil.closeConnection(conn);
    }
%>
