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
        mainFrame.setSize(1280, 720);
        mainFrame.setLayout(new GridLayout(3, 1));
        mainFrame.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent windowEvent){
                System.exit(0);
            }
        });
        headerLabel = new JLabel("", JLabel.CENTER);
        statusLabel = new JLabel("",JLabel.CENTER);

        statusLabel.setSize(350,100);

        msglabel = new JLabel("Begin", JLabel.CENTER);

        controlPanel = new JPanel();
        controlPanel.setLayout(new FlowLayout());

        mainFrame.add(headerLabel);
        mainFrame.add(controlPanel);
        mainFrame.add(statusLabel);
    }

    private void showJPanel() {
        headerLabel.setText("Welcome to the Breaking Bad Pharmacy Database");

        JPanel panel = new JPanel();
        panel.setBackground(Color.lightGray);
        panel.setLayout(new FlowLayout());
        panel.add(msglabel);

        controlPanel.add(panel);
        mainFrame.setVisible(true);
    }

    private void connect() {
        try {
            DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
            connection = DriverManager.getConnection(url, userid, password);
            System.out.println("Connected to Oracle Database");
        } catch (SQLException e) {
            System.err.println("Connection Failed");
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
