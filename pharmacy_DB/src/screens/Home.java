package screens;

import main.Pharmacy_DB;
import models.DBScreen;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Home extends DBScreen {

    private JButton actionButton1 = new JButton("Process Payment");
    private JButton actionButton2 = new JButton("New Customer");
    private JButton actionButton5 = new JButton("Drugs");
    private JButton actionButton6 = new JButton("Customers");
    private JButton actionButton7 = new JButton("Employees");
    private JButton actionButton8 = new JButton("Doctors");
    private JButton actionButton10 = new JButton("Check Prescription");
    private JButton actionButton11 = new JButton("Purchase Records");
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
        middle.add(actionButton11, constraints);

        constraints.gridx = 0;
        constraints.gridy = 4;
        middle.add(buttonLogout, constraints);

        constraints.gridx = 0;
        constraints.gridy = 0;
        right.add(actionButton6, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        right.add(actionButton2, constraints);

        // set border for the panels
        left.setBorder(BorderFactory.createTitledBorder(BorderFactory.createEtchedBorder(), "Drugs"));
        middle.setBorder(BorderFactory.createTitledBorder(BorderFactory.createEtchedBorder(), "Employees"));
        right.setBorder(BorderFactory.createTitledBorder(BorderFactory.createEtchedBorder(), "Patients"));

        revalidate();
        repaint();
    }

    private void setVisibility() {

        // Process payment, lookup/restock drugs, lookup customers, logout
        actionButton1.setVisible(true);
        actionButton5.setVisible(true);
        actionButton6.setVisible(true);
        buttonLogout.setVisible(true);

        actionButton2.setVisible(false);
        actionButton7.setVisible(false);
        actionButton8.setVisible(false);
        actionButton10.setVisible(false);

        if (Pharmacy_DB.getUser() == Pharmacy_DB.User.PHARMACIST ||
                Pharmacy_DB.getUser() == Pharmacy_DB.User.PHARMACY_TECHNICIAN) {

            // Add customer/patient records, lookup doctors
            actionButton2.setVisible(true);
            actionButton8.setVisible(true);
            System.out.println("blah");
        }
        if (Pharmacy_DB.getUser() == Pharmacy_DB.User.PHARMACIST) {

            // Lookup employees, check prescriptions
            actionButton7.setVisible(true);
            actionButton10.setVisible(true);
        }
    }

    private void addActions() {
        // logout button action
        buttonLogout.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getLoginPanel());
            }
        });

        // process payment
        actionButton1.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getProcessPayment());
            }
        });

        // adds patient record
        actionButton2.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                Pharmacy_DB.switchScreen(Pharmacy_DB.getRecordAddition());
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
                Pharmacy_DB.getCustomerLookup().refresh();
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

        actionButton10.addActionListener((new ActionListener() {
            public void actionPerformed(ActionEvent e) { Pharmacy_DB.switchScreen(Pharmacy_DB.getCheckPrescriptionPanel()); }
        }));

        // purchase record lookup
        actionButton11.addActionListener((new ActionListener() {
            public void actionPerformed(ActionEvent e) { Pharmacy_DB.switchScreen(Pharmacy_DB.getPurchaseRecordLookup()); }
        }));
    }

    @Override
    public void refresh() {
        super.refresh();
        setVisibility();
    }
}
