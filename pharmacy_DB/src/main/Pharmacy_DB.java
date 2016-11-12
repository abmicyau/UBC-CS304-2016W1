package main;

import entities.Employee;
import screens.EmployeeLookup;
import screens.Home;
import screens.Login;

import java.sql.*;
import java.awt.event.*;
import java.util.ArrayList;
import java.util.Vector;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;


public class Pharmacy_DB extends JFrame {

    private static JFrame mainFrame;

    // Login info (using Michael's for now)
    private static String url = "jdbc:oracle:thin:@localhost:1522:ug";
    private static String userid = "ora_i5n8";
    private static String pass = "a29789112";

    // Connection
    private static Connection connection;

    // Screens
    private static JPanel login;
    private static JPanel home;
    private static JPanel employeeLookup;

    // Main method creates new database application
    //
    public static void main(String[] args) {
        mainFrame = new JFrame("PharmSQL");

        // Connect to Oracle
        try {
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
            connection = DriverManager.getConnection(url, userid, pass);
            System.out.println("Connected to Oracle Database");
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Instantiate screens
        login = new Login();
        home = new Home();
        employeeLookup = new EmployeeLookup();

        mainFrame.setSize(1280, 720);
        // make window appear in the middle of the screen
        mainFrame.setLocationRelativeTo(null);
        // set the initial frame to the login window
        mainFrame.setContentPane(login);

        // add window listener to terminate process when window is closed
        mainFrame.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent windowEvent){
                System.exit(0);
            }
        });

        // open the application window
        showJPanel();
    }

    private static void showJPanel() {
        // set look and feel to the system look and feel
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                mainFrame.setVisible(true);
            }
        });
    }

    // Switches the current panel to the specified one
    //
    public static void switchScreen(JPanel panel) {
        mainFrame.setContentPane(panel);
        mainFrame.revalidate();
    }

    public static void fill(DefaultTableModel model, String query) {

        model.setRowCount(0);

        try {
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while(rs.next()){
                int id = rs.getInt("emp_id");
                String email = rs.getString("email");
                String address = rs.getString("address");
                String name = rs.getString("name");
                String phone = rs.getString("phone_number");

                model.addRow(new Object[] {id, name, email, phone, address});
            }
        }
        catch (SQLException e) {
            // e.printStackTrace();
        }
    }

    // SCREEN GETTERS
    //
    public static JPanel getLoginPanel() { return login; }
    public static JPanel getHomePanel() { return home; }
    public static JPanel getEmployeeLookupPanel() { return employeeLookup; }

}
