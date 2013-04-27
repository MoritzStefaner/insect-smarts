
class Ant {

  PVector location;
  PVector direction;
  PVector home;
  Boolean carriesFood = false;
  Boolean action = false;
  ArrayList<PVector> history = new ArrayList<PVector>();
  int maxHistoryLength = 50;
  int pheroPower = 0;

  Ant() {

    home = new PVector(width/2, height/2);
    location = new PVector(home.x, home.y);
    direction = pickDirection();
  }

  PVector pickDirection() {
    // first, check pheroMap
    int bestPhero = 255;
    int pheroTest = 255;
    PVector newDirection = new PVector(0,0);

    int numSteps = 32;
    float start = random(1f);
    for (int i=0; i<numSteps; i++){
      float angle = (start+1.0f*i/numSteps)*2*3.1415;
      PVector testDirection = new PVector((float) Math.cos(angle), (float) Math.sin(angle));
      color col = pheroMap.get((int) (location.x+testDirection.x + width) % width, (int) (location.y + testDirection.y + height) % height );
      pheroTest = (int) green(col);
      
      if( pheroTest < bestPhero){
          newDirection = testDirection;
          bestPhero = pheroTest;
      }
    }


    if(newDirection.mag()>.001) {

      return newDirection;
    }
    newDirection = new PVector(random(100)-50,random(100)-50);
    newDirection.setMag(1);
    return newDirection;
  }

  void run() {
    update();
    render();
  }


  Boolean isAtHome() {
    return new PVector(location.x-home.x, location.y-home.y).mag()<10;
  }
 
  // Method to update location
  void update() {
    if(!carriesFood && random(100)>80 && green(pheroMap.get((int)location.x, (int)location.y))==255) {
      direction = pickDirection();
    }

    if(carriesFood){
      direction = new PVector(home.x - location.x, home.y - location.y);
      direction.setMag(1);
    }

    if(isAtHome() && carriesFood){
      dropFood(location);
      pickDirection();
    }

    PVector nextPos = new PVector (location.x, location.y);
    nextPos.add(direction);
    

    nextPos.x = (nextPos.x + width) % width;
    nextPos.y = (nextPos.y + height) % height;
    
    // println(nextPos.x);

    color col = foodMap.get((int) nextPos.x, (int) nextPos.y);

    if(brightness(col) < 255){
        action = true;

        if(carriesFood){
          // try to drop food
          carriesFood = !dropFood(location);
          nextPos = location;
        } else {
          // pick up food
          carriesFood = pickUpFood(nextPos);
        }
    } else{
      action = false;
    }
    location = nextPos;

    if(carriesFood && pheroPower>0){
      pheroMap.stroke(255, 0, 100, pheroPower);
      pheroMap.strokeWeight(5);
      pheroMap.point(location.x, location.y);
      pheroPower--;
    }

  }

  Boolean pickUpFood(PVector location) {
    foodMap.stroke(255);
    foodMap.strokeWeight(3);
    foodMap.point((int) location.x, (int) location.y);
    pheroPower = (int) (new PVector(home.x - location.x, home.y - location.y).mag()*.66);
    return true;
  }
  
  Boolean dropFood(PVector location) {
    foodMap.stroke(0);
    foodMap.strokeWeight(1);
    carriesFood = false;
    //foodMap.point((int) location.x, (int) location.y);
    return true;
  }

  void render() {
    
    if(action){
      stroke(255,0,0);  
      strokeWeight(2); 
    } else {

      if(carriesFood){
        stroke(0); 
        strokeWeight(3);  
      } else {
        stroke(0,150); 
        strokeWeight(2);  
      } 
    }
    point(location.x, location.y);
  }
}
