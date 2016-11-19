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
        model.addColumn("Max Allowance");
        model.addColumn("Expiry Date");
        model.addColumn("Provider");

        table.getColumnModel().getColumn(0).setPreferredWidth(100);
        table.getColumnModel().getColumn(1).setPreferredWidth(120);
        table.getColumnModel().getColumn(2).setPreferredWidth(120);
        table.getColumnModel().getColumn(3).setPreferredWidth(100);
        table.getColumnModel().getColumn(4).setPreferredWidth(150);
        table.getColumnModel().getColumn(5).setPreferredWidth(150);
        table.getColumnModel().getColumn(6).setPreferredWidth(250);

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
                    float allowance = (float) rs.getInt("maxAllowance_cents");
                    String expDate = rs.getString("expDate");
                    String provider = rs.getString("company");

                    model.addRow(new Object[]{String.format("%08d", id), name, phone,
                            String.format("%08d", policy), String.format("$%.2f", allowance/100),
                            dt.format(dt.parse(expDate)), provider});
                }
            } catch (SQLException e) {
                // stop
            } catch (ParseException e) {
                // stop
            }
        }
    }

    private void update() {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        query.append("SELECT * FROM Customer, Insurance_coverage " +
                "WHERE insurance_policy_id = policy_id AND " +
                "LOWER(name) LIKE LOWER('%");
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

            ResultSet rs = Pharmacy_DB.getResults("SELECT * FROM Customer WHERE customer_id = " + id);

            try {
                if (rs.next()) {
                    detailsDialog.setCustomerID(rs.getString("customer_id"));
                    detailsDialog.setCustomerName(rs.getString("name"));
                    detailsDialog.setCustomerPhone(rs.getString("phone_number"));
                    //detailsDialog.pack();
                    detailsDialog.setLocationRelativeTo(Pharmacy_DB.getCustomerLookup());
                    detailsDialog.setVisible(true);
                } else {
                    // todo: change this to dialog
                    System.out.println("Customer not found");
                }
            } catch (SQLException ex) {
                // todo: change this to dialog
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
        private JLabel customerID = new JLabel("");
        private JLabel customerName = new JLabel("");
        private JLabel customerPhone = new JLabel("");
        private JButton closeButton = new JButton("Close");

        public DetailsDialog() {

            setTitle("Customer Details");
            setSize(500, 500);
            constraints.anchor = GridBagConstraints.CENTER;
            constraints.insets = new Insets(10, 10, 10, 10);
            constraints.gridx = 0;
            constraints.gridy = 0;
            constraints.gridwidth = 1;
            dialogPanel.add(customerID, constraints);

            constraints.gridy = 1;
            dialogPanel.add(customerName, constraints);

            constraints.gridy = 2;
            dialogPanel.add(customerPhone, constraints);

            constraints.gridy = 3;
            dialogPanel.add(closeButton, constraints);

            closeButton.addActionListener(this);

            setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
            setContentPane(dialogPanel);
        }

        public void setCustomerID(String id) {
            customerID.setText(id);
        }

        public void setCustomerName(String name) {
            customerName.setText(name);
        }

        public void setCustomerPhone(String phone) {
            customerPhone.setText(phone);
        }

        public void actionPerformed(ActionEvent e) {
            dispose();
        }
    }

}
