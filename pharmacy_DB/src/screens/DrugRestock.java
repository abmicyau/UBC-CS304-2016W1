package screens;

import main.Pharmacy_DB;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;

public class DrugRestock extends JPanel {

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

    private JPanel drugRestockConfirmation = new DrugRestockConfirmation();


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

        constraints.gridy = 6;
        add(buttonBack, constraints);

        // set border for the panel
        setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Drug Restock"));

        buttonBack.addActionListener(new BackButton());
        //buttonRestock.addActionListener(new RestockButton());

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
            Pharmacy_DB.switchScreen(drugRestockConfirmation);
        }
    }

    private class BackButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
        }
    }

    private class DrugRestockConfirmation extends JPanel {
        private JButton buttonBack = new JButton("Back");

        public DrugRestockConfirmation() {
            super(new GridBagLayout());
        }
    }

}
