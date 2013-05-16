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

void setup() {
  try {
    t = new TumblrWrite();
  }
  catch(IOException e) {
    e.printStackTrace();
  }
}

void draw() {
  background(0);
}

void keyPressed() {
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

