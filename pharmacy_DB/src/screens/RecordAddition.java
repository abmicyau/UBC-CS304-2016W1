package screens;

import main.Pharmacy_DB;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;

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

    //private JTextField textID = new JTextField(10);
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
        //left.add(textID,constraints);
        //constraints.gridy++;
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
        constraints.gridy++;
        left.add(additionMessage,constraints);

        // Sets up buttons
        constraints.gridy++;
        constraints.gridwidth = 2;
        left.add(buttonAdd, constraints);

        constraints.gridy++;
        left.add(buttonBack, constraints);

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
    }

    private class AddButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            String query = "SELECT customer_id FROM CUSTOMER";
            String insertQuery;
            String valueQuery;
            ResultSet results = Pharmacy_DB.getResults(query);
            try {
                int ID = 0;
                int curr;
                while (results.next()) {
                    curr = results.getInt("customer_id");
                    if (curr != ID) {
                        break;
                    } else {
                        ID++
                    }
                }
                String name = textName.getText();
                String phone = textPhone.getText();
                insertQuery = "INSERT INTO Customer (customer_id";
                valueQuery = "VALUES (" + ID;
                if (!name.isEmpty()) {
                    insertQuery = insertQuery + ",name";
                    valueQuery = valueQuery + "," + name;
                }
                if (!phone.isEmpty()) {
                    insertQuery = insertQuery + ",phone_number";
                    valueQuery = valueQuery + "," + phone;
                }
                if (checkInsurance.isSelected()) {
                    String insertInsuranceQuery;
                    String valueInsuranceQuery;
                    String policy = textPolicy.getText();
                    String expDate = textExpiry.getText();
                    String max = textMax.getText();
                    String company = textCompany.getText();

                    insertInsuranceQuery ="INSERT INTO Insurance_coverage (";
                    valueInsuranceQuery = "VALUES (" + ID;

                    if (!policy.isEmpty()) {
                        insertInsuranceQuery = insertInsuranceQuery + "policy_id";
                        valueInsuranceQuery = valueInsuranceQuery + policy;
                        if (!expDate.isEmpty()) {
                            insertInsuranceQuery += ",expDate";
                            valueInsuranceQuery += "," + expDate;
                        }
                        if (!max.isEmpty()) {
                            insertInsuranceQuery += ",maxAllowance_cents";
                            valueInsuranceQuery += "," + max;
                        }
                        if (!company.isEmpty()) {
                            insertInsuranceQuery += ",company";
                            valueInsuranceQuery += "," + company;
                        }
                        insertInsuranceQuery += ")";
                        valueInsuranceQuery += ")";
                        String insuranceQuery = insertInsuranceQuery + " " + valueInsuranceQuery;
                        Pharmacy_DB.executeUpdate(insuranceQuery);
                    }
                    else {
                        additionMessage.setText("Please input a policy number!");
                        return;
                    }

                }

                insertQuery += ")";
                valueQuery += ")";
                query = insertQuery + " " + valueQuery;
                Pharmacy_DB.executeUpdate(query);

                if (checkPatient.isSelected()) {
                    String card = textCard.getText();
                    String address = textAddress.getText();
                    String DOB = textDOB.getText();

                    String insertPatientQuery = "INSERT INTO Patient (";
                    String valuePatientQuery = "VALUES (";
                    if (!card.isEmpty()) {
                        insertPatientQuery = insertPatientQuery + "care_card_number";
                        valuePatientQuery = valuePatientQuery + card;
                        if (!address.isEmpty()) {
                            insertPatientQuery += ",address";
                            valuePatientQuery += "," + address;
                        }
                        if (!DOB.isEmpty()) {
                            insertPatientQuery += ",birthdate";
                            valuePatientQuery += "," + DOB;
                        }
                        insertPatientQuery += ")";
                        valuePatientQuery += ")";
                        String patientQuery = insertPatientQuery + " " + valuePatientQuery;
                        Pharmacy_DB.executeUpdate(patientQuery);
                    }
                    else {
                        additionMessage.setText("Please input a care card number!");
                        return;
                    }
                }
            }
            catch (SQLException e){
                additionMessage.setText("An error occurred!");
                return;
            }
        }
    }

    private class BackButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
        }
    }

}
