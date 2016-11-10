import java.sql.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;


public class Pharmacy_DB {

    // Login info
    private String url = "jdbc:oracle:thin:@localhost:1522:ug";
    private String userid = "ora_i5n8";
    private String password = "a29789112";

    // JPanel Stuff
    private JFrame mainFrame = new JFrame("PharmSQL");;

    // Connection
    private Connection connection;

    // working area... categorize later
    private JPanel login = new JPanel(new GridBagLayout());;
    private JPanel newPanel2 = new JPanel(new GridBagLayout());;

    private JLabel labelUsername = new JLabel("Enter username: ");
    private JLabel labelPassword = new JLabel("Enter password: ");

    private JTextField textUsername = new JTextField(20);
    private JPasswordField fieldPassword = new JPasswordField(20);
    private JButton buttonLogin = new JButton("Login");

    // Constructor sets up all GUI components
    //
    public Pharmacy_DB () {
        prepareGUI();
    }

    // Main method creates new database application and starts it
    //
    public static void main(String[] args) {
        Pharmacy_DB database = new Pharmacy_DB();
        database.start();
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

        // set up the login window components
        setupLogin();

        // TODO: set up the main window components

        // set the initial frame to the login window
        mainFrame.setContentPane(login);
        // resize window accordingly
        mainFrame.pack();
        // make window appear in the middle of the screen
        mainFrame.setLocationRelativeTo(null);

        // testing button actions...
        buttonLogin.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                mainFrame.setContentPane(newPanel2);
                mainFrame.pack();
                mainFrame.invalidate();
                mainFrame.validate();
            }
        });
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

    // GUI setup for the login window
    //
    private void setupLogin() {
        // set padding
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
                BorderFactory.createEtchedBorder(), "Login Panel"));
    }
}
