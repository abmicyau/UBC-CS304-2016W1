package screens;

import main.Pharmacy_DB;
import models.DBScreen;
import models.DBTableModel;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.sql.ResultSet;
import java.sql.SQLException;

import static javax.swing.JOptionPane.YES_OPTION;

public class CheckPrescription extends DBScreen {

    private JLabel labelDID = new JLabel("Docto ID: ");
    private JTextField textDID = new JTextField(10);
    private JLabel labelPID = new JLabel("Customer ID: ");
    private JTextField textPID = new JTextField(10);
    private JButton buttonSearch = new JButton("Search");
    private JButton buttonBack = new JButton("Back");
    private JFrame warningFrame = new JFrame("Warning");
    private JPanel messageContainer = new JPanel(new GridLayout(1, 1));


    private GridBagConstraints constraints = new GridBagConstraints();

    DefaultTableModel model = new DBTableModel();
    JTable table = new JTable(model);

    private JPanel left = new JPanel(new GridBagLayout());
    ;
    private JPanel right = new JPanel(new BorderLayout());
    ;

    private JPopupMenu contextMenu = new JPopupMenu();


    public CheckPrescription() {

        // important! call JPanel constructor and pass GridBagLayout
        super(new GridBagLayout());

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
        left.add(labelDID, constraints);

        constraints.gridx = 1;
        left.add(textDID, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        left.add(labelPID, constraints);

        constraints.gridx = 1;
        left.add(textPID, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        left.add(buttonSearch, constraints);

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
                BorderFactory.createEtchedBorder(), "Prescription"));

        buttonSearch.addActionListener(new SearchButton());
        buttonBack.addActionListener(new BackButton());

        JMenuItem menuDelete = new JMenuItem("Delete");
        menuDelete.addActionListener(new DeleteButton());
        contextMenu.add(menuDelete);

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
                    int din = rs.getInt("DIN");
                    String dosage = rs.getString("DOSE");
                    String duration = rs.getString("DURATION");
                    String freq = rs.getString("FREQUENCY");
                    model.addRow(new Object[]{String.format("%08d", cid), dname, dphone, dateprescribed, String.format("%08d", din), dosage, duration, freq});
                }
            } catch (SQLException e) {
                // stop
            }
        }
    }

    private void update() {
        StringBuilder query = new StringBuilder();
        query.append("SELECT * FROM Prescription_item_has pi, Prescription_by_is_for pbf, Doctor do, " +
                "Item_consistof_drug icd WHERE pi.prescription_id = pbf.prescription_id AND do.doctor_id=" +
                "pbf.doctor_id AND pi.item_id = icd.item_id AND do.doctor_id=");
        query.append(textDID.getText());
        query.append(" AND pi.prescription_id=");
        query.append(textPID.getText());

        fillTable(model, Pharmacy_DB.getResults(query.toString()));

        if (model.getRowCount() == 0) {
            JOptionPane.showMessageDialog(warningFrame, "No such prescription exists in the database");
        }



        revalidate();
        repaint();
    }

    private class SearchButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {

            if ((textPID.getText().length() == 0 || textDID.getText().length() == 0) ||
                    (textPID.getText().matches("[0-9]+") == false) || (textDID.getText().matches("[0-9]+") == false)) {
                JOptionPane.showMessageDialog(warningFrame, "Please enter a valid Doctor ID and/or Prescription ID.");

            }
            SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run() {
                    update();
                }
            });
        }
    }

    private class BackButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
        }
    }

    private class DeleteButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {


        }
    }

    private class DetailsDialog extends JDialog implements ActionListener {

        private JPanel dialogPanel = new JPanel(new GridBagLayout());
        private JButton closeButton = new JButton("Close");

        // labels
        private JLabel label1 = new JLabel("<html><b>Basic Information</b></html>");
        private JLabel label1_1 = new JLabel("Employee ID: ");
        private JLabel label1_2 = new JLabel("Name: ");
        private JLabel label1_3 = new JLabel("Email: ");
        private JLabel label1_4 = new JLabel("Phone #: ");
        private JLabel label1_5 = new JLabel("Address: ");
        private JLabel label2 = new JLabel("<html><b>Additional Information</b></html>");
        private JLabel label2_1 = new JLabel("Position: ");
        private JLabel label2_2 = new JLabel("License #: ");

        // info
        private JLabel info1_1 = new JLabel("");
        private JLabel info1_2 = new JLabel("");
        private JLabel info1_3 = new JLabel("");
        private JLabel info1_4 = new JLabel("");
        private JLabel info1_5 = new JLabel("");
        private JLabel info2_1 = new JLabel("");
        private JLabel info2_2 = new JLabel("");

        public DetailsDialog() {

            setTitle("Employee Details");
            constraints.anchor = GridBagConstraints.WEST;
            // TOP, LEFT, BOTTOM, RIGHT
            constraints.insets = new Insets(10, 10, 5, 10);
            constraints.gridwidth = 2;

            constraints.gridx = 0;
            constraints.gridy = 0;
            dialogPanel.add(label1, constraints);

            constraints.gridwidth = 1;
            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 1;
            dialogPanel.add(label1_1, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info1_1, constraints);

            constraints.gridy = 2;
            constraints.gridx = 0;
            dialogPanel.add(label1_2, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info1_2, constraints);

            constraints.gridy = 3;
            constraints.gridx = 0;
            dialogPanel.add(label1_3, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info1_3, constraints);

            constraints.gridy = 4;
            constraints.gridx = 0;
            dialogPanel.add(label1_4, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info1_4, constraints);

            constraints.gridy = 5;
            constraints.gridx = 0;
            dialogPanel.add(label1_5, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info1_5, constraints);

            constraints.gridwidth = 2;
            constraints.insets.set(5, 10, 5, 10);
            constraints.gridx = 0;
            constraints.gridy = 6;
            dialogPanel.add(label2, constraints);

            constraints.gridwidth = 1;
            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 7;
            dialogPanel.add(label2_1, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info2_1, constraints);

            constraints.gridy = 8;
            constraints.gridx = 0;
            dialogPanel.add(label2_2, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info2_2, constraints);

            constraints.insets.set(15, 10, 10, 10);
            constraints.gridx = 0;
            constraints.gridy = 9;
            dialogPanel.add(closeButton, constraints);

            closeButton.addActionListener(this);

            setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
            setContentPane(dialogPanel);

        }


        public void actionPerformed(ActionEvent e) {
            dispose();
        }
    }

}
