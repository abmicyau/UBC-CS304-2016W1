package main;

import screens.*;

import javax.swing.*;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.sql.*;


public class Pharmacy_DB {

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
    private static JPanel customerLookup;
    private static JPanel doctorLookup;
    private static JPanel drugLookup;
    private static JPanel drugRestock;
    private static JPanel checkPrescription;
    private static JPanel recordDeletion;
    private static JPanel recordAddition;
    private static JPanel processPayment;

    // Main method creates new database application
    //
    public static void main(String[] args) {

        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        }
        catch (Exception e) {
            //
        }

        mainFrame = new JFrame("PharmSQL");

        connect();
        initializeScreens();
        initializeWindow();
    }

    private static void connect() {
        // Connect to Oracle
        try {
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
            connection = DriverManager.getConnection(url, userid, pass);
            System.out.println("Connected to Oracle Database");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static void initializeScreens() {
        login = new Login();
        home = new Home();
        employeeLookup = new EmployeeLookup();
        customerLookup = new CustomerLookup();
        doctorLookup = new DoctorLookup();
        drugLookup = new DrugLookup();
        drugRestock = new DrugRestock();
        checkPrescription = new CheckPrescription();
        recordDeletion = new RecordDeletion();
        recordAddition = new RecordAddition();
        processPayment = new ProcessPayment();
    }

    private static void initializeWindow() {

        mainFrame.setSize(1024, 768);
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

        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                mainFrame.setIconImage(
                        (Toolkit.getDefaultToolkit().getImage(getClass()
                                .getClassLoader().getResource("Pill-512.png"))));
                mainFrame.setVisible(true);
            }
        });
    }


    // Switches the current panel to the specified one
    //
    public static void switchScreen(JPanel panel) {
        mainFrame.setContentPane(panel);
        mainFrame.revalidate();
        mainFrame.repaint();
    }

    // Gets a result set given a query
    //
    public static ResultSet getResults(String query) {
        try {
            Statement stmt = connection.createStatement();
            return stmt.executeQuery(query);
        }
        catch (SQLException e) {
            return null;
        }
    }

    public static int executeUpdate(String query) throws SQLException {
        Statement stmt = connection.createStatement();
        return stmt.executeUpdate(query);
    }

    // yolo method for checking integers
    //
    public static boolean isInteger(String s) {
        try {
            Integer.parseInt(s);
        } catch(Exception e) {
            return false;
        }
        return true;
    }

    public static boolean isNumeric(String s) {
        for (char c : s.toCharArray())
        {
            if (!Character.isDigit(c)) return false;
        }
        return true;
    }

    public static int currencyToCents(String s) {
        String s2 = s.replace("$", "");
        s2 = s2.replace(".", "");
        return Integer.parseInt(s2);
    }

    // SCREEN GETTERS
    //
    public static JPanel getLoginPanel() { return login; }
    public static JPanel getHomePanel() { return home; }
    public static JPanel getEmployeeLookupPanel() { return employeeLookup; }
    public static JPanel getCustomerLookup() { return customerLookup; }
    public static JPanel getDoctorLookupPanel() { return doctorLookup; }
    public static JPanel getDrugLookup() { return drugLookup; }
    public static JPanel getDrugRestock() { return drugRestock; }
    public static JPanel getCheckPrescriptionPanel() { return checkPrescription; }
    public static JPanel getRecordDeletion() { return recordDeletion; }
    public static JPanel getRecordAddition() { return recordAddition; }
    public static JPanel getProcessPayment() { return processPayment; }

}
