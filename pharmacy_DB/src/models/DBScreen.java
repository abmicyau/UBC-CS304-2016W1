package models;

import javax.swing.*;
import java.awt.*;

/**
 * Created by Michael on 2016-11-21.
 */
public class DBScreen extends JPanel {

    public DBScreen(LayoutManager layout) {
        super(layout);
    }

    public void refresh() {
        revalidate();
        repaint();
    }
}
