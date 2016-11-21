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

public class DrugLookup extends DBScreen {

    private JLabel labelID = new JLabel("DIN: ");
    private JTextField textID = new JTextField(10);
    private JLabel labelName1 = new JLabel("Trade Name: ");
    private JTextField textName1 = new JTextField(10);
    private JLabel labelName2 = new JLabel("Nonproprietary Name: ");
    private JTextField textName2 = new JTextField(10);
    private JCheckBox otc = new JCheckBox("Over the counter drug");
    private JCheckBox stock = new JCheckBox("Stock drug");

    private JButton buttonSearch = new JButton("Search");
    private JButton buttonBack = new JButton("Back");

    private JPanel messageContainer = new JPanel(new GridLayout(1, 1));
    private JLabel searchMessage = new JLabel("Searching...");

    private JPopupMenu contextMenu = new JPopupMenu();

    private DetailsDialog detailsDialog = new DetailsDialog();
    private RestockDialog restockDialog = new RestockDialog();

    private GridBagConstraints constraints = new GridBagConstraints();

    DefaultTableModel model = new DBTableModel();
    JTable table = new JTable(model);

    private JPanel left;
    private JPanel right;

    public DrugLookup() {

        // important! call JPanel constructor and pass GridBagLayout
        super(new GridBagLayout());

        left = new JPanel(new GridBagLayout());
        right = new JPanel(new BorderLayout());

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
        left.add(labelName1, constraints);

        constraints.gridx = 1;
        left.add(textName1, constraints);

        constraints.gridx = 0;
        constraints.gridy = 2;
        left.add(labelName2, constraints);

        constraints.gridx = 1;
        left.add(textName2, constraints);

        constraints.insets.set(10, 10, 2, 10);

        constraints.gridx = 0;
        constraints.gridy = 3;
        constraints.gridwidth = 2;
        left.add(otc, constraints);

        constraints.gridx = 0;
        constraints.gridy = 4;
        constraints.insets.set(2, 10, 10, 10);
        left.add(stock, constraints);

        otc.doClick();
        stock.doClick();

        constraints.insets.set(10, 10, 10, 10);

        constraints.gridx = 0;
        constraints.gridy = 5;
        constraints.anchor = GridBagConstraints.CENTER;
        left.add(buttonSearch, constraints);

        constraints.gridy = 6;
        left.add(buttonBack, constraints);

        constraints.gridx = 0;
        constraints.gridy = 7;
        constraints.gridwidth = 2;
        messageContainer.add(searchMessage);
        left.add(messageContainer, constraints);
        searchMessage.setVisible(false);

        model.addColumn("DIN");
        model.addColumn("TN");
        model.addColumn("INN");
        model.addColumn("Stock");

        table.getColumnModel().getColumn(0).setPreferredWidth(100);
        table.getColumnModel().getColumn(1).setPreferredWidth(250);
        table.getColumnModel().getColumn(2).setPreferredWidth(250);
        table.getColumnModel().getColumn(3).setPreferredWidth(100);

        table.setFillsViewportHeight(true);
        JScrollPane tableContainer = new JScrollPane(table);
        table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
        right.add(tableContainer, BorderLayout.CENTER);

        // set border for the panel
        left.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Search"));

        // set border for the panel
        right.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Drugs"));

        buttonSearch.addActionListener(new SearchButton());
        buttonBack.addActionListener(new BackButton());

        JMenuItem menuDetails = new JMenuItem("Details");
        menuDetails.addActionListener(new DetailsButton());
        contextMenu.add(menuDetails);

        JMenuItem menuRestock = new JMenuItem("Restock");
        menuRestock.addActionListener(new RestockButton());
        contextMenu.add(menuRestock);

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
                if (e.isPopupTrigger() && e.getComponent() instanceof JTable ) {
                    contextMenu.show(e.getComponent(), e.getX(), e.getY());
                }
            }
        });

        search();
    }

    private void fillTable(DefaultTableModel model, ResultSet rs) {
        model.setRowCount(0);
        if (rs != null) {
            try {
                while(rs.next()){
                    int din = rs.getInt("DIN");
                    String inn = rs.getString("drug_name_INN");
                    String trade = rs.getString("drug_name_trade");
                    String type = rs.getString("type");
                    String stock = rs.getString("stock");

                    if (type.equals("otc")) {
                        stock = stock + " units";
                    } else if (type.equals("stock")) {
                        stock = stock + " mg";
                    }

                    // take first name before commas
                    if (inn.indexOf(',') != -1) {
                        inn = inn.substring(0, inn.indexOf(','));
                    }
                    if (trade.indexOf(',') != -1) {
                        trade = trade.substring(0, trade.indexOf(','));
                    }

                    model.addRow(new Object[] {String.format("%08d", din), inn, trade, stock});
                }
            } catch (SQLException e) {
                // stop
            }
        }
    }

    private void search() {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        if (otc.isSelected() || stock.isSelected()) {
            query.append("SELECT * FROM (");
            if (otc.isSelected()) {
                query.append("SELECT d.DIN, drug_name_INN, drug_name_trade, quantity stock, 'otc' type " +
                        "FROM Drug d, Over_the_counter_drug o " +
                        "WHERE d.DIN = o.DIN");
            }
            if (otc.isSelected() && stock.isSelected()) {
                query.append(" UNION ");
            }
            if (stock.isSelected()) {
                query.append("SELECT d.DIN, drug_name_INN, drug_name_trade, amount_mg stock, 'stock' type " +
                        "FROM Drug d, Stock_drug s " +
                        "WHERE d.DIN = s.DIN");
            }
            query.append(") ");

            query.append(" WHERE LOWER(drug_name_INN) LIKE LOWER('%");
            query.append(textName1.getText());
            query.append("%') AND LOWER(drug_name_trade) LIKE LOWER ('%");
            query.append(textName2.getText());
            query.append("%')");

            String din = textID.getText();

            if (din.length() != 0) {
                query.append(" AND din = ");
                query.append(din);
            }

            query.append(" ORDER BY din");

            fillTable(model, Pharmacy_DB.getResults(query.toString()));
        } else {
            fillTable(model, null);
        }

        message.append(model.getRowCount());
        message.append(" results found.");

        searchMessage.setText(message.toString());
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
                    search();
                }
            });
        }
    }

    private class BackButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
        }
    }

    // button that triggers details dialog
    //
    private class DetailsButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            String idString = table.getValueAt(table.getSelectedRow(), 0).toString();
            int id = Integer.parseInt(idString);

            try {
                detailsDialog.updateInfo(id);
                detailsDialog.pack();
                detailsDialog.setLocationRelativeTo(Pharmacy_DB.getDrugLookup());
                detailsDialog.setVisible(true);
            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(Pharmacy_DB.getDrugLookup(),
                        "Unexpected error.",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    // dialog displaying drug details
    //
    private class DetailsDialog extends JDialog implements ActionListener {

        private JPanel dialogPanel = new JPanel(new GridBagLayout());
        private JButton closeButton = new JButton("Close");

        // labels
        private JLabel label1 = new JLabel("<html><b>Basic Information</b></html>");
        private JLabel label1_1 = new JLabel("DIN: ");
        private JLabel label1_2 = new JLabel("Nonproprietary: ");
        private JLabel label1_3 = new JLabel("Trade: ");
        private JLabel label2 = new JLabel("<html><b>Stock Information</b></html>");
        private JLabel label2_1 = new JLabel("Type: ");
        private JLabel label2_2 = new JLabel("Amount: ");
        private JLabel label2_3 = new JLabel("Price: ");
        private JLabel label3 = new JLabel("<html><b>Description</b></html>");
        private JLabel label4 = new JLabel("<html><b>Contraindications</b></html>");

        // info
        private JLabel info1_1 = new JLabel("");
        private JLabel info1_2 = new JLabel("");
        private JLabel info1_3 = new JLabel("");
        private JLabel info2_1 = new JLabel("");
        private JLabel info2_2 = new JLabel("");
        private JLabel info2_3 = new JLabel("");
        private JTextArea info_3 = new JTextArea(5, 40);
        private JTextArea info_4 = new JTextArea(5, 40);

        private GridBagConstraints constraints = new GridBagConstraints();

        public DetailsDialog() {
            setTitle("Drug Details");
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

            constraints.gridwidth = 2;
            constraints.insets.set(5, 10, 5, 10);
            constraints.gridx = 0;
            constraints.gridy = 8;
            dialogPanel.add(label3, constraints);

            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 9;
            info_3.setEditable(false);
            info_3.setLineWrap(true);
            info_3.setWrapStyleWord(true);
            info_3.setFont(new Font("Sans-serif", Font.PLAIN, 10));
            JScrollPane scroll1 = new JScrollPane(info_3, JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
            dialogPanel.add(scroll1, constraints);

            constraints.insets.set(5, 10, 5, 10);
            constraints.gridx = 0;
            constraints.gridy = 10;
            dialogPanel.add(label4, constraints);

            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 11;
            info_4.setEditable(false);
            info_4.setLineWrap(true);
            info_4.setWrapStyleWord(true);
            info_4.setFont(new Font("Sans-serif", Font.PLAIN, 10));
            JScrollPane scroll2 = new JScrollPane(info_4, JScrollPane.VERTICAL_SCROLLBAR_AS_NEEDED, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
            dialogPanel.add(scroll2, constraints);

            constraints.insets.set(15, 10, 10, 10);
            constraints.gridx = 0;
            constraints.gridy = 12;
            dialogPanel.add(closeButton, constraints);

            closeButton.addActionListener(this);

            setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
            setContentPane(dialogPanel);
        }

        public void updateInfo(int id) throws SQLException {
            ResultSet rs0 = Pharmacy_DB.getResults("SELECT * FROM Drug WHERE DIN = " + id);
            ResultSet rs1 = Pharmacy_DB.getResults("SELECT * FROM Over_the_counter_drug WHERE DIN = " + id);
            ResultSet rs2 = Pharmacy_DB.getResults("SELECT * FROM Stock_drug WHERE DIN = " + id);

            if (rs0.next()) {

                String inn = rs0.getString("drug_name_INN");
                String trade = rs0.getString("drug_name_trade");

                // take first name before commas
                if (inn.indexOf(',') != -1) {
                    inn = inn.substring(0, inn.indexOf(','));
                }
                if (trade.indexOf(',') != -1) {
                    trade = trade.substring(0, trade.indexOf(','));
                }

                info1_1.setText(rs0.getString("DIN"));
                info1_2.setText(inn);
                info1_3.setText(trade);
                info_3.setText(rs0.getString("drug_description"));
                info_4.setText(rs0.getString("contraindications"));
            } else {
                throw new SQLException();
            }

            if (rs1.next()) {
                info2_1.setText("Over-the-counter");
                info2_2.setText(rs1.getString("quantity") + " units");
                info2_3.setText(String.format("$%.2f", ((float) rs1.getInt("cost_cents")) / 100) + " per unit");
            } else if (rs2.next()) {
                info2_1.setText("Stock");
                info2_2.setText(rs2.getString("amount_mg") + " mg");
                info2_3.setText(String.format("$%.2f", ((float) rs2.getInt("cost_per_mg_cents")) / 100) + " per mg");
            } else {
                throw new SQLException();
            }
        }

        public void actionPerformed(ActionEvent e) {
            dispose();
        }
    }

    // button that triggers restock dialog
    //
    private class RestockButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            String idString = table.getValueAt(table.getSelectedRow(), 0).toString();
            int id = Integer.parseInt(idString);

            try {
                restockDialog.updateInfo(id);
                restockDialog.pack();
                restockDialog.setLocationRelativeTo(Pharmacy_DB.getDrugLookup());
                restockDialog.setVisible(true);
            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(Pharmacy_DB.getDrugLookup(),
                        "Unexpected error.",
                        "Error",
                        JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    // dialog that displays drug restock options
    //
    private class RestockDialog extends JDialog implements ActionListener {

        private JPanel dialogPanel = new JPanel(new GridBagLayout());
        private JButton closeButton = new JButton("Close");
        private JButton restockButton = new JButton("Restock");

        // labels
        private JLabel label1 = new JLabel("<html><b>You are restocking:</b></html>");
        private JLabel label2 = new JLabel("<html><b>Please enter an amount to restock.</b></html>");

        // text fields
        private JTextField amount = new JTextField(6);

        // info
        private JLabel info1 = new JLabel("");
        private JLabel info2 = new JLabel("");

        private GridBagConstraints constraints = new GridBagConstraints();

        private int DIN = 0;
        private boolean otc = false;

        public RestockDialog() {
            setTitle("Drug Restock");
            constraints.anchor = GridBagConstraints.WEST;
            // TOP, LEFT, BOTTOM, RIGHT
            constraints.insets = new Insets(10, 10, 5, 10);
            constraints.gridwidth = 2;
            constraints.gridx = 0;
            constraints.gridy = 0;
            dialogPanel.add(label1, constraints);

            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 1;
            dialogPanel.add(info1, constraints);

            constraints.insets.set(5, 10, 5, 10);
            constraints.gridy = 2;
            dialogPanel.add(label2, constraints);

            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 3;
            constraints.gridwidth = 1;
            dialogPanel.add(amount, constraints);

            constraints.insets.set(5, 10, 5, 10);
            constraints.gridx = 1;
            dialogPanel.add(info2, constraints);

            constraints.insets.set(15, 10, 5, 10);
            constraints.gridx = 0;
            constraints.gridy = 4;
            dialogPanel.add(restockButton, constraints);

            constraints.insets.set(15, 5, 5, 10);
            constraints.gridx = 1;
            dialogPanel.add(closeButton, constraints);

            restockButton.addActionListener(this);
            closeButton.addActionListener(this);

            setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
            setContentPane(dialogPanel);
        }

        public void updateInfo(int id) throws SQLException {
            DIN = id;

            ResultSet rs0 = Pharmacy_DB.getResults("SELECT * FROM Drug WHERE DIN = " + id);
            ResultSet rs1 = Pharmacy_DB.getResults("SELECT * FROM Over_the_counter_drug WHERE DIN = " + id);
            ResultSet rs2 = Pharmacy_DB.getResults("SELECT * FROM Stock_drug WHERE DIN = " + id);

            if (rs0.next()) {
                String name = rs0.getString("drug_name_INN");

                if (name.indexOf(',') != -1) {
                    name = name.substring(0, name.indexOf(','));
                }

                info1.setText(name);
            } else {
                throw new SQLException();
            }

            if (rs1.next()) {
                info2.setText("units");
                otc = true;
            } else if (rs2.next()) {
                info2.setText("mg");
                otc = false;
            } else {
                throw new SQLException();
            }

            amount.setText("");
        }

        public void actionPerformed(ActionEvent e) {
            if (e.getSource() == closeButton) {
                dispose();
            } else if (e.getSource() == restockButton) {

                String amountString = amount.getText().trim();

                // error handling
                //
                if (amountString.isEmpty()) {
                    JOptionPane.showMessageDialog(Pharmacy_DB.getDrugLookup(),
                            "You must enter an amount.",
                            "Error",
                            JOptionPane.ERROR_MESSAGE);
                } else if (!Pharmacy_DB.isInteger(amountString)) {
                    JOptionPane.showMessageDialog(Pharmacy_DB.getDrugLookup(),
                            "Amount must be an integer.",
                            "Error",
                            JOptionPane.ERROR_MESSAGE);
                } else {
                    int n = JOptionPane.showConfirmDialog(
                            Pharmacy_DB.getDrugLookup(),
                            "Are you sure you want to restock " + amountString + " " + info2.getText() +
                                    " of:\n\n<html><b>" + info1.getText() + "</b></html>\n\n",
                            "Restock",
                            JOptionPane.YES_NO_OPTION);
                    if (n == YES_OPTION) {
                        String updateQuery = "UPDATE " +
                                (otc ? "Over_the_counter_drug" : "Stock_drug") +
                                " SET " +
                                (otc ? "quantity = quantity + " : "amount_mg = amount_mg + ") + amountString +
                                " WHERE DIN = " + DIN;
                        try {
                            if (Pharmacy_DB.executeUpdate(updateQuery) > 0) {
                                search();
                                revalidate();
                                repaint();

                                dispose();
                                JOptionPane.showMessageDialog(Pharmacy_DB.getDrugLookup(),
                                        "Item successfully restocked.",
                                        "Restocked",
                                        JOptionPane.PLAIN_MESSAGE);
                            } else {
                                JOptionPane.showMessageDialog(Pharmacy_DB.getDrugLookup(),
                                        "Item not found. Try refreshing your view.",
                                        "Error",
                                        JOptionPane.ERROR_MESSAGE);
                            }
                        } catch (SQLException ex) {
                            JOptionPane.showMessageDialog(Pharmacy_DB.getDrugLookup(),
                                    "Unexpected error. Please try again.",
                                    "Error",
                                    JOptionPane.ERROR_MESSAGE);
                        }
                    }
                }
            }
        }
    }
}
