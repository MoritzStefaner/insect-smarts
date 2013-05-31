
class Termite {

  PVector location;
  PVector direction;
  Boolean carriesFood = false;
  Boolean action = false;
  ArrayList<PVector> history = new ArrayList<PVector>();

  Termite() {
    location = new PVector((int) random(width),(int) random(height));
    direction = pickRandomDirection();
  }

  PVector pickRandomDirection() {
    return new PVector(random(-1,1),random(-1,1));
    /*
    int r = (int) random(4);

    switch(r){
      case 0:
        return new PVector(1,0);
      case 1:
        return new PVector(0,1);
      case 2:
        return new PVector(0,-1);
    }
    return new PVector(-1,0);
    */
  }

  void run() {
    update();
  }

 
  // Method to update location
  void update() {
    PVector nextPos = new PVector (location.x, location.y);
    nextPos.add(direction);

    nextPos.x = (nextPos.x + width) % width;
    nextPos.y = (nextPos.y + height) % height;

    color col = foodMap.get((int) nextPos.x, (int) nextPos.y);

    if(brightness(col) < 255){
        if(carriesFood){
          // try to drop food
          carriesFood = !dropFood(location);
        } else {
          // pick up food
          carriesFood = pickUpFood(nextPos);
        }
        action = true;
        direction = pickRandomDirection();
    } else{
      action = false;
      location = nextPos;  
    }

  }

  Boolean pickUpFood(PVector location) {
    foodMap.stroke(255);
    foodMap.strokeWeight(1);
    foodMap.point((int) location.x, (int) location.y);
    return true;
  }
  
  Boolean dropFood(PVector location) {
    color col = foodMap.get((int) location.x, (int) location.y);
    if(brightness(col) < 255){
      // there is food already here!
      return false; 
    } else {
      foodMap.stroke(0);
      foodMap.strokeWeight(1);
      foodMap.point((int) location.x, (int) location.y);
      return true;  
    }
    
  }

  void draw() {
    strokeWeight(1); 
    if(action){
      stroke(255,128,0);  
    } else {
      if(carriesFood){
        stroke(100); 
      } else {
        stroke(200); 
      } 
    }
    point(location.x, location.y);
  }
}
