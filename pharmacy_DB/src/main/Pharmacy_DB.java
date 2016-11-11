package main;

import screens.Home;
import screens.Login;

import java.sql.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;


public class Pharmacy_DB extends JFrame {

    // Single static database application instance
    //
    public static Pharmacy_DB mainFrame;

    // Login info (using Michael's for now)
    private String url = "jdbc:oracle:thin:@localhost:1522:ug";
    private String userid = "ora_i5n8";
    private String password = "a29789112";

    // Connection
    private Connection connection;

    // Screens
    private JPanel login;
    private JPanel home;

    // Main method creates new database application
    //
    public static void main(String[] args) {
        mainFrame = new Pharmacy_DB();
    }

    // Constructor sets up all GUI components
    //
    protected Pharmacy_DB () {
        super("PharmSQL"); // window label

        // Instantiate screens
        login = new Login();
        home = new Home();

        setSize(1280, 720);
        // make window appear in the middle of the screen
        setLocationRelativeTo(null);
        // set the initial frame to the login window
        setContentPane(login);

        // add window listener to terminate process when window is closed
        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent windowEvent){
                System.exit(0);
            }
        });

        // open the application window
        showJPanel();

        // connect to the database and perform a sample query, printing the results
        connect();
        sampleQuery();
    }

    private void showJPanel() {
        // set look and feel to the system look and feel
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                setVisible(true);
            }
        });
    }

    // Connects to the database
    //
    private void connect() {
        try {
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
            connection = DriverManager.getConnection(url, userid, password);
            System.out.println("Connected to Oracle Database");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Sample query code. Temporary...
    //
    private void sampleQuery() {
        try {
            Statement stmt = connection.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM Employee");

            while(rs.next()){
                System.out.println("{" +
                        rs.getString("name") + ", " +
                        rs.getString("email") + "}");
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Switches the current panel to the specified one
    //
    public void switchScreen(JPanel panel) {
        mainFrame.setContentPane(panel);
        mainFrame.invalidate();
        mainFrame.validate();
    }

    // SCREEN GETTERS
    //
    public JPanel getLoginPanel() { return login; }
    public JPanel getHomePanel() { return home; }

}
