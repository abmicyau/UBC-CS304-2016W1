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
import java.util.ArrayList;
import java.util.Vector;

public class DrugLookup extends JPanel {

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
        model.addColumn("Description");
        model.addColumn("CI");

        table.getColumnModel().getColumn(0).setPreferredWidth(100);
        table.getColumnModel().getColumn(1).setPreferredWidth(250);
        table.getColumnModel().getColumn(2).setPreferredWidth(250);
        table.getColumnModel().getColumn(3).setPreferredWidth(100);
        table.getColumnModel().getColumn(4).setPreferredWidth(250);
        table.getColumnModel().getColumn(5).setPreferredWidth(250);

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
    }

    private void fillTable(DefaultTableModel model, ResultSet rs) {
        model.setRowCount(0);
        if (rs != null) {
            try {
                while(rs.next()){
                    int din = rs.getInt("DIN");
                    String inn = rs.getString("drug_name_INN");
                    String trade = rs.getString("drug_name_trade");
                    String desc = rs.getString("drug_description");
                    String contra = rs.getString("contraindications");
                    String type = rs.getString("type");
                    String stock = rs.getString("stock");

                    if (type.equals("otc")) {
                        stock = stock + " units";
                    } else if (type.equals("stock")) {
                        stock = stock + " mg";
                    }

                    model.addRow(new Object[] {String.format("%08d", din), inn, trade, stock, desc, contra});
                }
            } catch (SQLException e) {
                // stop
            }
        }
    }

    private class SearchButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            searchMessage.setText("Searching...");
            searchMessage.setVisible(true);

            SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run() {
                    StringBuilder query = new StringBuilder();
                    StringBuilder message = new StringBuilder();

                    if (otc.isSelected() || stock.isSelected()) {
                        query.append("SELECT * FROM (");
                        if (otc.isSelected()) {
                            query.append("SELECT d.DIN, drug_name_INN, drug_name_trade, drug_description, contraindications, quantity stock, 'otc' type " +
                                         "FROM Drug d, Over_the_counter_drug o " +
                                         "WHERE d.DIN = o.DIN");
                        }
                        if (otc.isSelected() && stock.isSelected()) {
                            query.append(" UNION ");
                        }
                        if (stock.isSelected()) {
                            query.append("SELECT d.DIN, drug_name_INN, drug_name_trade, drug_description, contraindications, amount_mg stock, 'stock' type " +
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
            });
        }
    }

    private class BackButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
        }
    }

}
