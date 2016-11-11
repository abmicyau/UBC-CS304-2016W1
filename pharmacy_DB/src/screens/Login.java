package screens;

import main.Pharmacy_DB;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Login extends JPanel {

    private JLabel title = new JLabel("Employee Login");
    private JLabel labelUsername = new JLabel("Enter username: ");
    private JLabel labelPassword = new JLabel("Enter password: ");
    private JTextField textUsername = new JTextField(20);
    private JPasswordField fieldPassword = new JPasswordField(20);
    private JButton buttonLogin = new JButton("Login");

    public Login() {

        // important! call JPanel constructor and pass GridBagLayout
        super(new GridBagLayout());

        // set contraints and padding
        GridBagConstraints constraints = new GridBagConstraints();
        constraints.insets = new Insets(10, 10, 10, 10);

        constraints.gridx = 0;
        constraints.gridy = 0;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        add(title, constraints);

        constraints.gridwidth = 1;
        constraints.anchor = GridBagConstraints.WEST;

        constraints.gridx = 0;
        constraints.gridy = 1;
        add(labelUsername, constraints);

        constraints.gridx = 1;
        add(textUsername, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        add(labelPassword, constraints);

        constraints.gridx = 1;
        add(fieldPassword, constraints);

        constraints.gridx = 0;
        constraints.gridy = 3;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        add(buttonLogin, constraints);

        // set border for the panel
        setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Login"));

        // login button action
        buttonLogin.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
            }
        });
    }

}
