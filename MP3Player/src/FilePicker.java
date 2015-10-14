import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.LinkedList;

import javax.media.Format;
import javax.media.Manager;
import javax.media.MediaLocator;
import javax.media.Player;
import javax.media.PlugInManager;
import javax.media.format.AudioFormat;
import javax.swing.JApplet;
import javax.swing.JButton;
import javax.swing.JFileChooser;

public class FilePicker extends JApplet implements ActionListener{
	private LinkedList<Thread> playerList = new LinkedList<Thread>();
	private JFileChooser chooser = new JFileChooser();
	private Player p;
	private JButton open = new JButton("Open");
	
	public FilePicker(){
		//setTitle("Player");
		//setDefaultCloseOperation(EXIT_ON_CLOSE);
		setPreferredSize(new Dimension(100, 100));
		
		setLayout(new FlowLayout());
		chooser.addActionListener(this);
		chooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
        chooser.setDialogTitle("Öffnen");
        add(chooser);
		add(open);
		
		
		//pack();
		setVisible(true);
	}

	@Override
	public void actionPerformed(ActionEvent e) {
		if(e.getSource() instanceof JButton){
			MiniPlayer player = new MiniPlayer(p);
			Thread thread = new Thread(player);
			thread.start();
			playerList.add(thread);
		} else {
			Format inMP3 = new AudioFormat(AudioFormat.MPEGLAYER3);
	        Format inMPEG = new AudioFormat(AudioFormat.MPEG);
	        Format out = new AudioFormat(AudioFormat.LINEAR);
	        
	        PlugInManager.addPlugIn("com.sun.media.codec.audio.mp3.JavaDecoder", new Format[]{inMP3,inMPEG}, 
	        		new Format[]{out}, PlugInManager.CODEC);
	        try {
	        	p = Manager.createRealizedPlayer(new MediaLocator(chooser.getSelectedFile().toURI().toURL()));       	
			} catch (Exception err) {
				// TODO: handle exception
				err.printStackTrace();
			}
		}
	}

}
