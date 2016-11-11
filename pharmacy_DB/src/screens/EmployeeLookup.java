package screens;

import main.Pharmacy_DB;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Vector;

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


        right.setLayout(new BorderLayout());
        DefaultTableModel model = new DefaultTableModel();
        JTable table = new JTable(model);
        model.addColumn("Name");
        model.addColumn("Email");
        model.addColumn("Phone");
        model.addColumn("Address");

        Pharmacy_DB.fill(model);

        table.setFillsViewportHeight(true);
        JScrollPane tableContainer = new JScrollPane(table);
        right.add(tableContainer, BorderLayout.CENTER);

        // set border for the panel
        left.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Login"));

        // set border for the panel
        right.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Login"));
    }

}
