package screens;

import main.Pharmacy_DB;
import models.DBTableModel;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.TableCellRenderer;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import static javax.swing.JOptionPane.YES_OPTION;

public class ProcessPayment extends JPanel implements ActionListener {

    // implementing ActionListener interface for improved button handling

    private JLabel labelDIN = new JLabel("DIN: ");
    private JTextField textDIN = new JTextField(6);

    private JLabel labelCID = new JLabel("Customer ID: ");
    private JTextField textCID = new JTextField(6);

    private JButton buttonAdd = new JButton("Add");
    private JButton buttonSubmit = new JButton("Submit");
    private JButton buttonClear = new JButton("Clear");
    private JButton buttonBack = new JButton("Back");
    private JMenuItem menuDelete = new JMenuItem("Delete");

    private GridBagConstraints constraints = new GridBagConstraints();

    private NewItemDialog newItemDialog = new NewItemDialog();
    private NewPaymentDialog newPaymentDialog = new NewPaymentDialog();

    private DefaultTableModel model = new DBTableModel();
    private JTable table = new JTable(model);

    private JPopupMenu contextMenu = new JPopupMenu();

    private JPanel left = new JPanel(new GridBagLayout());
    private JPanel right = new JPanel(new BorderLayout());

    public ProcessPayment() {

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
        left.add(labelDIN, constraints);

        constraints.gridx = 1;
        left.add(textDIN, constraints);

        constraints.gridx = 2;
        left.add(buttonAdd, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        left.add(labelCID, constraints);

        constraints.gridx = 1;
        left.add(textCID, constraints);

        constraints.fill = GridBagConstraints.HORIZONTAL;
        constraints.gridwidth = 3;
        constraints.gridx = 0;
        constraints.gridy = 2;
        left.add(buttonSubmit, constraints);

        constraints.gridy = 3;
        left.add(buttonClear, constraints);

        constraints.gridwidth = 1;
        constraints.insets.set(20, 10, 10, 10);
        constraints.gridy = 4;
        left.add(buttonBack, constraints);

        model.addColumn("DIN");
        model.addColumn("Name");
        model.addColumn("Quantity");
        model.addColumn("Price");
        model.addColumn("Total");

        table.getColumnModel().getColumn(0).setPreferredWidth(100);
        table.getColumnModel().getColumn(1).setPreferredWidth(150);
        table.getColumnModel().getColumn(2).setPreferredWidth(150);
        table.getColumnModel().getColumn(3).setPreferredWidth(150);
        table.getColumnModel().getColumn(4).setPreferredWidth(150);

        table.setFillsViewportHeight(true);
        JScrollPane tableContainer = new JScrollPane(table);
        table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
        right.add(tableContainer, BorderLayout.CENTER);

        // set border for the panel
        left.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Transaction"));

        // set border for the panel
        right.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Items"));

        buttonAdd.addActionListener(this);
        buttonSubmit.addActionListener(this);
        buttonClear.addActionListener(this);
        buttonBack.addActionListener(this);

        menuDelete.addActionListener(this);
        contextMenu.add(menuDelete);

        table.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                popup(e);
            }

            @Override
            public void mousePressed(MouseEvent e) {
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
                if (e.isPopupTrigger() && e.getComponent() instanceof JTable) {
                    contextMenu.show(e.getComponent(), e.getX(), e.getY());
                }
            }
        });
    }

    public void actionPerformed(ActionEvent e) {
        if (e.getSource() == buttonAdd) {
            doAdd();
        } else if (e.getSource() == buttonSubmit) {
            doSubmit();
        } else if (e.getSource() == buttonClear) {
            doClear();
        } else if (e.getSource() == buttonBack) {
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
        } else if (e.getSource() == menuDelete) {
            model.removeRow(table.getSelectedRow());
        }
    }

    private void doAdd() {
        String din = textDIN.getText().trim();

        if (din.isEmpty()) {
            JOptionPane.showMessageDialog(Pharmacy_DB.getDrugLookup(),
                    "You must enter DIN.",
                    "Error",
                    JOptionPane.ERROR_MESSAGE);
        } else if (!Pharmacy_DB.isInteger(din)) {
            JOptionPane.showMessageDialog(Pharmacy_DB.getDrugLookup(),
                    "DIN must be an integer.",
                    "Error",
                    JOptionPane.ERROR_MESSAGE);
        } else {
            ResultSet rs0 = Pharmacy_DB.getResults("SELECT * FROM Drug WHERE DIN = " + din);

            try {
                if (rs0.next()) {
                    String inn = rs0.getString("drug_name_INN");
                    int id = Integer.parseInt(din);

                    newItemDialog.process(id);
                    newItemDialog.pack();
                    newItemDialog.setLocationRelativeTo(Pharmacy_DB.getProcessPayment());
                    newItemDialog.setVisible(true);

                } else {
                    JOptionPane.showMessageDialog(Pharmacy_DB.getProcessPayment(),
                            "DIN not found.",
                            "Error",
                            JOptionPane.ERROR_MESSAGE);
                }
            } catch (SQLException e) {
                JOptionPane.showMessageDialog(Pharmacy_DB.getProcessPayment(),
                        "Unexpected error.",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void doSubmit() {
        String customer_id = textCID.getText().trim();

        if (customer_id.isEmpty()) {
            JOptionPane.showMessageDialog(Pharmacy_DB.getProcessPayment(),
                    "You must enter customer ID.",
                    "Error",
                    JOptionPane.ERROR_MESSAGE);
        } else if (!Pharmacy_DB.isInteger(customer_id)) {
            JOptionPane.showMessageDialog(Pharmacy_DB.getProcessPayment(),
                    "Customer ID must be an integer.",
                    "Error",
                    JOptionPane.ERROR_MESSAGE);
        } else {
            ResultSet rs0 = Pharmacy_DB.getResults("SELECT * FROM Customer WHERE customer_id = " + customer_id);

            try {
                if (rs0.next()) {
                    int numRows = model.getRowCount();
                    int totalCost = 0;

                    // TODO: implement stock checking...

                    for (int i = 0; i < numRows; i++) {
                        totalCost += Pharmacy_DB.currencyToCents(model.getValueAt(i, 4).toString());
                    }

                    newPaymentDialog.process(Integer.parseInt(customer_id), totalCost);
                    newPaymentDialog.pack();
                    newPaymentDialog.setLocationRelativeTo(Pharmacy_DB.getProcessPayment());
                    newPaymentDialog.setVisible(true);
                } else {
                    JOptionPane.showMessageDialog(Pharmacy_DB.getProcessPayment(),
                            "Customer not found.",
                            "Error",
                            JOptionPane.ERROR_MESSAGE);
                }
            } catch (SQLException e) {
                JOptionPane.showMessageDialog(Pharmacy_DB.getProcessPayment(),
                        "Unexpected error.",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void doClear() {
        model.setRowCount(0);
    }

    private class NewItemDialog extends JDialog implements ActionListener {

        private JPanel dialogPanel = new JPanel(new GridBagLayout());
        private JButton closeButton = new JButton("Close");
        private JButton addButton = new JButton("Add");

        // labels
        private JLabel label1 = new JLabel("<html><b>You are adding:</b></html>");
        private JLabel label2 = new JLabel("<html><b>Available stock:</b></html>");
        private JLabel label3 = new JLabel("<html><b>Please enter an amount to add.</b></html>");

        // text fields
        private JTextField amount = new JTextField(6);

        // info
        private JLabel info1 = new JLabel("");
        private JLabel info2 = new JLabel("");
        private JLabel info3 = new JLabel("");

        private GridBagConstraints constraints = new GridBagConstraints();

        private int DIN = 0;
        private String name = "";
        private int price = 0;
        private int stock = 0;
        private boolean otc = false;
        private String units = "";

        public NewItemDialog() {
            setTitle("New Item");
            constraints.anchor = GridBagConstraints.WEST;
            // TOP, LEFT, BOTTOM, RIGHT
            constraints.insets = new Insets(10, 10, 5, 10);
            constraints.gridwidth = 2;
            constraints.gridx = 0;
            constraints.gridy = 0;
            dialogPanel.add(label1, constraints);

            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 1;
            constraints.gridwidth = 1;
            dialogPanel.add(info1, constraints);

            constraints.insets.set(5, 10, 5, 10);
            constraints.gridy = 2;
            constraints.gridwidth = 2;
            dialogPanel.add(label2, constraints);

            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 3;
            constraints.gridwidth = 1;
            dialogPanel.add(info2, constraints);

            constraints.insets.set(5, 10, 5, 10);
            constraints.gridy = 4;
            constraints.gridwidth = 2;
            dialogPanel.add(label3, constraints);

            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 5;
            constraints.gridwidth = 1;
            dialogPanel.add(amount, constraints);

            constraints.insets.set(5, 10, 5, 10);
            constraints.gridx = 1;
            dialogPanel.add(info3, constraints);

            constraints.insets.set(15, 10, 5, 10);
            constraints.gridx = 0;
            constraints.gridy = 6;
            dialogPanel.add(addButton, constraints);

            constraints.insets.set(15, 5, 5, 10);
            constraints.gridx = 1;
            dialogPanel.add(closeButton, constraints);

            addButton.addActionListener(this);
            closeButton.addActionListener(this);

            setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
            setContentPane(dialogPanel);
        }

        public void process(int id) throws SQLException {
            DIN = id;

            ResultSet rs0 = Pharmacy_DB.getResults("SELECT * FROM Drug WHERE DIN = " + id);
            ResultSet rs1 = Pharmacy_DB.getResults("SELECT * FROM Over_the_counter_drug WHERE DIN = " + id);
            ResultSet rs2 = Pharmacy_DB.getResults("SELECT * FROM Stock_drug WHERE DIN = " + id);

            if (rs0.next()) {
                name = rs0.getString("drug_name_INN");

                if (name.indexOf(',') != -1) {
                    name = name.substring(0, name.indexOf(','));
                }

                info1.setText(name);
            } else {
                throw new SQLException();
            }

            if (rs1.next()) {
                stock = Integer.parseInt(rs1.getString("quantity"));
                info2.setText(stock + " units");
                info3.setText("units");
                price = rs1.getInt("cost_cents");
                otc = true;
                units = "units";
            } else if (rs2.next()) {
                stock = Integer.parseInt(rs2.getString("amount_mg"));
                info2.setText(stock + " mg");
                info3.setText("mg");
                price = rs2.getInt("cost_per_mg_cents");
                otc = false;
                units = "mg";
            } else {
                throw new SQLException();
            }

            amount.setText("");
        }

        public void actionPerformed(ActionEvent e) {
            if (e.getSource() == closeButton) {
                dispose();
            } else if (e.getSource() == addButton) {
                String amountString = amount.getText().trim();

                if (amountString.isEmpty()) {
                    JOptionPane.showMessageDialog(this,
                            "You must enter an amount.",
                            "Error",
                            JOptionPane.ERROR_MESSAGE);
                } else if (!Pharmacy_DB.isInteger(amountString)) {
                    JOptionPane.showMessageDialog(this,
                            "Amount must be an integer.",
                            "Error",
                            JOptionPane.ERROR_MESSAGE);
                } else if (Integer.parseInt(amountString) > stock) {
                    JOptionPane.showMessageDialog(this,
                            "You do not have enough stock.",
                            "Error",
                            JOptionPane.ERROR_MESSAGE);
                    // note: it is possible to add multiple sets of the same drug such
                    // that the total amount exceeds the stock, which will be checked
                    // only AFTER the transaction is submitted; this part is only
                    // a preliminary check.
                } else {
                    int amount = Integer.parseInt(amountString);
                    model.addRow(new Object[] {String.format("%08d", DIN), name, amount + " " + units,
                            String.format("$%.2f", (float) price / 100),
                            String.format("$%.2f", (float) (amount * price) / 100)});
                    dispose();
                }
            }
        }
    }

    private class NewPaymentDialog extends JDialog implements ActionListener {

        private JPanel dialogPanel = new JPanel(new GridBagLayout());
        private JButton closeButton = new JButton("Close");
        private JButton payButton = new JButton("Pay");

        // labels
        private JLabel label1 = new JLabel("<html><b>Total:</b></html>");
        private JLabel label2 = new JLabel("<html><b>Policy #:</b></html>");
        private JLabel label2b = new JLabel("<html><b>Amount due:</b></html>");
        private JLabel label3 = new JLabel("<html><b>Credit Card #:</b></html>");
        private JLabel label4 = new JLabel("<html><b>Expiry Date:</b></html>");

        // text fields
        private JTextField cardNumber = new JTextField(6);
        private JComboBox<Integer> year = new JComboBox<Integer>(new Integer[]
                {2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025});
        private JComboBox<Integer> month = new JComboBox<Integer>(new Integer[]
                {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12});
        private JComboBox<Integer> day = new JComboBox<Integer>(new Integer[]
                {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15,
                16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31});

        // info
        private JLabel info1 = new JLabel("");
        private JLabel info2 = new JLabel("");
        private JLabel info3 = new JLabel("");

        private GridBagConstraints constraints = new GridBagConstraints();

        private int cid = 0;
        private int totalCost = 0;

        public NewPaymentDialog() {
            setTitle("Payment");
            constraints.anchor = GridBagConstraints.WEST;
            // TOP, LEFT, BOTTOM, RIGHT
            constraints.insets = new Insets(10, 10, 10, 10);
            constraints.gridwidth = 1;
            constraints.gridx = 0;
            constraints.gridy = 0;
            dialogPanel.add(label1, constraints);

            constraints.gridwidth = 3;
            constraints.gridx = 1;
            dialogPanel.add(info1, constraints);

            constraints.gridwidth = 1;
            constraints.gridx = 0;
            constraints.gridy = 1;
            dialogPanel.add(label2, constraints);

            constraints.gridwidth = 3;
            constraints.gridx = 1;
            dialogPanel.add(info2, constraints);

            constraints.gridwidth = 1;
            constraints.gridx = 0;
            constraints.gridy = 2;
            dialogPanel.add(label2b, constraints);

            constraints.gridwidth = 3;
            constraints.gridx = 1;
            dialogPanel.add(info3, constraints);

            constraints.gridwidth = 1;
            constraints.gridx = 0;
            constraints.gridy = 3;
            dialogPanel.add(label3, constraints);

            constraints.gridwidth = 3;
            constraints.gridx = 1;
            constraints.fill = GridBagConstraints.HORIZONTAL;
            dialogPanel.add(cardNumber, constraints);

            constraints.gridwidth = 1;
            constraints.gridx = 0;
            constraints.gridy = 4;
            constraints.fill = GridBagConstraints.NONE;
            dialogPanel.add(label4, constraints);

            constraints.gridx = 1;
            dialogPanel.add(year, constraints);

            constraints.gridx = 2;
            dialogPanel.add(month, constraints);

            constraints.gridx = 3;
            dialogPanel.add(day, constraints);

            constraints.gridwidth = 4;
            constraints.gridx = 0;
            constraints.gridy = 5;
            constraints.fill = GridBagConstraints.HORIZONTAL;
            dialogPanel.add(payButton, constraints);

            constraints.gridwidth = 1;
            constraints.gridy = 6;
            constraints.fill = GridBagConstraints.NONE;
            dialogPanel.add(closeButton, constraints);

            payButton.addActionListener(this);
            closeButton.addActionListener(this);

            setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
            setContentPane(dialogPanel);
        }

        public void process(int id, int cost) throws SQLException {
            int due = cost;
            cid = id;

            ResultSet rs0 = Pharmacy_DB.getResults("SELECT * FROM Customer WHERE customer_id = " + id);

            if (rs0.next()) {
                String policy_id = rs0.getString("insurance_policy_id");
                if (policy_id != null) {
                    ResultSet rs1 = Pharmacy_DB.getResults("SELECT * FROM Insurance_coverage WHERE policy_id = " + policy_id);
                    if (rs1.next()) {
                        info2.setText(policy_id);
                        due = Math.max(0, cost - Integer.parseInt(rs1.getString("maxAllowance_cents")));
                    } else {
                        info2.setText("N/A");
                    }
                } else {
                    info2.setText("N/A");
                }

                totalCost = due;

                info1.setText(String.format("$%.2f", (float) cost / 100));
                info3.setText(String.format("$%.2f", (float) due / 100));
            } else {
                throw new SQLException();
            }
        }

        private void doPay() {
            String card = cardNumber.getText();
            if (card.length() != 16) {
                JOptionPane.showMessageDialog(this,
                        "Please enter a 16-digit card number.",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            } else if (!Pharmacy_DB.isNumeric(card)) {
                JOptionPane.showMessageDialog(this,
                        "Credit card number must be numeric.",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            } else {
                try {
                    Date date = new Date();
                    String dateString = new SimpleDateFormat("yyyy-MM-dd").format(date);
                    Pharmacy_DB.executeUpdate("INSERT INTO Payment_paid_by VALUES " +
                            "(" + getNextID("Payment_paid_by", "paymentId") + ", " + cid + ", '" + dateString + "', " +
                            totalCost + ", " + cardNumber.getText() + ", '" +
                            year.getSelectedItem() + "-" + month.getSelectedItem() + "-" + day.getSelectedItem() + "')");

                    createRecords();

                    dispose();
                    model.setRowCount(0);
                    JOptionPane.showMessageDialog(Pharmacy_DB.getProcessPayment(),
                            "Transaction complete.",
                            "Success",
                            JOptionPane.PLAIN_MESSAGE);
                } catch (SQLException e) {
                    JOptionPane.showMessageDialog(this,
                            "Unexpected error.",
                            "Error",
                            JOptionPane.ERROR_MESSAGE);
                }
            }
        }

        private void createRecords() throws SQLException {
            for (int i = 0; i < model.getRowCount(); i++) {
                String quantity = table.getValueAt(i, 2).toString();
                Pharmacy_DB.executeUpdate("INSERT INTO Purchase_record VALUES " +
                        "(" + getNextID("Purchase_record", "record_id") + ", " + cid + ", " +
                        Integer.parseInt(table.getValueAt(i, 0).toString()) + ", " +
                        Integer.parseInt(quantity.substring(0, quantity.indexOf(" "))) + ")");
            }
        }

        private int getNextID(String tableName, String identifier) throws SQLException {
            ResultSet rs0 = Pharmacy_DB.getResults("SELECT MAX(" + identifier + ") id FROM " + tableName);

            if (rs0.next()) {
                if (rs0.getString("id") == null) {
                    return 0;
                } else {
                    return rs0.getInt("id") + 1;
                }
            } else {
                throw new SQLException();
            }
        }

        public void actionPerformed(ActionEvent e) {
            if (e.getSource() == closeButton) {
                dispose();
            } else if (e.getSource() == payButton) {
                doPay();
            }
        }
    }
}
