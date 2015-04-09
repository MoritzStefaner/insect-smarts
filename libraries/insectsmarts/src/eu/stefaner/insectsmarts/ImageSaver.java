package eu.stefaner.insectsmarts;

import java.io.File;
import java.io.IOException;

import processing.core.PApplet;

import com.tumblr.jumblr.JumblrClient;
import com.tumblr.jumblr.types.PhotoPost;

public class ImageSaver {
	private static JumblrClient client;
	public static String event = "Insect Smarts Workshop / resonate 2015";
	public static String userName = "someone";

	/*
	// Create a new client
		  JumblrClient client = new JumblrClient("cPq3G0ZmmMsNdkOPrtKJenMJTQqd6WTIikG2EQRKISVLzLfbTj", "ilpS2Y0N7FFJkrp4czwu791BYE8lxpCmcjX6H9q9VV5fiHgKTO");
		  client.setToken("ChmgQIRqXXGelIMAqsNxIQEwgi0sCqYiA5yaZMSaeAGmzAIQPC", "3iwMO8la57AgRN3xyuMvSflBjYQ7xK5dolJgDJvWsl94gJdjx0");

		  // Write the user's name
		  User user = client.user();
		  System.out.println(user.getName());

		  line(20, 20, 80, 80);
		  save("diagonal.jpg");
		  try {
		    PhotoPost pp = new PhotoPost();
		    pp.setClient(client);
		    pp.setBlogName("insect-smarts");
		    pp.setData(new File(sketchPath("diagonal.jpg")));
		    pp.setCaption("Caption goes here");
		    pp.save();
		  }
		  catch (IOException e) {
		  }
	*/
	{

	}

	public static String save(PApplet p) {
		String path = "output/" + userName + "_" + getTimeStamp(p) + ".png";
		p.save(path);
		p.println("ImageSaver: saved " + path);
		return path;
	}

	public static void saveAndPost(PApplet p) {

		try {
			if(client == null){
				client = new JumblrClient("cPq3G0ZmmMsNdkOPrtKJenMJTQqd6WTIikG2EQRKISVLzLfbTj", "ilpS2Y0N7FFJkrp4czwu791BYE8lxpCmcjX6H9q9VV5fiHgKTO");
				client.setToken("ChmgQIRqXXGelIMAqsNxIQEwgi0sCqYiA5yaZMSaeAGmzAIQPC", "3iwMO8la57AgRN3xyuMvSflBjYQ7xK5dolJgDJvWsl94gJdjx0");
			}

			String path = save(p);

			PhotoPost pp = new PhotoPost();
			pp.setClient(client);
			pp.setBlogName("insect-smarts");
			pp.setData(new File(p.sketchPath(path)));
			pp.setCaption("Created by " + userName + " at " + " "+ event + " " +getTimeStamp(p));
			pp.save();
			p.println("ImageSaver: posted " + path);
		} catch (IOException e) {
		}
	}

	private static String getTimeStamp(PApplet p) {
		return p.year() + "-" + p.nf(p.month(), 2) + "-" + p.nf(p.day(), 2) + "-" + p.nf(p.hour(), 2) + "-" + p.nf(p.minute(), 2) + "-" + p.nf(p.second(), 2);
	}
}
