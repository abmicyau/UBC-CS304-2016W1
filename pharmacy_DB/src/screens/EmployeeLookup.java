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

    private DetailsDialog detailsDialog = new DetailsDialog();

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

        table.getColumnModel().getColumn(0).setPreferredWidth(150);
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
                BorderFactory.createEtchedBorder(), "Employees"));

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
                    String name = rs.getString("name");
                    String phone = rs.getString("phone_number");
                    model.addRow(new Object[]{String.format("%08d", id), name, email, phone});
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

    private class DetailsButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            String idString = table.getValueAt(table.getSelectedRow(), 0).toString();
            int id = Integer.parseInt(idString);

            try {
                detailsDialog.updateInfo(id);
                detailsDialog.pack();
                detailsDialog.setLocationRelativeTo(Pharmacy_DB.getEmployeeLookupPanel());
                detailsDialog.setVisible(true);
            } catch (SQLException ex) {
                // TODO: change this to a dialog
                System.out.println("Unexpected error");
            }
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

    private class DetailsDialog extends JDialog implements ActionListener {

        private JPanel dialogPanel = new JPanel(new GridBagLayout());
        private JButton closeButton = new JButton("Close");

        // labels
        private JLabel label1 = new JLabel("<html><b>Basic Information</b></html>");
        private JLabel label1_1 = new JLabel("Employee ID: ");
        private JLabel label1_2 = new JLabel("Name: ");
        private JLabel label1_3 = new JLabel("Email: ");
        private JLabel label1_4 = new JLabel("Phone #: ");
        private JLabel label1_5 = new JLabel("Address: ");
        private JLabel label2 = new JLabel("<html><b>Additional Information</b></html>");
        private JLabel label2_1 = new JLabel("Position: ");
        private JLabel label2_2 = new JLabel("License #: ");

        // info
        private JLabel info1_1 = new JLabel("");
        private JLabel info1_2 = new JLabel("");
        private JLabel info1_3 = new JLabel("");
        private JLabel info1_4 = new JLabel("");
        private JLabel info1_5 = new JLabel("");
        private JLabel info2_1 = new JLabel("");
        private JLabel info2_2 = new JLabel("");

        public DetailsDialog() {

            setTitle("Employee Details");
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
            dialogPanel.add(label1_4, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info1_4, constraints);

            constraints.gridy = 5;
            constraints.gridx = 0;
            dialogPanel.add(label1_5, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info1_5, constraints);

            constraints.gridwidth = 2;
            constraints.insets.set(5, 10, 5, 10);
            constraints.gridx = 0;
            constraints.gridy = 6;
            dialogPanel.add(label2, constraints);

            constraints.gridwidth = 1;
            constraints.insets.set(5, 20, 5, 10);
            constraints.gridy = 7;
            dialogPanel.add(label2_1, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info2_1, constraints);

            constraints.gridy = 8;
            constraints.gridx = 0;
            dialogPanel.add(label2_2, constraints);
            constraints.gridx = 1;
            dialogPanel.add(info2_2, constraints);

            constraints.insets.set(15, 10, 10, 10);
            constraints.gridx = 0;
            constraints.gridy = 9;
            dialogPanel.add(closeButton, constraints);

            closeButton.addActionListener(this);

            setDefaultCloseOperation(WindowConstants.DISPOSE_ON_CLOSE);
            setContentPane(dialogPanel);

        }

        public void updateInfo(int id) throws SQLException {
            ResultSet rs = Pharmacy_DB.getResults("SELECT * FROM Employee WHERE emp_id = " + id);

            if (rs.next()) {
                String emp_id = rs.getString("emp_id");

                info1_1.setText(rs.getString("emp_id"));
                info1_2.setText(rs.getString("name"));
                info1_3.setText(rs.getString("email"));
                info1_4.setText(rs.getString("phone_number"));
                info1_5.setText(rs.getString("address"));

                ResultSet rs2 = Pharmacy_DB.getResults("SELECT * FROM Pharmacy_Assistant WHERE emp_id = " + id);
                ResultSet rs3 = Pharmacy_DB.getResults("SELECT * FROM Pharmacist WHERE emp_id = " + id);
                ResultSet rs4 = Pharmacy_DB.getResults("SELECT * FROM Pharmacy_Technician WHERE emp_id = " + id);

                if (rs2.next()) {
                    info2_1.setText("Pharmacy Assistant");
                    info2_2.setText("N/A");
                } else if (rs3.next()) {
                    info2_1.setText("Pharmacist");
                    info2_2.setText(rs3.getString("license_number"));
                } else if (rs4.next()) {
                    info2_1.setText("Pharmacy Technician");
                    info2_2.setText(rs4.getString("license_number"));
                } else {
                    info2_1.setText("N/A");
                    info2_2.setText("N/A");
                }

            } else {
                throw new SQLException();
            }
        }

        public void actionPerformed(ActionEvent e) {
            dispose();
        }
    }

}
