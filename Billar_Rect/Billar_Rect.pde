
int cuerpos = 1;
Mover[] movers = new Mover[cuerpos];

boolean inside_out; // 1 if is outside
boolean corner_hit; // 1 if hit
int radius = 30;
float SSX = 8; // Rectangle Width
float SSY = 5; // Rectangle Height
float rel_xy = SSX/SSY;
int mod_vel = 2;
int cont = 0;

float scale = 100;
ArrayList<PVector> points = new ArrayList<PVector>(); //Trayectoria del atractor
ArrayList<PVector> corners = new ArrayList<PVector>();
ArrayList<PVector> TextPosition = new ArrayList<PVector>();
PFont mono;

//////////////////
/* INICIO SETUP */
//////////////////

void setup() {
  size(1000, 700);
  mono = createFont("font.ttf", 33);
  textFont(mono);
  movers[0] = new Mover(-SSX*scale/2, SSY*scale/2, mod_vel*cos(PI/4), -mod_vel*sin(PI/4), radius);
  corners.add(new PVector(-SSX*scale/2., SSY*scale/2., 0)); // Esquina Inferior Izda
  corners.add(new PVector(-SSX*scale/2., -SSY*scale/2., 0)); // Esquina Superior Izda
  corners.add(new PVector(SSX*scale/2., -SSY*scale/2., 0)); // Esquina Superior Dcha
  corners.add(new PVector(SSX*scale/2., SSY*scale/2., 0)); // Esquina Inferior Dcha
}

void draw() {
  background(25, 25, 25);
  noFill();
  strokeWeight(3);
  translate(width/2, height/2);

  textSize(45);
  fill(255, 255, 255, 150);
  text(nf((int)SSX, 1), -10, -SSY*scale/2. - 40);
  text(nf((int)SSY, 1), -SSX*scale/2. -40*rel_xy, 10*rel_xy);


  rectMode(CENTER);
  fill(44, 85, 69, 150);
  stroke(128, 64, 0);
  strokeWeight(7);
  rect(0, 0, SSX*scale, SSY*scale);

  inside_out = FindPoint(movers[0].position.x, movers[0].position.y, SSX*scale/2., SSY*scale/2.); 
  corner_hit = check_corners(movers[0].position.copy(), corners);

  if (corner_hit  && frameCount > 20) {
    movers[0].velocity.x = 0.0;
    movers[0].velocity.y = 0.0;
  } else if (inside_out && frameCount > 20) {

    cont ++;
    TextPosition.add(new PVector(movers[0].position.x, movers[0].position.y, cont));

    float sign_x =  movers[0].velocity.x/ abs(movers[0].velocity.x);
    float sign_y =  movers[0].velocity.y/ abs(movers[0].velocity.y);

    if (abs(movers[0].position.x) >= SSX*scale/2.) // Toco pared vertical
      movers[0].velocity.rotate(sign_x*sign_y*HALF_PI);
    else {
      movers[0].velocity.rotate(-sign_x*sign_y*HALF_PI);
    }
  }

  points.add(movers[0].position.copy());
  movers[0].update();
  movers[0].display();


  textSize(35);
  fill(255, 0, 0);
  for (PVector v : TextPosition) {
    text(nf((int)v.z, 1), v.x, v.y);
  }

  beginShape();
  for (PVector v : points) {
    noFill();
    strokeWeight(3);
    stroke(255, 70);
    vertex(v.x, v.y);
  }
  endShape();
  
  textSize(35);
  fill(255, 255, 255, 180);
  text("Rebounds = Length + Width - 2 ", -230, SSY*scale/2. + 40);
  
  textSize(35);
  fill(255, 255, 255, 180);
  text("@Inaki_Huarte", 250, 330);
  saveFrame("Output/frame_####.png");
}

// Routines

boolean FindPoint(float px, float py, float mid_w, float mid_h) {

  boolean inside_out;
  if (abs(px) <= mid_w & abs(py) <= mid_h) {
    inside_out = false;
  } else {
    inside_out = true;
  }
  return inside_out;
}

boolean check_corners(PVector position, ArrayList<PVector> corners) {

  boolean hit = false;
  PVector aux;
  float mod;

  for (PVector v : corners) {
    aux = position.copy();
    aux.sub(v);
    mod = aux.mag();  
    if (mod < 15) hit = true;
  }

  return hit;
}
