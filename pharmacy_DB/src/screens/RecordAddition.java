package screens;

import main.Pharmacy_DB;
import models.DBScreen;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Created by Victor on 2016-11-16.
 */
public class RecordAddition extends DBScreen {


    // Types of patients
    private JCheckBox checkPatient = new JCheckBox("On-going Patient");
    private JCheckBox checkInsurance = new JCheckBox("Register Insurance");

    private JLabel labelPatient = new JLabel("Patient Information");
    private JLabel labelCard = new JLabel("Service Card Number (16 Digits):");
    private JLabel labelAddress = new JLabel("Address:");
    private JLabel labelDOB = new JLabel("Date of birth (YYYY-MM-DD):");
    private JLabel labelGender = new JLabel("Gender:");

    private JTextField textCard = new JTextField(10);
    private JTextField textAddress = new JTextField(10);
    //private JTextField textDOB = new JTextField(10);
    private JComboBox<Integer> year = new JComboBox<Integer>(new Integer[] {
            1910, 1911, 1912, 1913, 1914, 1915, 1916, 1917, 1918, 1919,
            1920, 1921, 1922, 1923, 1924, 1925, 1926, 1927, 1928, 1929,
            1930, 1931, 1932, 1933, 1934, 1935, 1936, 1937, 1938, 1939,
            1940, 1941, 1942, 1943, 1944, 1945, 1946, 1947, 1948, 1949,
            1950, 1951, 1952, 1953, 1954, 1955, 1956, 1957, 1958, 1959,
            1960, 1961, 1962, 1963, 1964, 1965, 1966, 1967, 1968, 1969,
            1970, 1971, 1972, 1973, 1974, 1975, 1976, 1977, 1978, 1979,
            1980, 1981, 1982, 1983, 1984, 1985, 1986, 1987, 1988, 1989,
            1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999,
            2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009,
            2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019,
            2020, 2021, 2022});
    private JComboBox<Integer> expiryYear = new JComboBox<Integer>(new Integer[] {
            2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025});
    private JComboBox<Integer> expiryMonth = new JComboBox<Integer>(new Integer[]
            {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12});
    private JComboBox<Integer> expiryDay = new JComboBox<Integer>(new Integer[]
            {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31});
    private JComboBox<Integer> month = new JComboBox<Integer>(new Integer[]
            {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12});
    private JComboBox<Integer> day = new JComboBox<Integer>(new Integer[]
            {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                    16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31});
    String[] genders = {"M","F"};
    private JComboBox comboGender = new JComboBox(genders);

    // Customer info
    private JLabel labelCustomer = new JLabel("Customer Information");
    private JLabel labelID = new JLabel("ID:");
    private JLabel labelName = new JLabel("Name:");
    private JLabel labelPhone = new JLabel("Phone Number (123-456-7890):");

    //private JTextField textID = new JTextField(10);
    private JTextField textName = new JTextField(10);
    private JTextField textPhone = new JTextField(10);

    // Insurance info
    private JLabel labelInsurance = new JLabel("Insurance Information");
    private JLabel labelPolicy = new JLabel("Policy ID (5 digits) : ");
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
        constraints.weightx = 0;
        left.add(labelCustomer, constraints);
        constraints.gridy++;
        //left.add(labelID,constraints);
        //constraints.gridy++;
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
        left.add(buttonAdd, constraints);

        constraints.gridy++;
        left.add(buttonBack, constraints);

        // Set visibilities
        center.setEnabled(false);
        textCard.setEnabled(false);
        textAddress.setEnabled(false);
        year.setEnabled(false);
        month.setEnabled(false);
        day.setEnabled(false);
        comboGender.setEnabled(false);
        right.setEnabled(false);
        textPolicy.setEnabled(false);
        expiryYear.setEnabled(false);
        expiryMonth.setEnabled(false);
        expiryDay.setEnabled(false);
        textMax.setEnabled(false);
        textCompany.setEnabled(false);

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
        center.add(year,constraints);
        constraints.gridx++;
        center.add(month,constraints);
        constraints.gridx++;
        center.add(day,constraints);
        constraints.gridx= 0;
        constraints.gridy++;
        center.add(labelGender,constraints);
        constraints.gridy++;
        center.add(comboGender,constraints);

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
        right.add(expiryYear,constraints);
        constraints.gridx++;
        right.add(expiryMonth,constraints);
        constraints.gridx++;
        right.add(expiryDay,constraints);

        buttonAdd.addActionListener(new AddButton());
        buttonBack.addActionListener(new BackButton());
        checkPatient.addActionListener(new PatientCheck());
        checkInsurance.addActionListener(new InsuranceCheck());

    }

    private class PatientCheck implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            if (checkPatient.isSelected()) {
                center.setEnabled(true);
                textCard.setEnabled(true);
                textAddress.setEnabled(true);
                year.setEnabled(true);
                month.setEnabled(true);
                day.setEnabled(true);
                comboGender.setEnabled(true);
            }
            else {
                center.setEnabled(false);
                textCard.setEnabled(false);
                textAddress.setEnabled(false);
                year.setEnabled(false);
                month.setEnabled(false);
                day.setEnabled(false);
                comboGender.setEnabled(false);
            }
        }
    }

    private class InsuranceCheck implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            if (checkInsurance.isSelected()) {
                right.setEnabled(true);
                textPolicy.setEnabled(true);
                expiryYear.setEnabled(true);
                expiryMonth.setEnabled(true);
                expiryDay.setEnabled(true);
                textMax.setEnabled(true);
                textCompany.setEnabled(true);
            }
            else {
                right.setEnabled(false);
                textPolicy.setEnabled(false);
                expiryYear.setEnabled(false);
                expiryMonth.setEnabled(false);
                expiryDay.setEnabled(false);
                textMax.setEnabled(false);
                textCompany.setEnabled(false);
            }
        }
    }

    private class AddButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            try {
            String query = "SELECT customer_id FROM Customer";
            String insertQuery;
            String valueQuery;
            ResultSet results = Pharmacy_DB.getResults(query);
                int ID = 0;
                int curr;
                while (results != null && results.next()) {
                    curr = results.getInt("customer_id");
                    if (curr != ID) {
                        break;
                    } else {
                        ID++;
                    }
                }

                String stringID = Integer.toString(ID);
                String name = textName.getText();
                String phone = textPhone.getText();
                insertQuery = "INSERT INTO Customer (customer_id";
                valueQuery = "VALUES (" + stringID;
                if (!name.isEmpty()) {
                    insertQuery = insertQuery + ",name";
                    valueQuery = valueQuery + "," + "'" + name +"'";
                }
                if (!phone.isEmpty()) {
                    insertQuery = insertQuery + ",phone_number";
                    valueQuery = valueQuery + "," + phone;
                }
                if (checkInsurance.isSelected()) {
                    String insertInsuranceQuery;
                    String valueInsuranceQuery;
                    String policy = textPolicy.getText();
                    String expDate = expiryYear.getSelectedItem() + "-" + expiryMonth.getSelectedItem() + "-" +expiryDay.getSelectedItem();
                    String max = textMax.getText();
                    String company = textCompany.getText();

                    insertInsuranceQuery ="INSERT INTO Insurance_coverage (";
                    valueInsuranceQuery = "VALUES (";

                    if (!policy.isEmpty()) {
                        insertQuery += ",insurance_policy_id";
                        valueQuery += ",'" + policy + "'";
                        insertInsuranceQuery += "policy_id";
                        valueInsuranceQuery += "'" + policy + "'";
                        if (!expDate.isEmpty()) {
                            insertInsuranceQuery += ",expDate";
                            valueInsuranceQuery += "," + "'" + expDate + "'";
                        }
                        if (!max.isEmpty()) {
                            insertInsuranceQuery += ",maxAllowance_cents";
                            valueInsuranceQuery += "," + max;
                        }
                        if (!company.isEmpty()) {
                            insertInsuranceQuery += ",company";
                            valueInsuranceQuery += "," + "'" + company + "'";
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
                    String DOB = year.getSelectedItem() + "-" + month.getSelectedItem() + "-" +day.getSelectedItem();
                    String gender = (String) comboGender.getSelectedItem();

                    String insertPatientQuery = "INSERT INTO Patient (";
                    String valuePatientQuery = "VALUES (";
                    if (!card.isEmpty()) {
                        insertPatientQuery = insertPatientQuery + "customer_id, care_card_number";
                        valuePatientQuery = valuePatientQuery + stringID +",'" + card + "'";
                        if (!address.isEmpty()) {
                            insertPatientQuery += ",address";
                            valuePatientQuery += "," + "'" +address + "'";
                        }
                        if (!DOB.isEmpty()) {
                            insertPatientQuery += ",birthdate";
                            valuePatientQuery += "," + "'" + DOB + "'";
                        }
                        if (!gender.isEmpty()) {
                            insertPatientQuery += ",gender";
                            valuePatientQuery += "," + "'" + gender + "'";
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
                additionMessage.setText("Add successful");
            }
            catch (SQLException ex){
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