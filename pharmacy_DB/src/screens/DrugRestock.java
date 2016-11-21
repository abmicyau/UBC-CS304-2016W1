package screens;

import main.Pharmacy_DB;
import models.DBScreen;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DrugRestock extends DBScreen {
    // todo : integrate this with druglookup

    private JLabel restockType = new JLabel("Product type:");

    private JLabel labelAmount = new JLabel("Amount: ");
    private JLabel labelDIN = new JLabel("DIN: ");
    private JLabel units = new JLabel("units");
    private JTextField textAmount = new JTextField(6);
    private JTextField textDIN = new JTextField(6);

    private JRadioButton otcRadio = new JRadioButton("Over the counter");
    private JRadioButton stockRadio = new JRadioButton("Stock");
    private ButtonGroup radioGroup = new ButtonGroup();

    private JButton buttonRestock = new JButton("Restock");
    private JButton buttonBack = new JButton("Back");

    private JLabel restockMessage = new JLabel("");

    private GridBagConstraints constraints = new GridBagConstraints();

    public DrugRestock() {

        super(new GridBagLayout());

        radioGroup.add(otcRadio);
        radioGroup.add(stockRadio);
        otcRadio.setSelected(true);

        // set contraints and padding
        GridBagConstraints constraints = new GridBagConstraints();
        constraints.insets = new Insets(10, 10, 5, 10);

        constraints.gridx = 0;
        constraints.gridy = 0;
        constraints.anchor = GridBagConstraints.WEST;
        constraints.gridwidth = 3;
        add(restockType, constraints);

        constraints.insets.set(1, 10, 1, 10);
        constraints.gridy = 1;
        add(otcRadio, constraints);

        constraints.insets.set(1, 10, 5, 10);
        constraints.gridy = 2;
        add(stockRadio, constraints);

        constraints.gridwidth = 1;
        constraints.insets.set(10, 10, 1, 10);
        constraints.gridx = 0;
        constraints.gridy = 3;
        add(labelDIN, constraints);

        constraints.gridx = 1;
        add(textDIN, constraints);

        constraints.gridx = 0;
        constraints.gridy = 4;
        add(labelAmount, constraints);

        constraints.gridx = 1;
        add(textAmount, constraints);

        constraints.gridx = 2;
        add(units, constraints);
        units.setPreferredSize(new Dimension(100, 30));

        constraints.insets.set(15, 10, 15, 10);
        constraints.gridwidth = 2;
        constraints.gridx = 0;
        constraints.gridy = 5;
        add(buttonRestock, constraints);

        constraints.gridwidth = 3;
        constraints.gridy = 6;
        add(restockMessage, constraints);
        restockMessage.setPreferredSize(new Dimension(200, 30));

        constraints.gridwidth = 2;
        constraints.gridy = 7;
        add(buttonBack, constraints);

        // set border for the panel
        setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Drug Restock"));

        buttonBack.addActionListener(new BackButton());
        buttonRestock.addActionListener(new RestockButton());

        otcRadio.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                units.setText("units");
            }
        });

        stockRadio.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                units.setText("mg");
            }
        });

    }

    private class RestockButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            String din = textDIN.getText().trim();
            String amount = textAmount.getText().trim();

            // error handling
            //
            if (din.isEmpty()) {
                restockMessage.setText("You must enter a DIN!");
            } else if (amount.isEmpty()) {
                restockMessage.setText("You must enter an amount!");
            } else if (!Pharmacy_DB.isInteger(din)) {
                restockMessage.setText("DIN must be an integer.");
            } else if (!Pharmacy_DB.isInteger(amount)) {
                restockMessage.setText("Amount must be an integer.");
            } else {
                Pharmacy_DB.switchScreen(new DrugRestockConfirmation(din, amount));
            }

        }
    }

    private class BackButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
        }
    }

    private class DrugRestockConfirmation extends JPanel {
        private JButton buttonBack = new JButton("Back");
        private JButton buttonConfirm = new JButton("Confirm");
        private JLabel confirmMessage = new JLabel("");
        private String updateQuery = "";

        public DrugRestockConfirmation(String din, String amount) {
            super(new GridBagLayout());

            GridBagConstraints constraints = new GridBagConstraints();
            constraints.insets = new Insets(10, 10, 10, 10);
            constraints.gridx = 0;
            constraints.gridy = 0;
            add(confirmMessage, constraints);

            StringBuilder query = new StringBuilder();
            query.append("SELECT * FROM Drug d, ");
            if (otcRadio.isSelected()) {
                query.append("Over_the_counter_drug x ");
            } else {
                query.append("Stock_drug x ");
            }
            query.append("WHERE d.DIN = x.DIN AND d.DIN = " + din);
            ResultSet results = Pharmacy_DB.getResults(query.toString());

            setBorder(BorderFactory.createTitledBorder(
                    BorderFactory.createEtchedBorder(), "Drug Restock"));

            try {
                if (results != null && results.next()) {
                    StringBuilder message = new StringBuilder();
                    confirmMessage.setText("Are you sure you want to restock " + amount + " " +
                            (otcRadio.isSelected() ? "units" : "mg") + " of:");
                    constraints.gridy = 1;
                    add(new JLabel(results.getString("drug_name_INN")), constraints);
                    constraints.gridy = 2;
                    add(buttonConfirm, constraints);
                    constraints.gridy = 3;
                    add(buttonBack, constraints);
                    updateQuery = "UPDATE " +
                                  (otcRadio.isSelected() ? "Over_the_counter_drug" : "Stock_drug") +
                                  " SET " +
                                  (otcRadio.isSelected() ? "quantity = quantity + " : "amount_mg = amount_mg + ") + amount +
                                  " WHERE DIN = " + din;
                } else {
                    confirmMessage.setText("DIN not found.");
                    constraints.gridy = 1;
                    add(buttonBack, constraints);
                }
            } catch (SQLException e) {
                confirmMessage.setText("DIN not found.");
                constraints.gridy = 1;
                add(buttonBack, constraints);
            }

            buttonBack.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    Pharmacy_DB.switchScreen(Pharmacy_DB.getDrugRestock());
                }
            });

            buttonConfirm.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    try {
                        if (Pharmacy_DB.executeUpdate(updateQuery) > 0) {
                            restockMessage.setText("Successfully restocked.");
                        } else {
                            restockMessage.setText("Item not found.");
                        }
                    } catch (SQLException ex) {
                        restockMessage.setText("Unexpected error.");
                    }

                    Pharmacy_DB.switchScreen(Pharmacy_DB.getDrugRestock());
                }
            });

        }
    }


}
