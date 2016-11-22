package screens;

import main.Pharmacy_DB;
import models.DBScreen;

import javax.swing.*;
import javax.swing.border.Border;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Login extends DBScreen {

    private JLabel title = new JLabel("<html><b>Employee Login</b></html>");
    private JLabel labelUsername = new JLabel("Enter username: ");
    private JLabel labelPassword = new JLabel("Enter password: ");
    private JTextField textUsername = new JTextField(20);
    private JPasswordField fieldPassword = new JPasswordField(20);
    private JButton buttonLogin = new JButton("Login");

    private JLabel loginMsg = new JLabel(" ");

    // logo
    private ImageIcon logoIcon = new ImageIcon(getClass().getClassLoader().getResource("teambb.png"));

    private String fetchUserPass(String uname) {
        StringBuilder query = new StringBuilder();
        query.append("SELECT password FROM Employee WHERE username = ");
        query.append("'");
        query.append(uname);
        query.append("'");
        ResultSet rs = Pharmacy_DB.getResults(query.toString());
        String pw = null;

        try {
            while (rs.next()) {
                pw = rs.getString("PASSWORD");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pw;
    }

    // ???
    //
    private void allowedAccess(){
        String unionAllowedEmps = "(SELECT emp_id FROM Pharmacy_Assistant) " +
                "UNION (SELECT emp_id FROM Pharmacist) " +
                "UNION (SELECT emp_id FROM Pharmacy_Technician);";

    }

    public Login() {

        // important! call JPanel constructor and pass GridBagLayout
        super(new GridBagLayout());




        // set contraints and padding
        GridBagConstraints constraints = new GridBagConstraints();
        constraints.insets = new Insets(10, 10, 10, 10);

        // jpanels

        JPanel top = new JPanel(new GridBagLayout());
        JPanel mid = new JPanel(new GridBagLayout());
        //logo
        JLabel logoLabel = new JLabel(logoIcon);
        constraints.weighty = 0;
        constraints.gridy=0;
        add(top, constraints);
        top.add(logoLabel, constraints);

        constraints.weighty = 0;
        constraints.gridy=1;
        add(mid, constraints);

        constraints.gridx = 0;
        constraints.gridy = 0;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        mid.add(title, constraints);

        constraints.gridwidth = 1;
        constraints.anchor = GridBagConstraints.WEST;

        constraints.gridx = 0;
        constraints.gridy = 1;
        mid.add(labelUsername, constraints);

        constraints.gridx = 1;
        mid.add(textUsername, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        mid.add(labelPassword, constraints);

        constraints.gridx = 1;
        mid.add(fieldPassword, constraints);

        constraints.gridx = 0;
        constraints.gridy = 3;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        mid.add(buttonLogin, constraints);

        // set border for the panel
        setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Login"));

        constraints.gridx = 0;
        constraints.gridy = 5;
        mid.add(loginMsg, constraints);

        // login button action
        buttonLogin.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                String user = textUsername.getText();
                String pass = new String(fieldPassword.getPassword());

                if (pass.equals(fetchUserPass(user))) {
                    loginMsg.setVisible(false);

                    try {
                        ResultSet rs = Pharmacy_DB.getResults("SELECT * FROM Employee WHERE username = '" + user + "'");
                        if (rs.next()) {
                            Pharmacy_DB.setUser(rs.getInt("emp_id"));
                        } else {
                            throw new SQLException();
                        }
                    } catch (SQLException ex) {
                        ex.printStackTrace();
                    }
                    Pharmacy_DB.getHomePanel().refresh();
                    Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
                } else {
                    loginMsg.setText("Login failed. Invalid username/password.");
                    loginMsg.setVisible(true);
                }
            }
        });
    }

    public void refresh() {

    }

}
