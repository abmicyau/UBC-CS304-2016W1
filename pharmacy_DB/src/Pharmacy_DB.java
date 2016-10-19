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
            ResultSet rs = stmt.executeQuery("SELECT * FROM vaccination");

        	String service_id;
        	String vaccination_id;
        	String date_vaccinated;
        	String dose;
            
            while(rs.next()){
            	service_id = rs.getString("service_id");
            	vaccination_id = rs.getString("vaccination_id");
            	date_vaccinated = rs.getString("date_vaccinated");
            	dose = rs.getString("dose");
            	System.out.println("{" + service_id + ", " + vaccination_id + ", " + date_vaccinated + ", " + dose + "}");
            }
        }
        catch (SQLException e) {
            System.err.println("Connection Failed");
        }
    }
}
