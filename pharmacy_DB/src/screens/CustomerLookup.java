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
import java.text.ParseException;
import java.text.SimpleDateFormat;

import static javax.swing.JOptionPane.YES_OPTION;

public class CustomerLookup extends DBScreen {

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
    private EditDialog editDialog = new EditDialog();

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

        JMenuItem menuEdit = new JMenuItem("Edit");
        menuEdit.addActionListener(new EditButton());
        contextMenu.add(menuEdit);

        JMenuItem menuDelete = new JMenuItem("Delete");
        menuDelete.addActionListener(new DeleteButton());
        contextMenu.add(menuDelete);

        table.addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                popup(e);
            }

            @Override
            public void mouseReleased(MouseEvent e) {
                popup(e);
            }

            private void popup(MouseEvent e) {
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
        searchMessage.setText(message.toString());

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

    @Override
    public void refresh() {
        super.refresh();
        update();
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
                JOptionPane.showMessageDialog(Pharmacy_DB.getCustomerLookup(),
                        "Unexpected error.",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private class EditButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            String idString = table.getValueAt(table.getSelectedRow(), 0).toString();
            int id = Integer.parseInt(idString);

            try {
                editDialog.updateInfo(id);
                editDialog.pack();
                editDialog.setLocationRelativeTo(Pharmacy_DB.getCustomerLookup());
                editDialog.setVisible(true);
            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(Pharmacy_DB.getCustomerLookup(),
                        "Unexpected error.",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private class DeleteButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            int n = JOptionPane.showConfirmDialog(
                    Pharmacy_DB.getCustomerLookup(),
                    "Are you sure you want to delete the following customer record?\n\n" +
                            "(" + table.getValueAt(table.getSelectedRow(), 0).toString() + ") " +
                            table.getValueAt(table.getSelectedRow(), 1).toString() + "\n\n",
                    "Delete Customer Record",
                    JOptionPane.YES_NO_OPTION);
            if (n == YES_OPTION) {
                try {
                    // check for result > 0???
                    deleteCustomer(Integer.parseInt(table.getValueAt(table.getSelectedRow(), 0).toString()));
                    JOptionPane.showMessageDialog(Pharmacy_DB.getCustomerLookup(),
                            "Customer record successfully deleted.",
                            "Delete Customer Record",
                            JOptionPane.PLAIN_MESSAGE);
                } catch (SQLException ex) {
                    JOptionPane.showMessageDialog(Pharmacy_DB.getCustomerLookup(),
                            "Unexpected error. Could not delete customer.",
                            "Delete Customer Record",
                            JOptionPane.ERROR_MESSAGE);
                }
            }
        }
    }

    private class DetailsDialog extends JDialog implements ActionListener {

        private JPanel dialogPanel = new JPanel(new GridBagLayout());
        private JButton addButton = new JButton("Add");
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
        private NewPatientDialog newPatientDialog = new NewPatientDialog();
        private int cid = 0;

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

            constraints.gridy = 4;
            constraints.gridx = 0;
            dialogPanel.add(label2_1, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info2_1, constraints);

            constraints.gridwidth = 2;
            constraints.insets.set(5, 10, 5, 10);
            constraints.gridx = 0;
            constraints.gridy = 5;
            dialogPanel.add(label2, constraints);

            constraints.gridwidth = 1;
            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 6;
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

            constraints.gridy = 14;
            constraints.gridx = 0;
            dialogPanel.add(addButton, constraints);

            constraints.insets.set(15, 10, 10, 10);
            constraints.gridx = 0;
            constraints.gridy = 15;
            dialogPanel.add(closeButton, constraints);

            addButton.setVisible(false);
            addButton.addActionListener(this);
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
                cid = Integer.parseInt(customer_id);
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
                    info2_1.setText("N/A");
                    info2_2.setText("N/A");
                    info2_3.setText("N/A");
                    info2_4.setText("N/A");
                }

                ResultSet rs3 = Pharmacy_DB.getResults("SELECT * FROM Patient WHERE customer_id = " + customer_id);

                if (rs3.next()) {
                    addButton.setVisible(false);
                    label3_1.setVisible(true);
                    label3_2.setVisible(true);
                    label3_3.setVisible(true);
                    label3_4.setVisible(true);
                    info3_1.setVisible(true);
                    info3_2.setVisible(true);
                    info3_3.setVisible(true);
                    info3_4.setVisible(true);

                    info3_1.setText(rs3.getString("care_card_number"));
                    info3_2.setText(rs3.getString("address"));
                    info3_3.setText(rs3.getString("birthdate"));
                    info3_4.setText(rs3.getString("gender"));
                } else {
                    addButton.setVisible(true);
                    label3_1.setVisible(false);
                    label3_2.setVisible(false);
                    label3_3.setVisible(false);
                    label3_4.setVisible(false);
                    info3_1.setVisible(false);
                    info3_2.setVisible(false);
                    info3_3.setVisible(false);
                    info3_4.setVisible(false);
                }

            } else {
                throw new SQLException();
            }
        }

        public void actionPerformed(ActionEvent e) {
            if (e.getSource() == addButton) {
                newPatientDialog.updateInfoPD(cid, this);
                newPatientDialog.pack();
                newPatientDialog.setLocationRelativeTo(this);
                newPatientDialog.setVisible(true);
            } else if (e.getSource() == closeButton) {
                dispose();
            }
        }

        private class NewPatientDialog extends JDialog implements ActionListener {

            private JPanel dialogPanel = new JPanel(new GridBagLayout());
            private JButton submitButton = new JButton("Submit");
            private JButton closeButton = new JButton("Close");

            // labels
            private JLabel label0 = new JLabel("<html><b>Customer ID: </b></html>");
            private JLabel label1 = new JLabel("<html><b>Care Card #: </b></html>");
            private JLabel label2 = new JLabel("<html><b>Address: </b></html>");
            private JLabel label3 = new JLabel("<html><b>Birthdate: </b></html>");
            private JLabel label4 = new JLabel("<html><b>Gender: </b></html>");

            // info
            private JLabel info0 = new JLabel("");

            // text fields
            private JTextField cardNumber = new JTextField(8);
            private JTextField address = new JTextField(8);
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
                            2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017});
            private JComboBox<Integer> month = new JComboBox<Integer>(new Integer[]
                    {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12});
            private JComboBox<Integer> day = new JComboBox<Integer>(new Integer[]
                    {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                            16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31});
            private JComboBox<String> gender = new JComboBox<String>(new String[] {"M", "F"});

            private GridBagConstraints constraints = new GridBagConstraints();
            private JDialog parent;

            private int cid = 0;

            public NewPatientDialog() {
                setTitle("Add Patient Record");
                constraints.anchor = GridBagConstraints.WEST;
                // TOP, LEFT, BOTTOM, RIGHT
                constraints.insets = new Insets(10, 10, 10, 10);
                constraints.fill = GridBagConstraints.HORIZONTAL;
                constraints.gridwidth = 1;

                constraints.gridx = 0;
                constraints.gridy = 0;
                dialogPanel.add(label0, constraints);

                constraints.gridwidth = 3;
                constraints.gridx = 1;
                dialogPanel.add(info0, constraints);

                constraints.gridwidth = 1;
                constraints.gridx = 0;
                constraints.gridy = 1;
                dialogPanel.add(label1, constraints);

                constraints.gridwidth = 3;
                constraints.gridx = 1;
                dialogPanel.add(cardNumber, constraints);

                constraints.gridwidth = 1;
                constraints.gridx = 0;
                constraints.gridy = 2;
                dialogPanel.add(label2, constraints);

                constraints.gridwidth = 3;
                constraints.gridx = 1;
                dialogPanel.add(address, constraints);

                constraints.gridwidth = 1;
                constraints.gridx = 0;
                constraints.gridy = 3;
                dialogPanel.add(label3, constraints);

                constraints.gridx = 1;
                dialogPanel.add(year, constraints);

                constraints.gridx = 2;
                dialogPanel.add(month, constraints);

                constraints.gridx = 3;
                dialogPanel.add(day, constraints);

                constraints.gridx = 0;
                constraints.gridy = 4;
                dialogPanel.add(label4, constraints);

                constraints.gridx = 1;
                dialogPanel.add(gender, constraints);

                constraints.gridwidth = 4;
                constraints.gridx = 0;
                constraints.gridy = 5;
                dialogPanel.add(submitButton, constraints);

                constraints.gridwidth = 1;
                constraints.gridy = 6;
                constraints.fill = GridBagConstraints.NONE;
                dialogPanel.add(closeButton, constraints);

                submitButton.addActionListener(this);
                closeButton.addActionListener(this);

                setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
                setContentPane(dialogPanel);
            }

            public void updateInfoPD(int cid, JDialog parent) {
                this.cid = cid;
                this.parent = parent;
                info0.setText(cid + "");
            }

            private void doSubmit() {
                String card = cardNumber.getText();
                if (card.length() != 16) {
                    JOptionPane.showMessageDialog(this,
                            "Please enter a 16-digit care card number.",
                            "Error",
                            JOptionPane.ERROR_MESSAGE);
                } else if (!Pharmacy_DB.isNumeric(card)) {
                    JOptionPane.showMessageDialog(this,
                            "Care card number must be numeric.",
                            "Error",
                            JOptionPane.ERROR_MESSAGE);
                } else {
                    try {
                        Pharmacy_DB.executeUpdate("INSERT INTO Patient VALUES " +
                                "(" + cid + ", " + card + ", '" + address.getText() + "', '" +
                                year.getSelectedItem() + "-" + month.getSelectedItem() + "-" + day.getSelectedItem() + "', '" +
                                gender.getSelectedItem() + "')");

                        dispose();
                        updateInfo(cid);
                        parent.pack();
                        JOptionPane.showMessageDialog(parent,
                                "Patient record added.",
                                "Success",
                                JOptionPane.PLAIN_MESSAGE);
                    } catch (SQLException e) {
                        e.printStackTrace();
                        JOptionPane.showMessageDialog(this,
                                "Unexpected error.",
                                "Error",
                                JOptionPane.ERROR_MESSAGE);
                    }
                }
            }

            public void actionPerformed(ActionEvent e) {
                if (e.getSource() == submitButton) {
                    doSubmit();
                } else if (e.getSource() == closeButton) {
                    dispose();
                }
            }
        }
    }

    private class EditDialog extends JDialog implements ActionListener {

        private JPanel dialogPanel = new JPanel(new GridBagLayout());
        private JButton submitButton = new JButton("Submit");
        private JButton closeButton = new JButton("Close");

        // labels
        private JLabel label1 = new JLabel("<html><b>Basic Information</b></html>");
        private JLabel label1_1 = new JLabel("Name: ");
        private JLabel label1_2 = new JLabel("Phone #: ");
        private JLabel label1_3 = new JLabel("Policy ID: ");
        private JLabel label2 = new JLabel("<html><b>Patient Record</b></html>");
        private JLabel label2_1 = new JLabel("Care Card #: ");
        private JLabel label2_2 = new JLabel("Address: ");

        // info
        private JTextField text1_1 = new JTextField(12);
        private JTextField text1_2 = new JTextField(12);
        private JTextField text1_3 = new JTextField(12);
        private JTextField text2_1 = new JTextField(12);
        private JTextField text2_2 = new JTextField(12);

        private GridBagConstraints constraints = new GridBagConstraints();
        private int cid = 0;
        private boolean patient = false;

        public EditDialog() {

            setTitle("Edit Customer");
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
            dialogPanel.add(text1_1, constraints);

            constraints.gridy = 2;
            constraints.gridx = 0;
            dialogPanel.add(label1_2, constraints);
            constraints.gridx = 1;
            dialogPanel.add(text1_2, constraints);

            constraints.gridy = 3;
            constraints.gridx = 0;
            dialogPanel.add(label1_3, constraints);
            constraints.gridx = 1;
            dialogPanel.add(text1_3, constraints);

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
            dialogPanel.add(text2_1, constraints);

            constraints.gridy = 6;
            constraints.gridx = 0;
            dialogPanel.add(label2_2, constraints);
            constraints.gridx = 1;
            dialogPanel.add(text2_2, constraints);

            constraints.insets.set(15, 10, 10, 10);
            constraints.fill = GridBagConstraints.HORIZONTAL;
            constraints.gridwidth = 2;
            constraints.gridx = 0;
            constraints.gridy = 7;
            dialogPanel.add(submitButton, constraints);

            constraints.insets.set(15, 10, 10, 10);
            constraints.fill = GridBagConstraints.NONE;
            constraints.gridwidth = 1;
            constraints.gridx = 0;
            constraints.gridy = 8;
            dialogPanel.add(closeButton, constraints);

            submitButton.addActionListener(this);
            closeButton.addActionListener(this);

            setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
            setContentPane(dialogPanel);
        }

        public void updateInfo(int id) throws SQLException {
            cid = id;
            ResultSet rs0 = Pharmacy_DB.getResults("SELECT * FROM Customer WHERE customer_id = " + id);

            if (rs0.next()) {
                text1_1.setText(rs0.getString("name"));
                text1_2.setText(rs0.getString("phone_number"));
                text1_3.setText(rs0.getString("insurance_policy_id"));

                ResultSet rs1 = Pharmacy_DB.getResults("SELECT * FROM Patient WHERE customer_id = " + id);

                if (rs1.next()) {
                    label2.setVisible(true);
                    label2_1.setVisible(true);
                    label2_2.setVisible(true);
                    text2_1.setVisible(true);
                    text2_2.setVisible(true);

                    text2_1.setText(rs1.getString("care_card_number"));
                    text2_2.setText(rs1.getString("address"));

                    patient = true;
                } else {
                    label2.setVisible(false);
                    label2_1.setVisible(false);
                    label2_2.setVisible(false);
                    text2_1.setVisible(false);
                    text2_2.setVisible(false);

                    patient = false;
                }
            } else {
                throw new SQLException();
            }
        }

        private void doSubmit() {

            String name = text1_1.getText();
            String phone_number = text1_2.getText();
            String insurance_policy_id = text1_3.getText();

            if (name.length() == 0) {
                JOptionPane.showMessageDialog(this,
                        "Name cannot be blank.",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            } else if (!Pharmacy_DB.isNumeric(insurance_policy_id)) {
                JOptionPane.showMessageDialog(this,
                        "Insurance policy ID must be numeric.",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            } else if (!isValidPolicyID(insurance_policy_id)) {
                JOptionPane.showMessageDialog(this,
                        "Insurance policy not found. Please enter a valid policy ID.",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            } else {
                try {
                    if (patient) {
                        String card = text2_1.getText();
                        String address = text2_2.getText();
                        if (card.length() != 16) {
                            JOptionPane.showMessageDialog(this,
                                    "Please enter a 16-digit care card number.",
                                    "Error",
                                    JOptionPane.ERROR_MESSAGE);
                        } else if (!Pharmacy_DB.isNumeric(card)) {
                            JOptionPane.showMessageDialog(this,
                                    "Care card number must be numeric.",
                                    "Error",
                                    JOptionPane.ERROR_MESSAGE);
                        } else {
                                Pharmacy_DB.executeUpdate("UPDATE Patient SET care_card_number = " + card +
                                        ", address = '" + address + "' WHERE customer_id = " + cid);
                        }
                    }

                    if (insurance_policy_id.length() == 0) {
                        insurance_policy_id = null;
                    }
                    Pharmacy_DB.executeUpdate("UPDATE Customer SET name = '" + name + "', " +
                            "phone_number = '" + phone_number + "', insurance_policy_id = " + insurance_policy_id +
                            " WHERE customer_id = " + cid);

                    Pharmacy_DB.getCustomerLookup().refresh();
                    dispose();

                    JOptionPane.showMessageDialog(Pharmacy_DB.getCustomerLookup(),
                            "Patient record edited.",
                            "Success",
                            JOptionPane.PLAIN_MESSAGE);

                } catch (SQLException e) {
                    e.printStackTrace();
                    JOptionPane.showMessageDialog(this,
                            "Unexpected error.",
                            "Error",
                            JOptionPane.ERROR_MESSAGE);
                }
            }
        }

        private boolean isValidPolicyID(String id) {
            if (id.length() > 0) {
                ResultSet rs = Pharmacy_DB.getResults("SELECT * FROM Insurance_coverage WHERE policy_id = " + id);

                try {
                    if (rs.next()) {
                        return true;
                    } else {
                        return false;
                    }
                } catch (SQLException e) {
                    return false;
                }
            } else {
                return true;
            }
        }

        public void actionPerformed(ActionEvent e) {
            if (e.getSource() == submitButton) {
                doSubmit();
            } else if (e.getSource() == closeButton) {
                dispose();
            }
        }

    }
}
