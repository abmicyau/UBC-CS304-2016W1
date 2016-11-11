package screens;

import main.Pharmacy_DB;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class EmployeeLookup extends JPanel {

    private JLabel labelUsername = new JLabel("Enter username: ");
    private JLabel labelPassword = new JLabel("Enter password: ");
    private JTextField textUsername = new JTextField(20);
    private JPasswordField fieldPassword = new JPasswordField(20);
    private JButton buttonLogin = new JButton("Login");

    private JPanel left;
    private JPanel right;

    public EmployeeLookup() {

        // important! call JPanel constructor and pass GridBagLayout
        super(new GridLayout(1, 2));

        left = new JPanel(new GridBagLayout());
        right = new JPanel(new GridBagLayout());

        add(left);
        add(right);

        // set contraints and padding
        GridBagConstraints constraints = new GridBagConstraints();
        constraints.anchor = GridBagConstraints.WEST;
        constraints.insets = new Insets(10, 10, 10, 10);

        // add components to the panel
        constraints.gridx = 0;
        constraints.gridy = 0;
        left.add(labelUsername, constraints);

        constraints.gridx = 1;
        left.add(textUsername, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        left.add(labelPassword, constraints);

        constraints.gridx = 1;
        left.add(fieldPassword, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        right.add(buttonLogin, constraints);

        // set border for the panel
        left.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Login"));

        // set border for the panel
        right.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Login"));

        // login button action
        buttonLogin.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.mainFrame.setContentPane(Pharmacy_DB.mainFrame.getHomePanel());
                Pharmacy_DB.mainFrame.invalidate();
                Pharmacy_DB.mainFrame.validate();
            }
        });
    }

}
