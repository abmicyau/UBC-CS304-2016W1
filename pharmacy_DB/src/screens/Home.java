package screens;

import main.Pharmacy_DB;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Home extends JPanel {

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

    public Home() {

        // important! call JPanel constructor and pass GridBagLayout
        super(new GridBagLayout());

        placeElements();
        addActions();
    }

    private void placeElements() {
        // set contraints and padding
        GridBagConstraints constraints = new GridBagConstraints();
        constraints.anchor = GridBagConstraints.WEST;
        constraints.fill = GridBagConstraints.HORIZONTAL;
        constraints.insets = new Insets(10, 10, 10, 10);

        constraints.gridx = 0;
        constraints.gridy = 0;
        add(actionButton1, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        add(actionButton2, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        add(actionButton3, constraints);

        constraints.gridx = 0;
        constraints.gridy = 3;
        add(actionButton4, constraints);

        constraints.gridx = 0;
        constraints.gridy = 4;
        add(actionButton10, constraints);

        constraints.gridx = 1;
        constraints.gridy = 0;
        add(actionButton5, constraints);

        constraints.gridx = 1;
        constraints.gridy = 1;
        add(actionButton6, constraints);

        constraints.gridx = 1;
        constraints.gridy = 2;
        add(actionButton7, constraints);

        constraints.gridx = 1;
        constraints.gridy = 3;
        add(actionButton8, constraints);

        constraints.gridx = 1;
        constraints.gridy = 4;
        add(actionButton9, constraints);

        constraints.gridx = 0;
        constraints.gridy = 5;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        add(buttonLogout, constraints);

        // set border for the panel
        setBorder(BorderFactory.createTitledBorder(BorderFactory.createEtchedBorder(), "Home"));
    }

    private void addActions() {
        // logout button action
        buttonLogout.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getLoginPanel());
            }
        });

        // drug lookup button action
        actionButton5.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getDrugLookup());
            }
        });

        // employee lookup button action
        actionButton7.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getEmployeeLookupPanel());
            }
        });
    }
}
