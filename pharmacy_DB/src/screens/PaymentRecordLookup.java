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

public class PaymentRecordLookup extends DBScreen {

    private JLabel labelID = new JLabel("Customer ID: ");
    private JTextField textID = new JTextField(10);
    private JLabel extra = new JLabel("Extra Functions");
    private JButton buttonSearch = new JButton("Search");
    private JButton buttonTotals = new JButton("Total Per Customer");
    private JButton buttonSumTotals = new JButton("Total Overall");
    private JButton buttonAverageTotals = new JButton("Average Total Overall");
    private JButton buttonMaxTotals = new JButton("Highest Total");
    private JButton buttonBack = new JButton("Back");

    private JPanel messageContainer = new JPanel(new GridLayout(1, 1));
    private JLabel searchMessage = new JLabel("Searching...");

    private GridBagConstraints constraints = new GridBagConstraints();

    DefaultTableModel model = new DBTableModel();
    JTable table = new JTable(model);

    private JPopupMenu contextMenu = new JPopupMenu();

    private JPanel left = new JPanel(new GridBagLayout());
    private JPanel right = new JPanel(new BorderLayout());

    private boolean clickable = false;

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
        constraints.fill = GridBagConstraints.HORIZONTAL;
        left.add(buttonSearch, constraints);

        constraints.gridy = 2;
        left.add(extra, constraints);

        constraints.gridy = 3;
        constraints.insets.set(5, 10, 5, 10);
        left.add(buttonTotals, constraints);

        constraints.gridy = 4;
        left.add(buttonSumTotals, constraints);

        constraints.gridy = 5;
        left.add(buttonAverageTotals, constraints);

        constraints.gridy = 6;
        left.add(buttonMaxTotals, constraints);

        constraints.gridy = 10;
        constraints.gridwidth = 1;
        constraints.insets.set(10, 10, 10, 10);
        left.add(buttonBack, constraints);

        constraints.gridx = 0;
        constraints.gridy = 11;
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

        JMenuItem menuDelete = new JMenuItem("Delete");
        menuDelete.addActionListener(new DeleteButton());
        contextMenu.add(menuDelete);

        buttonSearch.addActionListener(new SearchButton());
        buttonTotals.addActionListener(new TotalsButton());
        buttonSumTotals.addActionListener(new SumTotalsButton());
        buttonAverageTotals.addActionListener(new AverageTotalsButton());
        buttonMaxTotals.addActionListener(new MaxTotalsButton());
        buttonBack.addActionListener(new BackButton());

        table.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseReleased(MouseEvent e) {
                if (clickable) popup(e);
            }

            @Override
            public void mousePressed(MouseEvent e) {
                if (clickable) popup(e);
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
        clickable = true;

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
        clickable = false;

        revalidate();
        repaint();
    }

    // aggregation
    private void searchSumTotals() {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        query.append("SELECT SUM(total) total FROM Payment_paid_by");

        fillTableSumTotals(model, Pharmacy_DB.getResults(query.toString()));

        message.append(model.getRowCount());
        message.append(" results found.");

        searchMessage.setText(message.toString());
        clickable = false;

        revalidate();
        repaint();
    }

    // nexted aggregation with group-by
    private void searchAverageTotals() {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        query.append("SELECT AVG(total) total FROM (SELECT customer_id, SUM(total) total " +
                "FROM Payment_paid_by GROUP BY customer_id)");

        fillTableSumTotals(model, Pharmacy_DB.getResults(query.toString()));

        message.append(model.getRowCount());
        message.append(" results found.");

        searchMessage.setText(message.toString());
        clickable = false;

        revalidate();
        repaint();
    }

    // nexted aggregation with group-by
    private void searchMaxTotals() {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        query.append("SELECT MAX(total) total FROM (SELECT customer_id, SUM(total) total " +
                "FROM Payment_paid_by GROUP BY customer_id)");

        fillTableSumTotals(model, Pharmacy_DB.getResults(query.toString()));

        message.append(model.getRowCount());
        message.append(" results found.");

        searchMessage.setText(message.toString());
        clickable = false;

        revalidate();
        repaint();
    }

    private void deleteRecord(int id) throws SQLException {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        query.append("DELETE FROM Payment_paid_by WHERE paymentId = ");
        query.append(id);

        Pharmacy_DB.executeUpdate(query.toString());

        search();

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

    private class AverageTotalsButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            searchMessage.setText("Searching...");
            searchMessage.setVisible(true);

            SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run() {
                    searchAverageTotals();
                }
            });
        }
    }

    private class MaxTotalsButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            searchMessage.setText("Searching...");
            searchMessage.setVisible(true);

            SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run() {
                    searchMaxTotals();
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
            int n = JOptionPane.showConfirmDialog(
                    Pharmacy_DB.getEmployeeLookupPanel(),
                    "Are you sure you want to delete the following record?\n\n" +
                            "Record ID: " + table.getValueAt(table.getSelectedRow(), 0).toString() + "\n\n",
                    "Delete Record",
                    JOptionPane.YES_NO_OPTION);
            if (n == YES_OPTION) {
                try {
                    // check for result > 0???
                    deleteRecord(Integer.parseInt(table.getValueAt(table.getSelectedRow(), 0).toString()));
                    JOptionPane.showMessageDialog(Pharmacy_DB.getEmployeeLookupPanel(),
                            "Record successfully deleted.",
                            "Delete Record",
                            JOptionPane.PLAIN_MESSAGE);
                } catch (SQLException ex) {
                    JOptionPane.showMessageDialog(Pharmacy_DB.getEmployeeLookupPanel(),
                            "Unexpected error.",
                            "Error",
                            JOptionPane.ERROR_MESSAGE);
                }
            }
        }
    }

}
