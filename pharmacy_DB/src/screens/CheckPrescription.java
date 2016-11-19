package screens;

import main.Pharmacy_DB;
import models.DBTableModel;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;


public class CheckPrescription extends JPanel {

    private JLabel labelDID = new JLabel("Doctor ID: ");
    private JTextField textDID = new JTextField(8);
    private JLabel labelPID = new JLabel("Prescription ID: ");
    private JTextField textPID = new JTextField(8);
    private JButton searchButton = new JButton("Search");
    private JButton buttonBack = new JButton("Back");
    private GridBagConstraints constraints = new GridBagConstraints();
    private DefaultTableModel model = new DefaultTableModel();
    private JTable table = new JTable(model);

    private JFrame warningFrame = new JFrame("Warning");

    private JPanel left = new JPanel(new GridBagLayout());
    private JPanel right = new JPanel(new BorderLayout());

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

        model.addColumn("Customer ID");
        model.addColumn("Doctor Name");
        model.addColumn("Doctor Phone Number");
        model.addColumn("Date Prescribed");
        model.addColumn("DIN");
        model.addColumn("Dosage");
        model.addColumn("Duration");
        model.addColumn("Frequency");

        table.getColumnModel().getColumn(0).setPreferredWidth(100);
        table.getColumnModel().getColumn(1).setPreferredWidth(100);
        table.getColumnModel().getColumn(2).setPreferredWidth(150);
        table.getColumnModel().getColumn(3).setPreferredWidth(100);
        table.getColumnModel().getColumn(4).setPreferredWidth(100);
        table.getColumnModel().getColumn(5).setPreferredWidth(100);
        table.getColumnModel().getColumn(6).setPreferredWidth(200);
        table.getColumnModel().getColumn(7).setPreferredWidth(200);

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

    private void fillTable(DefaultTableModel model, ResultSet rs) {
        model.setRowCount(0);
        if (rs != null) {
            try {
                while (rs.next()) {
                    int cid = rs.getInt("CUSTOMER_ID");
                    String dname = rs.getString("NAME");
                    String dphone = rs.getString("PHONE_NUMBER");
                    String dateprescribed = rs.getString("DATE_PRESCRIBED");
                    String din = rs.getString("DIN");
                    String dosage = rs.getString("DOSE");
                    String duration = rs.getString("DURATION");
                    String freq = rs.getString("FREQUENCY");
                    model.addRow(new Object[]{String.format("%08d", cid), dname, dphone, dateprescribed, din, dosage, duration, freq});
                }
            } catch (SQLException e) {

            }
        }
    }

    private class SearchButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            searchButton.setText("Searching...");

            if ((textPID.getText().length() == 0 || textDID.getText().length() == 0) ||
                    (textPID.getText().matches("[0-9]+") == false) || (textDID.getText().matches("[0-9]+") == false)) {
                JOptionPane.showMessageDialog(warningFrame, "Please enter a valid Doctor ID and/or Prescription ID.");
                searchButton.setText("Search");

            } else {
                SwingUtilities.invokeLater(new Runnable() {
                    @Override
                    public void run() {
                        StringBuilder query = new StringBuilder();
                        query.append("SELECT * FROM Prescription_item_has pi, Prescription_by_is_for pbf, Doctor do, " +
                                "Item_consistof_drug icd WHERE pi.prescription_id = pbf.prescription_id AND do.doctor_id=" +
                                "pbf.doctor_id AND pi.item_id = icd.item_id AND do.doctor_id=");
                        query.append(textDID.getText());
                        query.append(" AND pi.prescription_id=");
                        query.append(textPID.getText());
                        //print query to console
                        System.out.println(query.toString());

                        fillTable(model, Pharmacy_DB.getResults(query.toString()));

                        if (model.getRowCount() == 0) {
                            JOptionPane.showMessageDialog(warningFrame, "No such prescription exists in the database");
                        }

                        searchButton.setText("Search");

                        revalidate();
                        repaint();
                    }
                });
            }
        }

    }

}
