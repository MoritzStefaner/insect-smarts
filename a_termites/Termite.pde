
class Termite {

  PVector location;
  PVector velocity;
  Boolean carriesWood = false;
  Boolean action = false;

  Termite() {
    location = new PVector((int) random(MAP_WIDTH),(int) random(MAP_HEIGHT));
    velocity = pickRandomVelocity();
  }

  PVector pickRandomVelocity() {
    /*
    PVector v = new PVector(random(-1,1),random(-1,1));
    v.setMag(1);
    return v;
    */
    switch((int)random(4)){
      case 0:
        return new PVector(1,0);
      case 1:
        return new PVector(-1,0);
      case 2:
        return new PVector(0,1);
    }
    return new PVector(0,-1);
    
  }
 
  // Method to update location
  void update() {
    PVector nextPos = new PVector (location.x, location.y);
    nextPos.add(velocity);

    nextPos.x = (nextPos.x + MAP_WIDTH) % MAP_WIDTH;
    nextPos.y = (nextPos.y + MAP_HEIGHT) % MAP_HEIGHT;
    
    action = false;

    if(thereIsWoodAt(nextPos)){
        if(carriesWood){
          // try to drop food
          carriesWood = !dropWood(location);
          if(!carriesWood){
            action = true;
          }
        } else {
          // pick up food
          carriesWood = pickUpWood(nextPos);
          action = true;
        }
        
        location.x -= velocity.x;
        location.y -= velocity.y;
        velocity = pickRandomVelocity();
    } else{
      location = nextPos;  
    }
  }

  Boolean pickUpWood(PVector location) {
    woodMap.stroke(255);
    woodMap.strokeWeight(1);
    woodMap.point((int) location.x, (int) location.y);

    return true;
  }
  
  Boolean dropWood(PVector location) {
    location.x = (location.x + MAP_WIDTH) % MAP_WIDTH;
    location.y = (location.y + MAP_HEIGHT) % MAP_HEIGHT;
    if(thereIsWoodAt(location)){
      // there is food already here!
      return false ;
    } else {
      woodMap.stroke(0);
      woodMap.strokeWeight(1);
      woodMap.point((int) location.x, (int) location.y);
      return true;  
    }
    
  }

  Boolean thereIsWoodAt(PVector location){
    return brightness(woodMap.get((int) location.x, (int) location.y)) < 255;
  }

  void draw() {
    strokeWeight(1); 
    if(action){
      stroke(255,50,0);  
    } else {
      if(carriesWood){
        stroke(50); 
      } else {
        stroke(200); 
      } 
    }
    point(location.x, location.y);
  }
}
