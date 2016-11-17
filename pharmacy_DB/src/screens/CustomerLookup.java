package screens;

import main.Pharmacy_DB;
import models.DBTableModel;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.text.DateFormatter;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Vector;

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
        table.getColumnModel().getColumn(1).setPreferredWidth(200);
        table.getColumnModel().getColumn(2).setPreferredWidth(200);
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

    private class SearchButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            searchMessage.setText("Searching...");
            searchMessage.setVisible(true);

            SwingUtilities.invokeLater(new Runnable() {
                @Override
                public void run() {
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
