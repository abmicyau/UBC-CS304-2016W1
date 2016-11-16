package screens;

import main.Pharmacy_DB;
//import sun.jvm.hotspot.types.JIntField;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;


public class CheckPrescription extends JPanel {

    private JLabel labelDID = new JLabel("Doctor ID: ");
    private JTextField textDID = new JTextField(8);
    private JLabel labelPID = new JLabel("Prescription ID: ");
    private JTextField textPID = new JTextField(8);
    private JButton searchButton = new JButton("Search");
    private JButton buttonBack = new JButton("Back");
    private JPanel messageContainer = new JPanel((new GridLayout(1,1)));
    private JLabel searchMessage = new JLabel("Searching...");
    private GridBagConstraints constraints = new GridBagConstraints();
    private DefaultTableModel model = new DefaultTableModel();
    private JTable table = new JTable(model);
    private JPanel left = new JPanel(new GridBagLayout());;
    private JPanel right = new JPanel(new BorderLayout());;

    public CheckPrescription() {
        super(new GridLayout());

        // set contraints and padding
        constraints.anchor = GridBagConstraints.WEST;
        constraints.insets = new Insets(10, 10, 10, 10);
        constraints.fill = GridBagConstraints.VERTICAL;
        constraints.weightx = 0;

        constraints.gridx = 0;
        add(left, constraints);

        constraints.fill = GridBagConstraints.HORIZONTAL;
        constraints.gridx = 1;
        constraints.weightx = 1;
        add(right, constraints);
        constraints.gridheight = 1;

        constraints.fill = GridBagConstraints.NONE;

        // add components to the panel
        constraints.gridx = 0;
        constraints.gridy = 0;
        left.add(labelPID, constraints);

        constraints.gridx = 1;
        constraints.gridy = 0;
        left.add(textPID, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        left.add(labelDID, constraints);

        constraints.gridx = 1;
        constraints.gridy = 1;
        left.add(textDID, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        left.add(searchButton, constraints);

        constraints.gridy = 3;
        left.add(buttonBack, constraints);

        constraints.gridx = 0;
        constraints.gridy = 4;
        constraints.gridwidth = 2;
        messageContainer.add(searchMessage);
        left.add(messageContainer, constraints);
        searchMessage.setVisible(false);

        model.addColumn("Customer ID");
        model.addColumn("Date Prescribed");
        model.addColumn("Dosage");
        model.addColumn("Duration");
        model.addColumn("Frequency");

        table.getColumnModel().getColumn(0).setPreferredWidth(100);
        table.getColumnModel().getColumn(1).setPreferredWidth(150);
        table.getColumnModel().getColumn(2).setPreferredWidth(150);
        table.getColumnModel().getColumn(3).setPreferredWidth(150);
        table.getColumnModel().getColumn(4).setPreferredWidth(200);

        table.setFillsViewportHeight(true);
        JScrollPane tableContainer = new JScrollPane(table);
        table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
        right.add(tableContainer, BorderLayout.CENTER);

        // set border for the panel
        left.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Search"));

        // set border for the panel
        right.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Prescriptions"));

        searchButton.addActionListener(new SearchButton());
        buttonBack.addActionListener(new BackButton());
    }

    private class BackButton implements ActionListener {
        public void actionPerformed(ActionEvent e) { Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel()); }
    }
    private class SearchButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            searchButton.setText("Searching...");
            searchButton.setVisible(true);
        }

    }

}
