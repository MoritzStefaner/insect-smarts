import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.io.IOException; 
import java.io.FileNotFoundException; 
import org.apache.commons.httpclient.HttpClient; 
import org.apache.commons.httpclient.HttpException; 
import org.apache.commons.httpclient.methods.MultipartPostMethod; 
import org.apache.commons.httpclient.methods.multipart.FilePart; 

import processing.core.*; 
import org.apache.commons.logging.*; 
import org.apache.commons.codec.net.*; 
import org.apache.commons.httpclient.methods.*; 
import org.apache.commons.codec.binary.*; 
import processing.xml.*; 
import org.apache.commons.logging.impl.*; 
import org.apache.commons.httpclient.protocol.*; 
import org.apache.commons.httpclient.cookie.*; 
import org.apache.commons.codec.digest.*; 
import org.apache.commons.codec.*; 
import org.apache.commons.httpclient.params.*; 
import org.apache.commons.codec.language.*; 
import org.apache.commons.httpclient.auth.*; 
import org.apache.commons.httpclient.methods.multipart.*; 
import org.apache.commons.httpclient.*; 
import org.apache.commons.httpclient.util.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TumblrP5 extends PApplet {

/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/34381*@* */
/* !do not delete the line above, required for linking your tweak if you re-upload */
/*
 **  TUMBLRWRITE CLASS 0.95
 **  Write posts to Tumblr from Processing
 **  Photo data uploads supported
 **
 **  Uses v1 of the Tumblr API:
 **  http://www.tumblr.com/docs/en/api
 **
 **  Henderson[Six] http://hendersonsix.com
 **  CC-BY-SA 2.0 
 */









class TumblrWrite {
  MultipartPostMethod method;
  HttpClient client;

  String tumblrApiUrl = "http://api.tumblr.com/v2/blog/insect-smarts.tumblr.com/";

  //CONSTRUCTOR
  TumblrWrite() throws IOException {
    client = new HttpClient();
  }

  public void init(String userEmail, String userPassword) {
    method = new MultipartPostMethod(tumblrApiUrl);
    method.addParameter("email", userEmail);
    method.addParameter("password", userPassword);
  }

  /****************** SET-UP POST METHODS *******************/

  //TEXT
  public void textPost(String title, String body) {
    System.out.println("Posting regular text...");  

    method.addParameter("type", "regular");
    method.addParameter("title", title);
    method.addParameter("body", body);
  }

  //PHOTO - Embeds a photo from a URL source
  public void photoLinkPost(String caption, String url, String clickThroughUrl) {
    System.out.println("Posting a photo link...");  

    method.addParameter("type", "photo");
    method.addParameter("source", url);
    method.addParameter("caption", caption);
    method.addParameter("click-through-url", clickThroughUrl);
  }

  //PHOTO-DATA - Uploads a photo from specified filepath
  public void photoDataPost(String caption, String filePath, String clickThroughUrl) throws FileNotFoundException {
    System.out.println("Uploading a photo...");

    File img = new File(filePath);
    method.addParameter("type", "photo");
    method.addParameter("data", img);
    method.addParameter("caption", caption);
    method.addParameter("click-through-url", clickThroughUrl);
  }

  //QUOTE
  public void quotePost(String quote, String source) {
    System.out.println("Posting a quote...");  

    method.addParameter("type", "quote");
    method.addParameter("quote", quote);
    method.addParameter("source", source);
  }

  //LINK
  public void linkPost(String name, String url, String description) {
    System.out.println("Posting a link...");

    method.addParameter("type", "link");
    method.addParameter("name", name);
    method.addParameter("url", url);
    method.addParameter("description", description);
  }

  //CONVERSATION
  public void conversationPost(String title, String conversation) {
    System.out.println("Posting a conversation...");

    method.addParameter("type", "conversation");
    method.addParameter("title", title);
    method.addParameter("conversation", conversation);
  }

  //VIDEO - Supply either a youtube URL or html embed code for url parameter
  public void videoLinkPost(String title, String url, String caption) {
    System.out.println("Posting an embedded video...");

    method.addParameter("type", "video");
    method.addParameter("embed", url);
    method.addParameter("caption", caption);
  }

  //VIDEO-DATA - Some issues with this at the moment.
  //Tumblr seems to integrate with Vimeo for video uploads so not sure exactly how this works.
  public void videoDataPost(String title, String filePath, String caption) throws FileNotFoundException {
    System.out.println("Uploading a video...");

    method.addParameter("type", "video");
    method.addParameter("data", filePath);
    method.addParameter("caption", caption);
  }

  //AUDIO - Supply source url of audio file - must be MP3 or AIFF
  public void audioLinkPost(String title, String url, String caption) {
    System.out.println("Posting embedded audio...");

    method.addParameter("type", "audio");
    method.addParameter("externally-hosted-url", url);
    method.addParameter("caption", caption);
  }

  //AUDIO-DATA - Tumblr API either suggests MP3 or AIFF format
  //Early testing shows that it doens't recognise .mp3 files as being mp3s
  public void audioDataPost(String title, String filePath, String caption)  throws FileNotFoundException {
    System.out.println("Uploading audio...");

    method.addParameter("type", "audio");
    method.addParameter("data", filePath);
    method.addParameter("caption", caption);
  }



  /****************** COMMON POST METHODS ******************/


  //A short description of the application making the request for tracking and statistics, such as "John's Widget 1.0". 
  //Must be 64 or fewer characters.
  public void setGenerator(String generator) {
    method.addParameter("generator", generator);
  }

  //The post date, if different from now, in the blog's timezone. 
  //Most unambiguous formats are accepted, such as '2007-12-01 14:50:02'
  //Dates must not be in the future.
  public void setDate(String date) {
    method.addParameter("date", date);
  }

  //Whether the post is private. 
  //Private posts only appear in the Dashboard or with authenticated links, and do not appear on the blog's main page.
  public void setPrivacy(boolean privacy) {
    if (privacy==true) {
      method.addParameter("privacy", "1");
    }
    else {
      method.addParameter("privacy", "0");
    }
  }

  // Comma-separated list of post tags.
  public void setTags(String commaSeperatedTags) {
    method.addParameter("tags", commaSeperatedTags);
  }

  //html or markdown
  public void setFormat(String format) {
    method.addParameter("format", format);
  }

  //Post this to a secondary blog on your account, e.g. mygroup.tumblr.com (for public groups only)
  public void setGroup(String myGroup) {
    method.addParameter("group", myGroup);
  }

  //A custom string to appear in the post's URL: myblog.tumblr.com/post/123456/this-string-right-here.
  //Max 55 characters
  public void setSlug(String slug) {
    method.addParameter("slug", slug);
  }  

  // One of the following values: published, draft, submission, queue, publish-on=YYYY-MM-DDT13:34:00
  public void setPostState(String state) {
    method.addParameter("state", state);
  }

  //(optional, ignored on edits)
  //One of the following values, if the tumblelog has Twitter integration enabled:
  //no (default), auto (post summary), custom message
  public void sendToTwitter(String state) {
    method.addParameter("send-to-twitter", state);
  }

  /****************** SEND POST METHOD ******************/

  public void sendData() throws IOException {
    try {
      client.executeMethod(method);
      String response = method.getResponseBodyAsString();
      System.out.println(response);
      method.releaseConnection();
    }
    catch(IOException e) {
      e.printStackTrace();
    }
  }
}

/*
**  TumblrWrite Example
**  Henderson[Six]
**
**  Posts must first be initialised using the init(username, password) method.
**  This authenticates your proposed post, and prepares it for sending to the primary blog on that account.
**  You can attach any attributes to that post with all the setXXXXXXX() methods - 
**  - eg setTags(), setPrivacy(), sendToTwitter(), publish on a specific time/date etc.
**  sendData() should be called last, and uploads your post and the specified parameters for publishing on tumblr.
*/

TumblrWrite t;

String username = "me@der-mo.net";
String password = "17blumen";

public void setup() {
  try {
    t = new TumblrWrite();
  }
  catch(IOException e) {
    e.printStackTrace();
  }
}

public void draw() {
  background(0);
}

public void keyPressed() {
  try {
    switch(key) {
      
      //PHOTO-LINK POST
    case 'p':
      t.init(username, password);
      t.photoLinkPost("Proce55ing", "http://processing.org/img/cover/onefive.png", "http://processing.org/");
      t.setTags("Image, Processing");
      t.sendData();
      break;
      
      //PHOTO-UPLOAD POST
    case 'u':
      t.init(username, password);
      t.photoDataPost("Title", "absolute-path-to-file", "click-through-url");
      t.sendToTwitter("auto");
      t.sendData();
      break;
      
      //REGULAR TEXT POST
    case 't':
      t.init(username, password);
      t.textPost("Processing", "Processing is an open source programming language and environment for people who want to create images, animations, and interactions.");
      t.setTags("Digital Art, Processing");
      t.sendData();
      break;
      
      //QUOTE POST
    case 'q':
      t.init(username, password);
      t.quotePost("Fail again. Fail better", "http://en.wikipedia.org/wiki/Samuel_Beckett");
      t.setSlug("A-Beckett-Quote");
      t.sendData();
      break;
      
      //LINK POST
    case 'l':
      t.init(username, password);
      t.linkPost("Processing", "http://processing.org", "Processing is an open source programming language and environment for people who want to create images, animations, and interactions.");
      t.setPostState("published");
      t.sendData();
      break;
    }
  }
  catch(IOException e) {
    e.printStackTrace();
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TumblrP5" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
