package main;

import screens.*;

import java.sql.*;
import java.awt.event.*;
import javax.swing.*;


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
    private static JPanel doctorLookup;
    private static JPanel drugLookup;
    private static JPanel drugRestock;

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
        doctorLookup = new DoctorLookup();
        drugLookup = new DrugLookup();
        drugRestock = new DrugRestock();
    }

    private static void initializeWindow() {

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

    public static int executeUpdate(String query) {
        try {
            Statement stmt = connection.createStatement();
            return stmt.executeUpdate(query);
        } catch (SQLException e) {
            return -1;
        }
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

    // SCREEN GETTERS
    //
    public static JPanel getLoginPanel() { return login; }
    public static JPanel getHomePanel() { return home; }
    public static JPanel getEmployeeLookupPanel() { return employeeLookup; }
    public static JPanel getDoctorLookupPanel() { return doctorLookup; }
    public static JPanel getDrugLookup() { return drugLookup; }
    public static JPanel getDrugRestock() { return drugRestock; }

}
