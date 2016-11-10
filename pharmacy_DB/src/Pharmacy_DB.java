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
    private JFrame mainFrame;
    private JLabel headerLabel;
    private JLabel statusLabel;
    private JPanel controlPanel;
    private JLabel msglabel;

    // Connection
    private Connection connection;

    // etc.
    private JLabel labelUsername = new JLabel("Enter username: ");
    private JLabel labelPassword = new JLabel("Enter password: ");
    private JTextField textUsername = new JTextField(20);
    private JPasswordField fieldPassword = new JPasswordField(20);
    private JButton buttonLogin = new JButton("Login");

    public Pharmacy_DB () {
        prepareGUI();
    }

    public static void main(String[] args) {
        Pharmacy_DB database = new Pharmacy_DB();
        database.start();
    }

    public void start() {
        showJPanel();
        connect();
        sampleQuery();
    }

    private void prepareGUI() {
        mainFrame = new JFrame("PharmSQL");
        mainFrame.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent windowEvent){
                System.exit(0);
            }
        });
        
        // create a new panel with GridBagLayout manager
        JPanel newPanel = new JPanel(new GridBagLayout());

        // set padding
        GridBagConstraints constraints = new GridBagConstraints();
        constraints.anchor = GridBagConstraints.WEST;
        constraints.insets = new Insets(10, 10, 10, 10);

        // add components to the panel
        constraints.gridx = 0;
        constraints.gridy = 0;
        newPanel.add(labelUsername, constraints);

        constraints.gridx = 1;
        newPanel.add(textUsername, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        newPanel.add(labelPassword, constraints);

        constraints.gridx = 1;
        newPanel.add(fieldPassword, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        newPanel.add(buttonLogin, constraints);

        // set border for the panel
        newPanel.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Login Panel"));

        // add the panel to this frame
        mainFrame.add(newPanel);

        mainFrame.pack();
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

    private void connect() {
        try {
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
            connection = DriverManager.getConnection(url, userid, password);
            System.out.println("Connected to Oracle Database");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

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
}
