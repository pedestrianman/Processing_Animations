class Mover {

  PVector position;
  float pos_ang;
  float vel_ang;
  PImage planet_img;
  float radius_orbita;
  float radius_planeta;
  ArrayList<PVector> points = new ArrayList<PVector>(); 

  Mover(float p_ang, float velocidad_angular, float radio_orbita, float radio_planeta, PImage imagen_planeta) {

    pos_ang = p_ang;
    position = new PVector(radio_orbita*cos(p_ang), radio_orbita*sin(p_ang));
    vel_ang = velocidad_angular;
    planet_img = imagen_planeta;
    radius_orbita = radio_orbita;
    radius_planeta = radio_planeta;
  }


  void display() {
    imageMode(CENTER);
    image(planet_img, position.x, position.y, radius_planeta, radius_planeta);
  }

  void update() {
    pos_ang += vel_ang*0.055;
    position.x = radius_orbita*cos(pos_ang);
    position.y = radius_orbita*sin(pos_ang);
  }
  
  void add_points_trajectory(PVector position){
    points.add(position);
  }
}
