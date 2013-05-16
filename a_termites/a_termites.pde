import eu.stefaner.insectsmarts.*;

// Termites clean up my living roon

ArrayList<Termite> termites;
PGraphics foodMap;
PImage foodMapImage;

int MAP_WIDTH = 100;
int MAP_HEIGHT = 100;
int SCALE = 1;



void setup() {
  ImageSaver.userName = "someone";

  size(MAP_WIDTH*SCALE,MAP_HEIGHT*SCALE);

  frameRate(50);

  int NUM_TERMITES = width*height/10;
  //NUM_TERMITES = 1;
  
  termites = new ArrayList<Termite>();
  // Add an initial set of termites into the system
  for (int i = 0; i < NUM_TERMITES; i++) {
    //for (int i = 0; i < 10; i++) {
    Termite t = new Termite();
    termites.add(t);
  }
  
  foodMap = createGraphics(width, height);
  foodMap.beginDraw();
  foodMap.background(255);
  foodMap.noFill();
  foodMap.noSmooth();
  foodMap.strokeWeight(1);
  foodMap.stroke(0);
  
  int total = 0;
  for(int i=0; i< width; i++){
    for(int j=0; j<height; j++){
      if(random(100)>70){
        foodMap.point(i,j);
        total++;
      }
  }  
  println("total " + total);
  foodMap.endDraw();
  }
}

void draw() {
  
  background(255);
  scale(SCALE);
  noSmooth();
  
  foodMap.beginDraw();
  foodMap.noFill();
  foodMap.noSmooth();
  foodMap.strokeWeight(1);

  for (Termite t : termites) {
      t.update(); 
  }
  
  foodMap.endDraw();
  image(foodMap, 0, 0);
    
  for (Termite t : termites) {
      t.draw(); 
  }
}

void keyPressed(){
  ImageSaver.saveAndPost(this);
}


