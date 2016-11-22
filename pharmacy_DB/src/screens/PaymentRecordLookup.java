package screens;

import main.Pharmacy_DB;
import models.DBScreen;
import models.DBTableModel;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;

public class PaymentRecordLookup extends DBScreen {

    private JLabel labelID = new JLabel("Customer ID: ");
    private JTextField textID = new JTextField(10);
    private JButton buttonSearch = new JButton("Search");
    private JButton buttonTotals = new JButton("Total Per Customer");
    private JButton buttonSumTotals = new JButton("Total Overall");
    private JButton buttonBack = new JButton("Back");

    private JPanel messageContainer = new JPanel(new GridLayout(1, 1));
    private JLabel searchMessage = new JLabel("Searching...");

    private GridBagConstraints constraints = new GridBagConstraints();

    DefaultTableModel model = new DBTableModel();
    JTable table = new JTable(model);

    private JPanel left = new JPanel(new GridBagLayout());
    private JPanel right = new JPanel(new BorderLayout());

    public PaymentRecordLookup() {

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
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        left.add(buttonSearch, constraints);

        constraints.gridy = 2;
        left.add(buttonTotals, constraints);

        constraints.gridy = 3;
        left.add(buttonSumTotals, constraints);

        constraints.gridy = 4;
        left.add(buttonBack, constraints);

        constraints.gridx = 0;
        constraints.gridy = 5;
        constraints.gridwidth = 2;
        messageContainer.add(searchMessage);
        left.add(messageContainer, constraints);
        searchMessage.setVisible(false);

        model.addColumn("Payment ID");
        model.addColumn("Customer ID");
        model.addColumn("Transaction Date");
        model.addColumn("Total");

        table.getColumnModel().getColumn(0).setPreferredWidth(150);
        table.getColumnModel().getColumn(1).setPreferredWidth(150);
        table.getColumnModel().getColumn(2).setPreferredWidth(150);
        table.getColumnModel().getColumn(3).setPreferredWidth(150);

        table.setFillsViewportHeight(true);
        JScrollPane tableContainer = new JScrollPane(table);
        table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
        right.add(tableContainer, BorderLayout.CENTER);

        // set border for the panel
        left.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Search"));

        // set border for the panel
        right.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Payment Records"));

        buttonSearch.addActionListener(new SearchButton());
        buttonTotals.addActionListener(new TotalsButton());
        buttonSumTotals.addActionListener(new SumTotalsButton());
        buttonBack.addActionListener(new BackButton());

        search();
    }

    private void fillTable(DefaultTableModel model, ResultSet rs) {
        model.setRowCount(0);
        if (rs != null) {
            try {
                while (rs.next()) {
                    int id = rs.getInt("paymentId");
                    int cid = rs.getInt("customer_id");
                    String date = rs.getString("transdate");
                    int total = rs.getInt("total");
                    model.addRow(new Object[]{String.format("%08d", id), String.format("%08d", cid),
                            date, String.format("$%.2f", (float) total / 100)});
                }
            } catch (SQLException e) {
                // stop
            }
        }
    }

    private void fillTableTotals(DefaultTableModel model, ResultSet rs) {
        model.setRowCount(0);
        if (rs != null) {
            try {
                while (rs.next()) {
                    int cid = rs.getInt("customer_id");
                    int total = rs.getInt("total");
                    model.addRow(new Object[]{"-", String.format("%08d", cid),
                            "-", String.format("$%.2f", (float) total / 100)});
                }
            } catch (SQLException e) {
                // stop
            }
        }
    }

    private void fillTableSumTotals(DefaultTableModel model, ResultSet rs) {
        model.setRowCount(0);
        if (rs != null) {
            try {
                while (rs.next()) {
                    int total = rs.getInt("total");
                    model.addRow(new Object[]{"-", "-", "-", String.format("$%.2f", (float) total / 100)});
                }
            } catch (SQLException e) {
                // stop
            }
        }
    }

    private void search() {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        query.append("SELECT * FROM Payment_paid_by");

        String id = textID.getText();

        if (id.length() != 0) {
            query.append(" WHERE customer_id = " + id);
        }

        query.append(" ORDER BY paymentId");

        fillTable(model, Pharmacy_DB.getResults(query.toString()));

        message.append(model.getRowCount());
        message.append(" results found.");

        searchMessage.setText(message.toString());
        revalidate();
        repaint();
    }


    // aggregation
    private void searchTotals() {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        query.append("SELECT customer_id, SUM(total) total FROM Payment_paid_by");

        String id = textID.getText();

        if (id.length() != 0) {
            query.append(" WHERE customer_id = " + id);
        }

        query.append(" GROUP BY customer_id");

        fillTableTotals(model, Pharmacy_DB.getResults(query.toString()));

        message.append(model.getRowCount());
        message.append(" results found.");

        searchMessage.setText(message.toString());
        revalidate();
        repaint();
    }

    // nested aggregation
    private void searchSumTotals() {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        query.append("SELECT SUM(total) total FROM Payment_paid_by");

        fillTableSumTotals(model, Pharmacy_DB.getResults(query.toString()));

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

    private class TotalsButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            searchMessage.setText("Searching...");
            searchMessage.setVisible(true);

            SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run() {
                    searchTotals();
                }
            });
        }
    }

    private class SumTotalsButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            searchMessage.setText("Searching...");
            searchMessage.setVisible(true);

            SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run() {
                    searchSumTotals();
                }
            });
        }
    }

    private class BackButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
        }
    }

}
