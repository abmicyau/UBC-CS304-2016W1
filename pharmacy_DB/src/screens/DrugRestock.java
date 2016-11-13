package screens;

import main.Pharmacy_DB;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;

public class DrugRestock extends JPanel {


    private JButton buttonBack = new JButton("Back");

    private GridBagConstraints constraints = new GridBagConstraints();

    public DrugRestock() {

        super(new GridBagLayout());

    }

    private class SearchButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {

        }
    }

    private class BackButton implements ActionListener {
        public void actionPerformed(ActionEvent e) {
            Pharmacy_DB.switchScreen(Pharmacy_DB.getHomePanel());
        }
    }

}
