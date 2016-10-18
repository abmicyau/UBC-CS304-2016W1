import java.sql.*;

public class Pharmacy_DB {

    public static void main(String[] args) {
	// write your code here
        try {
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
            Connection con = DriverManager.getConnection(
                    "jdbc:oracle:thin:@localhost:1522:ug", "ora_y3v9a", "a33732132");
            System.out.println("Connected to Oracle Database");
            Statement stmt = con.createStatement();
        }
        catch (SQLException e) {
            System.err.println("Connection Failed");
        }
    }
}
