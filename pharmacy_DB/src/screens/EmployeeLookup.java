package screens;

import entities.Employee;
import main.Pharmacy_DB;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.Vector;

public class EmployeeLookup extends JPanel {

    private JLabel labelName = new JLabel("Name: ");
    private JTextField textName = new JTextField(20);

    private JButton buttonSearch = new JButton("Search");

    private GridBagConstraints constraints = new GridBagConstraints();

    DefaultTableModel model = new DefaultTableModel();
    JTable table = new JTable(model);

    private JPanel left;
    private JPanel right;

    private ArrayList<Employee> employees = new ArrayList<Employee>();

    public EmployeeLookup() {

        // important! call JPanel constructor and pass GridBagLayout
        super(new GridBagLayout());

        left = new JPanel(new GridBagLayout());
        right = new JPanel(new GridBagLayout());

        // set contraints and padding
        constraints.anchor = GridBagConstraints.WEST;
        constraints.insets = new Insets(10, 10, 10, 10);
        constraints.fill = GridBagConstraints.HORIZONTAL;
        constraints.weightx = 0;

        constraints.gridx = 0;
        add(left, constraints);

        constraints.gridx = 1;
        constraints.weightx = 1;
        add(right, constraints);

        constraints.fill = GridBagConstraints.NONE;

        // add components to the panel
        constraints.gridx = 0;
        constraints.gridy = 0;
        left.add(labelName, constraints);

        constraints.gridx = 1;
        left.add(textName, constraints);

        constraints.gridx = 0;
        constraints.gridy = 1;
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        left.add(buttonSearch, constraints);

        right.setLayout(new BorderLayout());

        model.addColumn("Name");
        model.addColumn("Email");
        model.addColumn("Phone");
        model.addColumn("Address");

        table.getColumnModel().getColumn(0).setPreferredWidth(150);
        table.getColumnModel().getColumn(1).setPreferredWidth(200);
        table.getColumnModel().getColumn(2).setPreferredWidth(200);
        table.getColumnModel().getColumn(3).setPreferredWidth(200);

        Pharmacy_DB.fill(model, "SELECT * FROM Employee");

        table.setFillsViewportHeight(true);
        JScrollPane tableContainer = new JScrollPane(table);
        table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
        right.add(tableContainer, BorderLayout.CENTER);

        // set border for the panel
        left.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Search"));

        // set border for the panel
        right.setBorder(BorderFactory.createTitledBorder(
                BorderFactory.createEtchedBorder(), "Employees"));

        buttonSearch.addActionListener(new SearchButton());
    }

    private class SearchButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            model.setRowCount(0);

            StringBuilder query = new StringBuilder();
            query.append("SELECT * FROM Employee WHERE LOWER(name) LIKE LOWER('%");
            query.append(textName.getText());
            query.append("%')");

            Pharmacy_DB.fill(model, query.toString());
        }
    }

}
