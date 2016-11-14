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

    private JButton buttonBack = new JButton("Back");
    private JLabel labelAmount = new JLabel("Amount: ");
    private JTextField textAmount = new JTextField(10);

    private GridBagConstraints constraints = new GridBagConstraints();

    public DrugRestock() {

        super(new GridBagLayout());

        // set contraints and padding
        GridBagConstraints constraints = new GridBagConstraints();
        constraints.insets = new Insets(10, 10, 10, 10);

        constraints.gridx = 0;
        constraints.gridy = 0;
        constraints.anchor = GridBagConstraints.CENTER;
        constraints.gridwidth = 3;
        add(buttonBack, constraints);

        constraints.gridwidth = 1;
        constraints.gridy = 1;
        constraints.anchor = GridBagConstraints.WEST;
        add(labelAmount, constraints);

        constraints.gridx = 1;
        add(textAmount, constraints);


        // set border for the panel
        setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Drug Restock"));

        buttonBack.addActionListener(new BackButton());

    }

    private class RestockButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {

        }
    }

    private class BackButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
        }
    }

}
