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

import static javax.swing.JOptionPane.YES_OPTION;

public class EmployeeLookup extends JPanel {

    private JLabel labelID = new JLabel("ID: ");
    private JTextField textID = new JTextField(10);
    private JLabel labelName = new JLabel("Name: ");
    private JTextField textName = new JTextField(10);
    private JButton buttonSearch = new JButton("Search");
    private JButton buttonBack = new JButton("Back");

    private JPanel messageContainer = new JPanel(new GridLayout(1, 1));
    private JLabel searchMessage = new JLabel("Searching...");

    private GridBagConstraints constraints = new GridBagConstraints();

    DefaultTableModel model = new DBTableModel();
    JTable table = new JTable(model);

    private JPanel left = new JPanel(new GridBagLayout());;
    private JPanel right = new JPanel(new BorderLayout());;

    private JPopupMenu contextMenu = new JPopupMenu();

    public EmployeeLookup() {

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
        constraints.gridwidth = 2;
        constraints.anchor = GridBagConstraints.CENTER;
        left.add(buttonSearch, constraints);

        constraints.gridy = 3;
        left.add(buttonBack, constraints);

        constraints.gridx = 0;
        constraints.gridy = 4;
        constraints.gridwidth = 2;
        messageContainer.add(searchMessage);
        left.add(messageContainer, constraints);
        searchMessage.setVisible(false);

        model.addColumn("ID");
        model.addColumn("Name");
        model.addColumn("Email");
        model.addColumn("Phone");
        model.addColumn("Address");

        table.getColumnModel().getColumn(0).setPreferredWidth(100);
        table.getColumnModel().getColumn(1).setPreferredWidth(150);
        table.getColumnModel().getColumn(2).setPreferredWidth(200);
        table.getColumnModel().getColumn(3).setPreferredWidth(200);
        table.getColumnModel().getColumn(4).setPreferredWidth(200);

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
        buttonBack.addActionListener(new BackButton());

        JMenuItem menuItem = new JMenuItem("Delete");
        menuItem.addActionListener(new DeleteButton());
        contextMenu.add(menuItem);
        // add items

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

        // fill table rows beforehand
        update();
    }

    private void fillTable(DefaultTableModel model, ResultSet rs) {
        model.setRowCount(0);
        if (rs != null) {
            try {
                while (rs.next()) {
                    int id = rs.getInt("emp_id");
                    String email = rs.getString("email");
                    String address = rs.getString("address");
                    String name = rs.getString("name");
                    String phone = rs.getString("phone_number");
                    model.addRow(new Object[]{String.format("%08d", id), name, email, phone, address});
                }
            } catch (SQLException e) {
                // stop
            }
        }
    }

    private void update() {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        query.append("SELECT * FROM Employee WHERE LOWER(name) LIKE LOWER('%");
        query.append(textName.getText());
        query.append("%')");

        String id = textID.getText();

        if (id.length() != 0) {
            query.append(" AND emp_id = ");
            query.append(id);
        }

        query.append(" ORDER BY emp_id");

        fillTable(model, Pharmacy_DB.getResults(query.toString()));

        message.append(model.getRowCount());
        message.append(" results found.");

        searchMessage.setText(message.toString());
        revalidate();
        repaint();
    }

    private void deleteEmployee(int id) throws SQLException {
        StringBuilder query = new StringBuilder();
        StringBuilder message = new StringBuilder();

        query.append("DELETE FROM Employee WHERE emp_id = ");
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

    private class DeleteButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            int n = JOptionPane.showConfirmDialog(
                    Pharmacy_DB.getEmployeeLookupPanel(),
                    "Are you sure you want to delete the following employee?\n\n" +
                            "(" + table.getValueAt(table.getSelectedRow(), 0).toString() + ") " +
                            table.getValueAt(table.getSelectedRow(), 1).toString() + "\n\n",
                    "Delete Employee",
                    JOptionPane.YES_NO_OPTION);
            if (n == YES_OPTION) {
                try {
                    // check for result > 0???
                    deleteEmployee(Integer.parseInt(table.getValueAt(table.getSelectedRow(), 0).toString()));
                    JOptionPane.showMessageDialog(Pharmacy_DB.getEmployeeLookupPanel(),
                            "Employee successfully deleted.",
                            "Delete Employee",
                            JOptionPane.PLAIN_MESSAGE);
                } catch (SQLException ex) {
                    JOptionPane.showMessageDialog(Pharmacy_DB.getEmployeeLookupPanel(),
                            "Unexpected error. Could not delete employee.",
                            "Delete Employee",
                            JOptionPane.ERROR_MESSAGE);
                }
            }
        }
    }

}
