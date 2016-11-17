package models;

import javax.swing.table.DefaultTableModel;

public class DBTableModel extends DefaultTableModel {

    @Override
    public boolean isCellEditable(int row, int column){
        return false;
    }
}
