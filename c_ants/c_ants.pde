// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

ArrayList<Ant> ants;
PGraphics foodMap;
PGraphics pheroMap;
PImage foodMapImage;

void setup() {
  size(700,700, P2D);
  frameRate(40);
  
  pheroMap = createGraphics(width, height);
  pheroMap.beginDraw();
  pheroMap.background(255);
  pheroMap.endDraw();

  foodMap = createGraphics(width, height);
  foodMap.beginDraw();
  foodMap.background(255);
  foodMap.noFill();

  foodMap.strokeWeight(8);
  
  
  for(int i=0; i< width; i++){
    for(int j=0; j<height; j++){
      if(noise(i*.01,j*.01)>.65){
        foodMap.stroke(0, (int)(noise(i*.01,j*.01)*60), (int)(noise(i*.01,j*.01)*30));
        foodMap.point(i,j);
      }
  }  
  foodMap.endDraw();
  }

   ants = new ArrayList<Ant>();
  // Add an initial set of ants into the system
  for (int i = 0; i < width*height/500; i++) {
    //for (int i = 0; i < 10; i++) {
    Ant t = new Ant();
    ants.add(t);
  }
}

void draw() {


  background(255, 250, 220);
  
  image(foodMap, 0, 0);

  tint(255, 200);
  image(pheroMap, 0, 0);
  

  pheroMap.beginDraw();
  // fade out pheroMap
  pheroMap.noStroke();
  pheroMap.noSmooth();
  pheroMap.fill(255, 255, 255, 1);
  pheroMap.rect(0,0,width,height);

  foodMap.beginDraw();
  foodMap.noFill();
  foodMap.noSmooth();
  foodMap.strokeWeight(1);
  
  int numFood = 0;
  for (Ant t : ants) {
      t.run(); 
  }

  foodMap.endDraw();
  pheroMap.endDraw();

  stroke(0);
  strokeWeight(20);
  point(width/2, height/2);
  
 // println(numFood);
}


