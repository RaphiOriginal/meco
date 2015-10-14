import java.awt.Dimension;

import javax.media.Player;
import javax.swing.JFrame;

public class MiniPlayer extends JFrame implements Runnable{
	
	public MiniPlayer(Player p){
		setTitle("MiniPlayer");
		setPreferredSize(new Dimension(100, 100));
		
		setVisible(true);
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
		
	}

}
