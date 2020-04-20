
class Pendulum  {

  PVector position;    // position of pendulum ball
  PVector origin;      // position of arm origin
  float r;             // Length of arm
  float angle;         // Pendulum arm angle
  float aVelocity;     // Angle velocity
  float aAcceleration; // Angle acceleration
  float damping;       // Arbitary damping amount

  // This constructor could be improved to allow a greater variety of pendulums
  Pendulum(PVector origin_, float r_) {
    // Fill all variables
    origin = origin_.get();
    position = new PVector();
    r = r_;
    angle = PI/7;

    aVelocity = 0.0;
    aAcceleration = 0.0;
    damping = 1;   // Arbitrary damping
  }

  void go(int indx) {
    update();
    display(indx);
  }

  // Function to update position
  void update() {
    float gravity = 0.8;                              // Arbitrary constant
    aAcceleration = (-1 * gravity / r) * sin(angle);  // Calculate acceleration (see: http://www.myphysicslab.com/pendulum1.html)
    aVelocity += aAcceleration;                 // Increment velocity
    aVelocity *= damping;                       // Arbitrary damping
    angle += aVelocity;                         // Increment angle
  }

  void display(int indx) {
    position.set(r*sin(angle), r*cos(angle), 0);         // Polar to cartesian conversion
    position.add(origin);                              // Make sure the position is relative to the pendulum's origin

    stroke(255,255,255,100);
    strokeWeight(1);
    // Draw the arm
    line(origin.x, origin.y, position.x, position.y);
    ellipseMode(CENTER);
    noStroke();
    fill(colors[35 + 3*indx]);
    ellipse(position.x, position.y, 25,25);
    //imageMode(CENTER);
    //image(sun,position.x,position.y,30,30); 
  }

}
