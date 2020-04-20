class Mover {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float mass;

  Mover(float vel_ini) {
    position = new PVector(width/2,height/2 - 225);
    velocity = new PVector(vel_ini,0);
    acceleration = new PVector(0,0);
    mass = 0.000001;
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force,mass);
    acceleration.add(f);
  }
  
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0);
  }

  void display(int indx_part) {
    stroke(0);
    strokeWeight(2);
    fill(colors[indx_part]);
    ellipse(position.x,position.y,12.5,12.5);
  }

  void checkEdges() {

    if (position.x > width) {
      position.x = 0;
    } else if (position.x < 0) {
      position.x = width;
    }

    if (position.y > height) {
      velocity.y *= -1;
      position.y = height;
    }
    


  }

}
