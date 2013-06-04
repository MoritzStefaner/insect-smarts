float AXON_SPEED = .0005;

class Axon{
	Neuron source;
	Neuron target;
	float strength; 
	float length; 

	Boolean isFiring = false;
	float fireProgress = 0; 
	
	Axon (Neuron s, Neuron t){
		source = s;
		target = t;
		length = new PVector(source.x - target.x, source.y - target.y).mag();
		strength = random(1);
	}

	void run(){
		render();
		if(isFiring){
			fireProgress +=AXON_SPEED * length;
			if(fireProgress>.99){
				target.activation += strength;
				isFiring = false;
				fireProgress = 0;
			}
		}
	}

	void render(){
		stroke(0, 0, 1, .3*strength);
		strokeWeight(3 * strength);
		line(source.x, source.y, target.x, target.y);
		if(isFiring){
			stroke(0, 0, 1);
			point(map(fireProgress, 0, 1, source.x, target.x), map(fireProgress, 0, 1, source.y, target.y));
		}
	}

	void fire(){
		isFiring = true;
		fireProgress = 0;
	}
}