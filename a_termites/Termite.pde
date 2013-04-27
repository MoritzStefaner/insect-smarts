
class Termite {

  PVector location;
  PVector direction;
  Boolean carriesFood = false;
  Boolean action = false;
  ArrayList<PVector> history = new ArrayList<PVector>();
  int maxHistoryLength = 50;

  Termite() {
    location = new PVector((int)random(width),(int)random(height));
    direction = pickRandomDirection();
  }

  PVector pickRandomDirection() {
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
  }

  void run() {
    update();
    // render();
  }

 
  // Method to update location
  void update() {
    PVector nextPos = new PVector (location.x, location.y);
    nextPos.add(direction);
    /*
    if (random(100)>33){
      nextPos.x += 1;
    }
    if (random(100)>33){
      nextPos.x -= 1;
    }
    if (random(100)>33){
      nextPos.y -= 1;
    }
    if (random(100)>33){
      nextPos.y += 1;
    }
    */

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

  }

  Boolean pickUpFood(PVector location) {
    foodMap.stroke(255);
    foodMap.strokeWeight(1);
    foodMap.point((int) location.x, (int) location.y);
    return true;
  }
  
  Boolean dropFood(PVector location) {
    foodMap.stroke(0);
    foodMap.strokeWeight(1);
    foodMap.point((int) location.x, (int) location.y);
    return true;
  }

  void render() {
    noSmooth();
    if(action){
      stroke(255,0,0);  
      strokeWeight(1); 
    } else {

      if(carriesFood){
        stroke(0); 
        strokeWeight(1);  
      } else {
        stroke(128); 
        strokeWeight(1);  
      } 
    }
    point(location.x, location.y);
  }
}
