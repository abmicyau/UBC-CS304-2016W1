package screens;

import main.Pharmacy_DB;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;
/**
 * Created by Victor on 2016-11-16.
 */
public class RecordDeletion extends JPanel{

    //private JLabel recordSearch = new JLabel("Search: ");
    private JLabel labelID = new JLabel("ID: ");
    private JTextField textID = new JTextField(6);

    private JButton buttonDelete = new JButton("Delete");
    private JButton buttonBack = new JButton("Back");

    private JLabel deleteMessage = new JLabel("");

    private GridBagConstraints constraints = new GridBagConstraints();

    public RecordDeletion(){

        // important! call JPanel constructor and pass GridBagLayout
        super(new GridBagLayout());

        constraints.insets = new Insets(10, 10, 5, 10);
        constraints.gridx = 0;
        constraints.gridy = 0;
        constraints.gridwidth = 3;
        constraints.anchor = GridBagConstraints.WEST;
        add(labelID, constraints);

        constraints.gridy = 1;
        add(textID, constraints);

        //Sets up buttons
        constraints.gridy = 2;
        constraints.gridwidth = 2;
        add(buttonDelete, constraints);

        constraints.gridy = 3;
        add(buttonBack, constraints);

        //Listeners
        buttonBack.addActionListener(new BackButton());
        buttonDelete.addActionListener(new DeleteButton());
    }

    private class BackButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
        }
    }

    private class DeleteButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            String ID = textID.getText().trim();

            if (ID.isEmpty()) {
                deleteMessage.setText("You must enter an appropriate ID!");
            }
            else {
                Pharmacy_DB.switchScreen(new DeletionConfirmation(ID));
            }
        }
    }

    private class DeletionConfirmation extends JPanel {
        private JButton buttonBack = new JButton("Back");
        private JButton buttonConfirm = new JButton("Confirm");
        private JLabel confirmMessage = new JLabel("");
        private String deleteQuery = "";

        public DeletionConfirmation(String ID){
            super(new GridBagLayout());

            GridBagConstraints constraints = new GridBagConstraints();
            constraints.insets = new Insets(10,10,10,10);
            constraints.gridx = 0;
            constraints.gridy = 0;
            add(confirmMessage,constraints);

            String query = "SELECT customer_id FROM Customer WHERE customer_id=" + ID;

            ResultSet results = Pharmacy_DB.getResults(query);

            setBorder(BorderFactory.createTitledBorder(
                    BorderFactory.createEtchedBorder(), "Delete Record"));

            try {
                if (results != null && results.next()) {
                    confirmMessage.setText("Are you sure you would like to delete the following record?");
                    constraints.gridy = 1;
                    add(new JLabel(results.getString("customer_id")), constraints);
                    constraints.gridy = 2;
                    add(buttonConfirm, constraints);
                    constraints.gridy = 3;
                    add(buttonBack, constraints);
                    deleteQuery = "DELETE FROM Customer WHERE customer_id =" + ID;
                } else {
                    confirmMessage.setText("ID not found.");
                    constraints.gridy = 1;
                    add(buttonBack, constraints);
                }
            } catch (SQLException e) {
                confirmMessage.setText("ID not found.");
                constraints.gridy = 1;
                add(buttonBack, constraints);
            }

            buttonBack.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    Pharmacy_DB.switchScreen(Pharmacy_DB.getRecordDeletion());
                }
            });

            buttonConfirm.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {

                    if (Pharmacy_DB.executeUpdate(deleteQuery) > 0) {
                        deleteMessage.setText("Successfully deleted.");
                    } else {
                        deleteMessage.setText("Unexpected error.");
                    }

                    Pharmacy_DB.switchScreen(Pharmacy_DB.getRecordDeletion());
                }
            });
        }
    }

}
