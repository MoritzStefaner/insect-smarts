float MIN_SPEED = 1.0f;
float MAX_SPEED = 4.0f;
float WIGGLE_ANGLE = 20.0f;

class Vehicle {
  
  PVector location;
  float angle;
  
  Vehicle(){
    location = new PVector(500,200,0);
    angle = random(360);
  }
  
  void update(){
    // check environment
    float light = brightness(get((int)location.x, (int)location.y));
    
    if(light > 0){
      // flee!
      float speed = (light - 127) / 25.0f;
      if(speed > MAX_SPEED){
        speed = MAX_SPEED;
        // wiggle!
        wiggle();
      }
      if(speed < MIN_SPEED){
        speed = MIN_SPEED;
      }
      
      PVector newLocation = new PVector(
        location.x + sin((float)(angle*Math.PI/180)) * speed, 
        location.y - cos((float)(angle*Math.PI/180)) * speed
      );

      // wrap around
      location.x = (newLocation.x + width) % width;
      location.y = (newLocation.y + height) % height; 
    }
  }
  
  void wiggle(){
    angle = angle + (random(WIGGLE_ANGLE) - (WIGGLE_ANGLE/2.0f));
  }

  void render(){
    pushMatrix();
    translate(location.x, location.y);
    rotate((float)(angle * Math.PI / 180));
    image(vehicleImage, 0, 0);
    popMatrix();
  }
}
