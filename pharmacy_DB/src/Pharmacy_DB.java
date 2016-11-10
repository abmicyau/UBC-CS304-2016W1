import java.sql.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;


public class Pharmacy_DB {

    // Login info (using Michael's for now)
    private String url = "jdbc:oracle:thin:@localhost:1522:ug";
    private String userid = "ora_i5n8";
    private String password = "a29789112";

    // Connection
    private Connection connection;

    // JPanel Stuff
    private JFrame mainFrame = new JFrame("PharmSQL");;

    // Login screen
    private JPanel login = new JPanel(new GridBagLayout());;
    private JLabel labelUsername = new JLabel("Enter username: ");
    private JLabel labelPassword = new JLabel("Enter password: ");
    private JTextField textUsername = new JTextField(20);
    private JPasswordField fieldPassword = new JPasswordField(20);
    private JButton buttonLogin = new JButton("Login");

    // Home screen
    private JPanel home = new JPanel(new GridBagLayout());;
    private JButton actionButton1 = new JButton("Process Payment");
    private JButton actionButton2 = new JButton("Add Record");
    private JButton actionButton3 = new JButton("Delete Record");
    private JButton actionButton4 = new JButton("Drug Restock");
    private JButton actionButton5 = new JButton("Drug Lookup");
    private JButton actionButton6 = new JButton("Record Lookup");
    private JButton actionButton7 = new JButton("Employee Lookup");
    private JButton actionButton8 = new JButton("Doctor Lookup");
    private JButton actionButton9 = new JButton("Insurance Lookup");
    private JButton actionButton10 = new JButton("Check Prescription");
    private JButton buttonLogout = new JButton("Logout");

    // Other screens...


    // Main method creates new database application and starts it
    //
    public static void main(String[] args) {
        Pharmacy_DB database = new Pharmacy_DB();
        database.start();
    }

    // Constructor sets up all GUI components
    //
    public Pharmacy_DB () {
        prepareGUI();
    }

    // Initializes the database application
    //
    public void start() {
        // add window listener to terminate process when window is closed
        mainFrame.addWindowListener(new WindowAdapter() {
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

    // prepares all the GUI components, calling GUI setup helpers
    //
    private void prepareGUI() {

        // set up the login screen components
        setupLogin();

        // set up the home screen components
        setupHome();

        // set the initial frame to the login window
        mainFrame.setContentPane(login);
        // resize window accordingly
        mainFrame.pack();
        // make window appear in the middle of the screen
        mainFrame.setLocationRelativeTo(null);
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
                mainFrame.setVisible(true);
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

    // GUI setup for the login screen
    //
    private void setupLogin() {
        // set contraints and padding
        GridBagConstraints constraints = new GridBagConstraints();
        constraints.anchor = GridBagConstraints.WEST;
        constraints.insets = new Insets(10, 10, 10, 10);

        // add components to the panel
        constraints.gridx = 0;
        constraints.gridy = 0;
        login.add(labelUsername, constraints);

        constraints.gridx = 1;
        login.add(textUsername, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        login.add(labelPassword, constraints);

        constraints.gridx = 1;
        login.add(fieldPassword, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        login.add(buttonLogin, constraints);

        // set border for the panel
        login.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Login"));

        // login button action
        buttonLogin.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                mainFrame.setContentPane(home);
                mainFrame.pack();
                mainFrame.invalidate();
                mainFrame.validate();
            }
        });
    }

    // GUI setup for the home screen
    //
    private void setupHome() {
        // set contraints and padding
        GridBagConstraints constraints = new GridBagConstraints();
        constraints.anchor = GridBagConstraints.WEST;
        constraints.insets = new Insets(10, 10, 10, 10);

        constraints.gridx = 0;
        constraints.gridy = 0;
        home.add(actionButton1, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        home.add(actionButton2, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        home.add(actionButton3, constraints);

        constraints.gridx = 0;
        constraints.gridy = 3;
        home.add(actionButton4, constraints);

        constraints.gridx = 0;
        constraints.gridy = 4;
        home.add(actionButton10, constraints);

        constraints.gridx = 1;
        constraints.gridy = 0;
        home.add(actionButton5, constraints);

        constraints.gridx = 1;
        constraints.gridy = 1;
        home.add(actionButton6, constraints);

        constraints.gridx = 1;
        constraints.gridy = 2;
        home.add(actionButton7, constraints);

        constraints.gridx = 1;
        constraints.gridy = 3;
        home.add(actionButton8, constraints);

        constraints.gridx = 1;
        constraints.gridy = 4;
        home.add(actionButton9, constraints);

        constraints.gridx = 0;
        constraints.gridy = 5;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        home.add(buttonLogout, constraints);

        // set border for the panel
        home.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Home"));

        // logout button action
        buttonLogout.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                mainFrame.setContentPane(login);
                mainFrame.pack();
                mainFrame.invalidate();
                mainFrame.validate();
            }
        });
    }

}
