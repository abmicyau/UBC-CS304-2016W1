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

    private JPanel left;
    private JPanel middle;
    private JPanel right;

    private GridBagConstraints constraints = new GridBagConstraints();

    public Home() {

        // important! call JPanel constructor and pass GridBagLayout
        super(new GridLayout(1, 3));

        placeElements();
        addActions();
    }

    private void placeElements() {

        left = new JPanel(new GridBagLayout());
        middle = new JPanel(new GridBagLayout());
        right = new JPanel(new GridBagLayout());

        add(left);
        add(middle);
        add(right);

        // set contraints and padding
        constraints.anchor = GridBagConstraints.WEST;
        constraints.insets = new Insets(10, 10, 10, 10);
        constraints.fill = GridBagConstraints.HORIZONTAL;
        constraints.weightx = 0;

        constraints.gridx = 0;
        constraints.gridy = 0;
        left.add(actionButton5, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        left.add(actionButton4, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        left.add(actionButton10, constraints);

        constraints.gridx = 0;
        constraints.gridy = 0;
        middle.add(actionButton7, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        middle.add(actionButton8, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        middle.add(actionButton1, constraints);

        constraints.gridx = 0;
        constraints.gridy = 3;
        middle.add(buttonLogout, constraints);

        constraints.gridx = 0;
        constraints.gridy = 0;
        right.add(actionButton6, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        right.add(actionButton2, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        right.add(actionButton3, constraints);

        constraints.gridx = 0;
        constraints.gridy = 3;
        right.add(actionButton9, constraints);

        // set border for the panels
        left.setBorder(BorderFactory.createTitledBorder(BorderFactory.createEtchedBorder(), "Drugs"));
        middle.setBorder(BorderFactory.createTitledBorder(BorderFactory.createEtchedBorder(), "Employees"));
        right.setBorder(BorderFactory.createTitledBorder(BorderFactory.createEtchedBorder(), "Patients"));

        revalidate();
        repaint();
    }

    private void addActions() {
        // logout button action
        buttonLogout.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getLoginPanel());
            }
        });

        // drug restock button action
        actionButton4.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getDrugRestock());
            }
        });

        // drug lookup button action
        actionButton5.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getDrugLookup());
            }
        });

        // record lookup button action
        actionButton6.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getCustomerLookup());
            }
        });

        // employee lookup button action
        actionButton7.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getEmployeeLookupPanel());
            }
        });

        // doctor lookup button action
        actionButton8.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getDoctorLookupPanel());
            }
        });
    }
}
