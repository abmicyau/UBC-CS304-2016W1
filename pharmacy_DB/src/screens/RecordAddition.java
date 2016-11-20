package screens;

import main.Pharmacy_DB;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 * Created by Victor on 2016-11-16.
 */
public class RecordAddition extends JPanel{

    // Types of patients
    private JCheckBox checkPatient = new JCheckBox("On-going Patient");
    private JCheckBox checkInsurance = new JCheckBox("Register Insurance");

    private JLabel labelPatient = new JLabel("Patient Information");
    private JLabel labelCard = new JLabel("Service Card Number:");
    private JLabel labelAddress = new JLabel("Address:");
    private JLabel labelDOB = new JLabel("Date of birth (YYYY-MM-DD):");
    private JLabel labelGender = new JLabel("Gender (M/F):");

    private JTextField textCard = new JTextField(10);
    private JTextField textAddress = new JTextField(10);
    private JTextField textDOB = new JTextField(10);
    private JTextField textGender = new JTextField(10);

    // Customer info
    private JLabel labelCustomer = new JLabel("Customer Information");
    private JLabel labelID = new JLabel("ID:");
    private JLabel labelName = new JLabel("Name:");
    private JLabel labelPhone = new JLabel("Phone Number:");

    private JTextField textID = new JTextField(10);
    private JTextField textName = new JTextField(10);
    private JTextField textPhone = new JTextField(10);

    // Insurance info
    private JLabel labelInsurance = new JLabel("Insurance Information");
    private JLabel labelPolicy = new JLabel("Policy ID: ");
    private JLabel labelExpiry = new JLabel("Expiry Date (YYYY-MM-DD):");
    private JLabel labelMax = new JLabel("Max Allowance:");
    private JLabel labelCompany = new JLabel("Company:");

    private JTextField textPolicy = new JTextField(10);
    private JTextField textExpiry = new JTextField(10);
    private JTextField textMax = new JTextField(10);
    private JTextField textCompany = new JTextField(10);

    // Buttons
    private JButton buttonBack = new JButton("Back");
    private JButton buttonAdd = new JButton("Add");

    private JLabel additionMessage = new JLabel("");
    private GridBagConstraints constraints = new GridBagConstraints();

    //Left and right Panel containers
    private JPanel left = new JPanel(new GridBagLayout());
    private JPanel center = new JPanel(new GridBagLayout());
    private JPanel right = new JPanel(new GridBagLayout());

    public RecordAddition(){

        // important! call JPanel constructor and pass GridBagLayout
        super(new GridBagLayout());

        // set contraints and padding
        constraints.anchor = GridBagConstraints.WEST;
        constraints.insets = new Insets(10, 10, 10, 10);
        constraints.fill = GridBagConstraints.VERTICAL;
        constraints.weightx = 0.325;

        // Sets up panels
        constraints.gridx = 0;
        add(left, constraints);

        constraints.weightx = 0.35;
        constraints.gridx = 1;
        add(center, constraints);

        constraints.weightx = 0.325;
        constraints.gridx = 2;
        add(right,constraints);

        // Sets up left (customer info) panel;

        //General info
        constraints.gridx = 0;
        constraints.gridy = 0;
        left.add(labelCustomer, constraints);
        constraints.gridy++;
        left.add(labelID,constraints);
        constraints.gridy++;
        left.add(textID,constraints);
        constraints.gridy++;
        left.add(labelName,constraints);
        constraints.gridy++;
        left.add(textName,constraints);
        constraints.gridy++;
        left.add(labelPhone,constraints);
        constraints.gridy++;
        left.add(textPhone,constraints);
        constraints.gridy++;
        left.add(checkPatient,constraints);
        constraints.gridy++;
        left.add(checkInsurance,constraints);

        // Sets up buttons
        constraints.gridy++;
        constraints.gridwidth = 2;
        left.add(buttonAdd, constraints);

        constraints.gridy++;
        left.add(buttonBack, constraints);

<<<<<<< HEAD
        // Set visibilities
        center.setVisible(false);
        right.setVisible(false);

        // Sets up center(Patient info)
        constraints.gridx = 0;
        constraints.gridy = 0;
        center.add(labelPatient, constraints);
        constraints.gridy++;
        center.add(labelCard,constraints);
        constraints.gridy++;
        center.add(textCard,constraints);
        constraints.gridy++;
        center.add(labelAddress,constraints);
        constraints.gridy++;
        center.add(textAddress,constraints);
        constraints.gridy++;
        center.add(labelDOB,constraints);
        constraints.gridy++;
        center.add(textDOB,constraints);
        constraints.gridy++;
        center.add(labelGender,constraints);
        constraints.gridy++;
        center.add(textGender,constraints);

        // Sets up right (insurance info) panel
        constraints.gridx = 0;
        constraints.gridy = 0;
        right.add(labelInsurance, constraints);
        constraints.gridy++;
        right.add(labelPolicy,constraints);
        constraints.gridy++;
        right.add(textPolicy,constraints);
        constraints.gridy++;
        right.add(labelMax,constraints);
        constraints.gridy++;
        right.add(textMax,constraints);
        constraints.gridy++;
        right.add(labelCompany,constraints);
        constraints.gridy++;
        right.add(textCompany,constraints);
        constraints.gridy++;
        right.add(labelExpiry,constraints);
        constraints.gridy++;
        right.add(textExpiry,constraints);

        buttonAdd.addActionListener(new AddButton());
        buttonBack.addActionListener(new BackButton());
        checkPatient.addActionListener(new PatientCheck());
        checkInsurance.addActionListener(new InsuranceCheck());

    }

    private class PatientCheck implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            if (checkPatient.isSelected()) {
                center.setVisible(true);
            }
            else {
                center.setVisible(false);
            }
        }
    }

    private class InsuranceCheck implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            if (checkInsurance.isSelected()) {
                right.setVisible(true);
            }
            else {
                right.setVisible(false);
            }
        }
=======

        buttonBack.addActionListener(new BackButton());
        buttonAdd.addActionListener(new AddButton());
>>>>>>> 5eb332eef1943f2904f7ddc17291b64899222235
    }

    private class AddButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
<<<<<<< HEAD
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
=======

>>>>>>> 5eb332eef1943f2904f7ddc17291b64899222235
        }
    }

    private class BackButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
        }
    }

}
