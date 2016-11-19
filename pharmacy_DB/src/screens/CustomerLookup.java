package screens;

import main.Pharmacy_DB;
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
import java.text.ParseException;
import java.text.SimpleDateFormat;

import static javax.swing.JOptionPane.YES_OPTION;

public class CustomerLookup extends JPanel {

    private JLabel labelID = new JLabel("ID: ");
    private JTextField textID = new JTextField(10);
    private JLabel labelName = new JLabel("Name: ");
    private JTextField textName = new JTextField(10);
    private JLabel labelPolicyID = new JLabel("Policy ID: ");
    private JTextField textPolicyID = new JTextField(10);
    private JButton buttonSearch = new JButton("Search");
    private JButton buttonBack = new JButton("Back");

    private JPanel messageContainer = new JPanel(new GridLayout(1, 1));
    private JLabel searchMessage = new JLabel("Searching...");

    private GridBagConstraints constraints = new GridBagConstraints();

    DefaultTableModel model = new DBTableModel();
    JTable table = new JTable(model);

    private JPanel left = new JPanel(new GridBagLayout());;
    private JPanel right = new JPanel(new BorderLayout());;

    private SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd");

    private JPopupMenu contextMenu = new JPopupMenu();

    private DetailsDialog detailsDialog = new DetailsDialog();

    public CustomerLookup() {

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
        left.add(labelID, constraints);

        constraints.gridx = 1;
        left.add(textID, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        left.add(labelName, constraints);

        constraints.gridx = 1;
        left.add(textName, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        left.add(labelPolicyID, constraints);

        constraints.gridx = 1;
        left.add(textPolicyID, constraints);

        constraints.gridx = 0;
        constraints.gridy = 3;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        left.add(buttonSearch, constraints);

        constraints.gridy = 4;
        left.add(buttonBack, constraints);

        constraints.gridx = 0;
        constraints.gridy = 5;
        constraints.gridwidth = 2;
        messageContainer.add(searchMessage);
        left.add(messageContainer, constraints);
        searchMessage.setVisible(false);

        model.addColumn("ID");
        model.addColumn("Name");
        model.addColumn("Phone");
        model.addColumn("Policy ID");

        table.getColumnModel().getColumn(0).setPreferredWidth(200);
        table.getColumnModel().getColumn(1).setPreferredWidth(200);
        table.getColumnModel().getColumn(2).setPreferredWidth(200);
        table.getColumnModel().getColumn(3).setPreferredWidth(200);

        table.setFillsViewportHeight(true);
        JScrollPane tableContainer = new JScrollPane(table);
        table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
        right.add(tableContainer, BorderLayout.CENTER);

        // set border for the panel
        left.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Search"));

        // set border for the panel
        right.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Customers"));

        buttonSearch.addActionListener(new SearchButton());
        buttonBack.addActionListener(new BackButton());

        JMenuItem menuDetails = new JMenuItem("Details");
        menuDetails.addActionListener(new DetailsButton());
        contextMenu.add(menuDetails);

        JMenuItem menuDelete = new JMenuItem("Delete");
        menuDelete.addActionListener(new DeleteButton());
        contextMenu.add(menuDelete);

        table.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                int r = table.rowAtPoint(e.getPoint());
                if (r >= 0 && r < table.getRowCount()) {
                    table.setRowSelectionInterval(r, r);
                } else {
                    table.clearSelection();
                }

                int rowindex = table.getSelectedRow();
                if (rowindex < 0)
                    return;
                if (e.isPopupTrigger() && e.getComponent() instanceof JTable ) {
                    contextMenu.show(e.getComponent(), e.getX(), e.getY());
                }
            }
        });

        update();
    }

    private void fillTable(DefaultTableModel model, ResultSet rs) {
        model.setRowCount(0);
        if (rs != null) {
            try {
                while (rs.next()) {
                    int id = rs.getInt("customer_id");
                    String name = rs.getString("name");
                    String phone = rs.getString("phone_number");
                    int policy = rs.getInt("insurance_policy_id");

                    model.addRow(new Object[]{String.format("%08d", id), name, phone,
                            String.format("%08d", policy)});

                }
            } catch (SQLException e) {
                // stop
            }
        }
    }

    private void update() {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        query.append("SELECT * FROM Customer " +
                "WHERE LOWER(name) LIKE LOWER('%");
        query.append(textName.getText());
        query.append("%')");

        String id = textID.getText();
        String policyId = textPolicyID.getText();

        if (id.length() != 0) {
            query.append(" AND customer_id = ");
            query.append(id);
        }
        if (policyId.length() != 0) {
            query.append(" AND insurance_policy_id = ");
            query.append(policyId);
        }

        query.append(" ORDER BY customer_id");

        fillTable(model, Pharmacy_DB.getResults(query.toString()));

        message.append(model.getRowCount());
        message.append(" results found.");

        revalidate();
        repaint();
    }

    private void deleteCustomer(int id) throws SQLException {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        query.append("DELETE FROM Customer WHERE customer_id = ");
        query.append(id);

        Pharmacy_DB.executeUpdate(query.toString());

        update();

        revalidate();
        repaint();
    }

    private class SearchButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            searchMessage.setText("Searching...");
            searchMessage.setVisible(true);

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

    private class DetailsButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            String idString = table.getValueAt(table.getSelectedRow(), 0).toString();
            int id = Integer.parseInt(idString);

            try {
                detailsDialog.updateInfo(id);
                detailsDialog.pack();
                detailsDialog.setLocationRelativeTo(Pharmacy_DB.getCustomerLookup());
                detailsDialog.setVisible(true);
            } catch (SQLException ex) {
                // TODO: change this to a dialog
                System.out.println("Unexpected error");
            }
        }
    }

    private class DeleteButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            int n = JOptionPane.showConfirmDialog(
                    Pharmacy_DB.getEmployeeLookupPanel(),
                    "Are you sure you want to delete the following customer record?\n\n" +
                            "(" + table.getValueAt(table.getSelectedRow(), 0).toString() + ") " +
                            table.getValueAt(table.getSelectedRow(), 1).toString() + "\n\n",
                    "Delete Customer Record",
                    JOptionPane.YES_NO_OPTION);
            if (n == YES_OPTION) {
                try {
                    // check for result > 0???
                    deleteCustomer(Integer.parseInt(table.getValueAt(table.getSelectedRow(), 0).toString()));
                    JOptionPane.showMessageDialog(Pharmacy_DB.getEmployeeLookupPanel(),
                            "Customer record successfully deleted.",
                            "Delete Customer Record",
                            JOptionPane.PLAIN_MESSAGE);
                } catch (SQLException ex) {
                    JOptionPane.showMessageDialog(Pharmacy_DB.getEmployeeLookupPanel(),
                            "Unexpected error. Could not delete employee.",
                            "Delete Customer Record",
                            JOptionPane.ERROR_MESSAGE);
                }
            }
        }
    }

    private class DetailsDialog extends JDialog implements ActionListener {

        private JPanel dialogPanel = new JPanel(new GridBagLayout());
        private JButton closeButton = new JButton("Close");

        // labels
        private JLabel label1 = new JLabel("<html><b>Basic Information</b></html>");
        private JLabel label1_1 = new JLabel("Customer ID: ");
        private JLabel label1_2 = new JLabel("Name: ");
        private JLabel label1_3 = new JLabel("Phone #: ");
        private JLabel label2 = new JLabel("<html><b>Insurance</b></html>");
        private JLabel label2_1 = new JLabel("Policy ID: ");
        private JLabel label2_2 = new JLabel("Expiry Date: ");
        private JLabel label2_3 = new JLabel("Allowance: ");
        private JLabel label2_4 = new JLabel("Provider: ");
        private JLabel label3 = new JLabel("<html><b>Patient Record</b></html>");
        private JLabel label3_1 = new JLabel("Care Card #: ");
        private JLabel label3_2 = new JLabel("Address: ");
        private JLabel label3_3 = new JLabel("Birthdate: ");
        private JLabel label3_4 = new JLabel("Gender: ");

        // info
        private JLabel info1_1 = new JLabel("");
        private JLabel info1_2 = new JLabel("");
        private JLabel info1_3 = new JLabel("");
        private JLabel info2_1 = new JLabel("");
        private JLabel info2_2 = new JLabel("");
        private JLabel info2_3 = new JLabel("");
        private JLabel info2_4 = new JLabel("");
        private JLabel info3_1 = new JLabel("");
        private JLabel info3_2 = new JLabel("");
        private JLabel info3_3 = new JLabel("");
        private JLabel info3_4 = new JLabel("");

        private GridBagConstraints constraints = new GridBagConstraints();

        public DetailsDialog() {

            setTitle("Customer Details");
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

            constraints.gridwidth = 2;
            constraints.insets.set(5, 10, 5, 10);
            constraints.gridx = 0;
            constraints.gridy = 4;
            dialogPanel.add(label2, constraints);

            constraints.gridwidth = 1;
            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 5;
            dialogPanel.add(label2_1, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info2_1, constraints);

            constraints.gridy = 6;
            constraints.gridx = 0;
            dialogPanel.add(label2_2, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info2_2, constraints);

            constraints.gridy = 7;
            constraints.gridx = 0;
            dialogPanel.add(label2_3, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info2_3, constraints);

            constraints.gridy = 8;
            constraints.gridx = 0;
            dialogPanel.add(label2_4, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info2_4, constraints);

            constraints.gridwidth = 2;
            constraints.insets.set(5, 10, 5, 10);
            constraints.gridx = 0;
            constraints.gridy = 9;
            dialogPanel.add(label3, constraints);

            constraints.gridwidth = 1;
            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 10;
            dialogPanel.add(label3_1, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info3_1, constraints);

            constraints.gridy = 11;
            constraints.gridx = 0;
            dialogPanel.add(label3_2, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info3_2, constraints);

            constraints.gridy = 12;
            constraints.gridx = 0;
            dialogPanel.add(label3_3, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info3_3, constraints);

            constraints.gridy = 13;
            constraints.gridx = 0;
            dialogPanel.add(label3_4, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info3_4, constraints);

            constraints.insets.set(15, 10, 10, 10);
            constraints.gridx = 0;
            constraints.gridy = 14;
            dialogPanel.add(closeButton, constraints);

            closeButton.addActionListener(this);

            setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
            setContentPane(dialogPanel);
        }

        public void updateInfo(int id) throws SQLException {

            // TODO: fix string formatting
            // TODO: bug: search message persists (should show # of search results)

            ResultSet rs = Pharmacy_DB.getResults("SELECT * FROM Customer WHERE customer_id = " + id);

            if (rs.next()) {
                String customer_id = rs.getString("customer_id");
                String policy_id = rs.getString("insurance_policy_id");

                info1_1.setText(customer_id);
                info1_2.setText(rs.getString("name"));
                info1_3.setText(rs.getString("phone_number"));

                if (policy_id != null) {
                    info2_1.setText(policy_id);
                    ResultSet rs2 = Pharmacy_DB.getResults("SELECT * FROM Insurance_coverage WHERE policy_id = " + policy_id);
                    if (rs2.next()) {
                        info2_2.setText(rs2.getString("expDate"));
                        info2_3.setText(rs2.getString("maxAllowance_cents"));
                        info2_4.setText(rs2.getString("company"));
                    } else {
                        info2_2.setText("Missing from database");
                        info2_3.setText("Missing from database");
                        info2_4.setText("Missing from database");
                    }
                } else {
                    info2_2.setText("N/A");
                    info2_3.setText("N/A");
                    info2_4.setText("N/A");
                }

                ResultSet rs3 = Pharmacy_DB.getResults("SELECT * FROM Patient WHERE customer_id = " + customer_id);

                if (rs3.next()) {
                    info3_1.setText(rs3.getString("care_card_number"));
                    info3_2.setText(rs3.getString("address"));
                    info3_3.setText(rs3.getString("birthdate"));
                    info3_4.setText(rs3.getString("gender"));
                } else {
                    info3_1.setText("N/A");
                    info3_2.setText("N/A");
                    info3_3.setText("N/A");
                    info3_4.setText("N/A");
                }

            } else {
                throw new SQLException();
            }
        }

        public void actionPerformed(ActionEvent e) {
            dispose();
        }
    }

}
