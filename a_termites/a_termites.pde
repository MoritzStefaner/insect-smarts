// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

ArrayList<Termite> termites;
PGraphics foodMap;
PImage foodMapImage;

void setup() {
  size(200,200);
  frameRate(20);
  
  termites = new ArrayList<Termite>();
  // Add an initial set of termites into the system
  for (int i = 0; i < width*height/10; i++) {
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
  
  for(int i=0; i< width; i++){
    for(int j=0; j<height; j++){
      if(random(100)>80){
        foodMap.point(i,j);
      }
  }  
  foodMap.endDraw();
  }
}

void draw() {
  background(255, 250, 220);
  
  foodMap.beginDraw();
  foodMap.noFill();
  foodMap.noSmooth();
  foodMap.strokeWeight(1);
  int numFood = 0;
  for (Termite t : termites) {
      t.run(); 
  }
  for (Termite t : termites) {
      if (t.carriesFood) numFood++;
  }
  for(int i=0; i< width; i++){
    for(int j=0; j<height; j++){
      if(brightness(foodMap.get(i,j))<255) numFood++;
    }  
  }

  foodMap.endDraw();

  image(foodMap, 0, 0);
  //println(numFood);
}


