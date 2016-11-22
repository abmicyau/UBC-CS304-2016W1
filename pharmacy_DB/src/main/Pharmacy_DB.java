package main;

import models.DBScreen;
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
    private static DBScreen login;
    private static DBScreen home;
    private static DBScreen employeeLookup;
    private static DBScreen customerLookup;
    private static DBScreen doctorLookup;
    private static DBScreen drugLookup;
    private static DBScreen drugRestock;
    private static DBScreen checkPrescription;
    private static DBScreen recordDeletion;
    private static DBScreen recordAddition;
    private static DBScreen processPayment;
    private static DBScreen paymentRecordLookup;

    public static enum User {
        PHARMACIST, PHARMACY_ASSISTANT, PHARMACY_TECHNICIAN, OTHER
    }

    private static User user;

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
        recordAddition = new RecordAddition();
        processPayment = new ProcessPayment();
        paymentRecordLookup = new PaymentRecordLookup();
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

    public static void setUser(int id) throws SQLException {
        ResultSet rs0 = getResults("SELECT * FROM Pharmacist WHERE emp_id = " + id);
        ResultSet rs1 = getResults("SELECT * FROM Pharmacy_Assistant WHERE emp_id = " + id);
        ResultSet rs2 = getResults("SELECT * FROM Pharmacy_Technician WHERE emp_id = " + id);

        if (rs0.next()) {
            user = User.PHARMACIST;
        } else if (rs1.next()) {
            user = User.PHARMACY_ASSISTANT;
        } else if (rs2.next()) {
            user = User.PHARMACY_TECHNICIAN;
        } else {
            user = User.OTHER;
        }
    }

    // Gets a result set given a query
    // TODO: make this throw exception and fix all callers accordingly
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

    public static int getNextID(String tableName, String identifier) throws SQLException {
        ResultSet rs0 = getResults("SELECT MAX(" + identifier + ") id FROM " + tableName);

        if (rs0.next()) {
            if (rs0.getString("id") == null) {
                return 0;
            } else {
                return rs0.getInt("id") + 1;
            }
        } else {
            throw new SQLException();
        }
    }

    public static User getUser() { return user; }

    // SCREEN GETTERS
    //
    public static DBScreen getLoginPanel() { return login; }
    public static DBScreen getHomePanel() { return home; }
    public static DBScreen getEmployeeLookupPanel() { return employeeLookup; }
    public static DBScreen getCustomerLookup() { return customerLookup; }
    public static DBScreen getDoctorLookupPanel() { return doctorLookup; }
    public static DBScreen getDrugLookup() { return drugLookup; }
    public static DBScreen getDrugRestock() { return drugRestock; }
    public static DBScreen getCheckPrescriptionPanel() { return checkPrescription; }
    public static DBScreen getRecordAddition() { return recordAddition; }
    public static DBScreen getProcessPayment() { return processPayment; }
    public static DBScreen getPaymentRecordLookup() { return paymentRecordLookup; }
}
